--Objetivo: un certificado recibido en un XML

----------------------------------------------------------------------------------------
--Funcion que obtiene el valor desde el XML que viene en el body del request
function GetValueFromXML(XML_string, XMLvalue)
    local Longitud = string.len(XMLvalue)
        local XML_string = string.gsub( XML_string, "UsernameToken", "Replace" )
        local ReturnValue = '';
    local primera1   = string.find(XML_string, XMLvalue,1)
        local segunda1   = string.find(XML_string, XMLvalue, primera1 + Longitud)
        local cadena1 = string.sub(XML_string,primera1,segunda1)
        local primera2   = string.find(cadena1,">")
        local segunda2   = string.find(cadena1,"<")
        if  (nil ~=  primera2 and nil ~=  segunda2) then
            ReturnValue = string.sub(cadena1,primera2+1,segunda2-1)
        end

        return ReturnValue
end

--function GetValueFromXML(XML_string, XMLvalue)
   --local XMLvalueLength=string.len(XMLvalue)+2
   --local XMLvalueStartPos=string.find(XML_string,"<" .. XMLvalue .. ">")+XMLvalueLength
   --local XMLvalueEndPos=string.find(XML_string,"</" .. XMLvalue .. ">")
   --local ReturnValue=string.sub(XML_string,XMLvalueStartPos,XMLvalueEndPos-1)
   --return ReturnValue
--end

-----------------------------------------------------------------------------------------
--Explicitamente leemos el body del req
ngx.req.read_body()
local bodyXml = ngx.req.get_body_data()

--Usamos la funcion para obtener el valor del XML
local ssl = GetValueFromXML(bodyXml,"BinarySecurityToken")

--Escribimos en el log de nginx
ngx.log(ngx.NOTICE,"ssl",ssl)

--Abrimos y si no existe lo creamos un archivo en SO en modo WRITE
file = io.open("/tmp/certificate.crt", "w")
--Especificamos que todas las salidas generadas se asignaran al archivo anteriormente cargado
io.output(file)
--Escribimos en el archivo
io.write("-----BEGIN CERTIFICATE-----\n")
io.write(ssl)
io.write("\n-----END CERTIFICATE-----")
--Cerramos el archivo
io.close(file)

--Ejecutamos directamente un comando de SO y lo asignamos a una variable local
local comodin = io.popen("openssl x509 -noout -subject -in /tmp/certificate.crt | sed -n '/^subject/s/^.*OU=//p'")
local dniVal = "%d%d%d%d%d%d%d%d%d%d%d"

--local cn1 = cn:read("*a")
--local ou1 = ou:read("*a")
--cn:close()
--ou:close()
--ngx.log(ngx.NOTICE,"cn1--->",cn1)
--ngx.log(ngx.NOTICE,"ou1--->",ou1)

--Leemos todo el resultado que devuelvee el del comando
local comodin1 = comodin:read("*a")
--Cerramos la ejecucion del comando
comodin:close()

local comun = string.sub(comodin1, string.find(comodin1, dniVal))
ngx.log(ngx.NOTICE,"comodin1--->--",comodin1)
ngx.log(ngx.NOTICE,"comun--->--",comun)

