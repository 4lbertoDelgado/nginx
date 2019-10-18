
--Lua que desencripta un certificado recibido en un XML
--17/10/2019
--Pierre Delgado

--Funcion que obtiene el valor desde el XML que viene en el body del request
function GetValueFromXML(XML_string, XMLvalue)
   local XMLvalueLength=string.len(XMLvalue)+2
   local XMLvalueStartPos=string.find(XML_string,"<" .. XMLvalue .. ">")+XMLvalueLength
   local XMLvalueEndPos=string.find(XML_string,"</" .. XMLvalue .. ">")
   local ReturnValue=string.sub(XML_string,XMLvalueStartPos,XMLvalueEndPos-1)
   return ReturnValue
end

--Explicitamente leemos el body del req
ngx.req.read_body()
local bodyXml = ngx.req.get_body_data()

--_Usamos la funcion para obtener el valor del XML
local ssl = GetValueFromXML(bodyXml,"wsse:BinarySecurityToken")

--Ejemplo de como asignar un certificado estatico
--local raw_data = [=[
-------BEGIN CERTIFICATE-----
--MIIBoDCCAUoCAQAwDQYJKoZIhvcNAQEEBQAwYzELMAkGA1UEBhMCQVUxEzARBgNV
--BAgTClF1ZWVuc2xhbmQxGjAYBgNVBAoTEUNyeXB0U29mdCBQdHkgTHRkMSMwIQYD
--VQQDExpTZXJ2ZXIgdGVzdCBjZXJ0ICg1MTIgYml0KTAeFw05NzA5MDkwMzQxMjZa
--Fw05NzEwMDkwMzQxMjZaMF4xCzAJBgNVBAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0
--YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQxFzAVBgNVBAMT
--DkVyaWMgdGhlIFlvdW5nMFEwCQYFKw4DAgwFAANEAAJBALVEqPODnpI4rShlY8S7
--tB713JNvabvn6Gned7zylwLLiXQAo/PAT6mfdWPTyCX9RlId/Aroh1ou893BA32Q
--sggwDQYJKoZIhvcNAQEEBQADQQCU5SSgapJSdRXJoX+CpCvFy+JVh9HpSjCpSNKO
--19raHv98hKAUJuP9HyM+SUsffO6mAIgitUaqW8/wDMePhEC3
-------END CERTIFICATE-----
--]=]

--Ejemplo de como ejecutar una shell del SO
--os.execute('/root/mongolito.sh')

--Ejemplo de como ejecutar un comando del SO leer el resultado que devuelve
--local handle = io.popen("echo 'test'")
--local result = handle:read("*a")
--handle:close()
--ngx.say(result)

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
local handle = io.popen("openssl x509 -noout -subject -in /tmp/certificate.crt | sed -n '/^subject/s/^.*CN=//p'")
--Leemos todo el resultado que devuelvee el del comando
local result = handle:read("*a")
--Cerramos la ejecucion del comando
handle:close()

--Mostramos el resultado
ngx.say(result)

