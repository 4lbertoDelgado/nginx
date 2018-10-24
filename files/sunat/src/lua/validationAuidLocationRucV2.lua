
-- OBJETIVO: evaluar si el recurso (location) solicitado es igual al recurso que viene en la aud del token
-- la especificacion de la aud del token se genera de BD de acuerdo a los permisos que tenga el usuario que requiere el recurso
-- en esta nueva version, adicionalmente comparamos el indicador y la secuencia de ceros y unos gt que vienen en la aud del token 
-- y el grantType que viene en el token
-- ---------------------------------------------------------------------------------------

-- Funcion que compara si recurso del api del aud del token es igual al recurso solicitado del request
function validateAuid(recursoValue, valueCompare, indicador, gt, grantType)
  ngx.log(ngx.NOTICE, '*** recursoValue : ' .. recursoValue)
  ngx.log(ngx.NOTICE, '*** valueCompare : ' .. valueCompare)
  
  -- armamos el valor de recursoValue del request
  -- /v1/contribuyente/contribuyentes/
  v, one, segundoContexto, tercerContexto = string.match(recursoValue, '/(%a+)(%d+)/(%a+)/(%a+)')
  primerContexto = v .. one
  concatToCompare = "/"..primerContexto .. "/" .. segundoContexto .. "/".. tercerContexto
	
  -- y comparamos cada recurso del api del aud del token con el recursoValue del request
  if(concatToCompare == valueCompare) then
    -- retorna el resultado de ejecutar la funcion valIndicatorAndGt de validacion del indicador, de secuencia de ceros y unos gt y el grantType
    return valIndicatorAndGt(indicador, gt, grantType)
  end
  return false
end

-- Funcion que valida indicador, gt y grantType
function valIndicatorAndGt(indicador, gt, grantType)
  -- validamos si indicador es nulo o vacio
  if  (nil ==  indicador or '' == indicador) then
    return false
  end
  -- validamos si gt es nulo o vacio
  if  (nil ==  gt or '' == gt) then
    return false
  end
  -- validamos si grantType es nulo o vacio
  if  (nil ==  grantType or '' == grantType) then
    return false
  end
	
  -- validamos si indicador es 0 (es decir publico)
  if(indicador == "0") then
    -- retorna el resultado de ejecutar la funcion de validacion de secuencia de ceros y unos gt y el grantType
    return valGt(gt, grantType)
  end
  -- validamos si indicador es 1 (es decir privado)
  if(indicador == "1") then
    -- validamos si grantType NO es client_credentials
    if(grantType  ~= 'client_credentials') then
      -- retorna el resultado de ejecutar la funcion valGt de validacion de secuencia de ceros y unos gt y el grantType
      return valGt(gt, grantType)
     else 
      return false
    end
  end
	
  return false
end

-- Funcion que valida el gt y el grantType para hacer match
-- segun especificacion gt tiene 6 digitos 111111 y un 1 habilita un 0 deshabilita
-- 1er digito corresponde al flujo del OAUTH (grantType) password
-- 2do digito corresponde al flujo del OAUTH (grantType) client_credentials
function valGt(gt, grantType)
  -- validamos si secuencia de ceros y unos gt su primer digito de los 6 que usa es 1 (100000) 
  if(string.sub(gt, 1, 1) == '1') then
    -- validamos si grantType es password
    if(grantType == 'password') then
      return true
    end
  end
  -- validamos si secuencia de ceros y unos gt su segundo digito de los 6 que usa es 1 (010000) 
  if(string.sub(gt, 2, 2) == '1') then
    -- validamos si grantType es client_credentials
    if(grantType == 'client_credentials') then
      return true
    end
  end
  
  return false
end

-[[ Procedimiento para obtener la AUD
-- ---------------------------------------------------------------
-- Cargamos las librerias cjson y resty.jwt
local cjson = require "cjson"
local jwt = require "resty.jwt"

-- obtenemos el token string
local jwt_token = string.sub(ngx.req.get_headers()["authorization"], 8)
ngx.log(ngx.NOTICE,'**** jwt_token : ' .. jwt_token)

-- verificamos que la estructura sea la correcta de ese token string
local jwt_obj = jwt:verify("lua-resty-jwt", jwt_token)

-- encodificamos ese token string en un json string
local encode  = cjson.encode(jwt_obj)
ngx.log(ngx.NOTICE,'**** encode : ' .. encode)

-- decodificamos ese json string en un objeto json
local parseJsonJWT = cjson.decode(encode)

-- decodificamos la aud de ese objeto json en un objeto json
local parseJsonAud = cjson.decode(parseJsonJWT.payload.aud)
-- ---------------------------------------------------------------------------------------
]]

-[[ Procedimiento para obtener la AUD desde variable NGINX ]]
-- ---------------------------------------------------------------------------------------
-- Funcion que parsea AUD con libreria cjson
function parseAud(aud)
	local cjson = require "cjson"
	return cjson.decode(aud)
end

-- INICIO DE PROGRAMA
--========================================================================================
-- LOGICA VALIDA AUDIENCIA 
-- Implementada para resolver el caso que AUD NO VENGA como STRING y al decodificar con cjson de ERROR
------------------------------------------------------------------------------------------
-- validamos si AUD es nulo o vacio
if  (nil ==  ngx.var.jwt_claim_aud or '' == ngx.var.jwt_claim_aud) then
	return 0
end

-- pcall llama a la funcion parseAud y le envia como parametro la AUD capturada desde la variable nginx
-- pcall captura el error en caso hubiera al llamar a la funcion parseAud y lo almacena en okParseAud
local okParseAud, parseJsonAud = pcall(parseAud, ngx.var.jwt_claim_aud) 

-- validamos si hubo algun error al momento de parsear la AUD
if(not okParseAud) then
   return 0
end
------------------------------------------------------------------------------------------

-- definimos la variable resultAud como false
local resultAud = false

-- cuando llega el request, viene que api y que recurso (location) es el que desea consumir
-- dentro de la aud del token vienen diferentes apiValue y recursos de esas apis a la que tiene acceso el usuario 
-- la variable apiValue sirve para encontrar dentro del aud del token a que api se tiene acceso
-- la variable recursoValue sirve para encontrar dentro del api del aud del token a que recurso(id) se tiene acceso
-- JSON TOKEN
--   |-- auid :
--       |-- [
--           |-- {
--               |-- \"api\":\"https://api.sunat.gob.pe\",
--                   |-- \"recurso\":
--                       |-- [
--                           |-- {
--                               |-- \"id\":\"/v1/contribuyente/contribuyentes\",
--                               |-- \"indicador\":\"1\",
--                               |-- \"gt\":\"100000\"
--                           |-- },
--                           |-- {
--                               |-- \"id\":\"/des/pathrecurso3\",
--                               |-- \"indicador\":\"1\",
--                               |-- \"gt\":\"100000\"
--                           |-- },
--                           |-- {
--                               |-- \"id\":\"/v1/contribuyente/consulta/t/consultaunificadaext/comprobante\",
--                               |-- \"indicador\":\"1\",
--                               |-- \"gt\":\"100000\"
--                           |-- }
--                       |-- ]
--           |-- },
--           |-- {
--               |-- \"api\":\"https://api-cpe.sunat.gob.pe\",
--                   |-- \"recurso\":
--                       |-- [
--                       |-- ]
--           |-- },
--           |-- {
--               |-- \"api\":\"https://api-cuentaunica.sunat.gob.pe\",
--                   |-- \"recurso\":
--                       |-- [
--                       |-- ]
--           |-- }
--       |-- ]
--   |-- grantType : password

-- eyJraWQiOiJhcGkuc3VuYXQuZ29iLnBlLmtpZDAwMSIsInR5cCI6IkpXVCIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiIyMDUwODcyMDE3NCIsImF1ZCI6Ilt7XCJhcGlcIjpcImh0dHBzOlwvXC9hcGkuc3VuYXQuZ29iLnBlXCIsXCJyZWN1cnNvXCI6W3tcImlkXCI6XCJcL3YxXC9jb250cmlidXllbnRlXC9jb250cmlidXllbnRlc1wiLFwiaW5kaWNhZG9yXCI6XCIxXCIsXCJndFwiOlwiMTAwMDAwXCJ9LHtcImlkXCI6XCJcL2Rlc1wvcGF0aHJlY3Vyc28zXCIsXCJpbmRpY2Fkb3JcIjpcIjFcIixcImd0XCI6XCIxMDAwMDBcIn0se1wiaWRcIjpcIlwvdjFcL2NvbnRyaWJ1eWVudGVcL2NvbnN1bHRhXC90XC9jb25zdWx0YXVuaWZpY2FkYWV4dFwvY29tcHJvYmFudGVcIixcImluZGljYWRvclwiOlwiMVwiLFwiZ3RcIjpcIjEwMDAwMFwifV19LHtcImFwaVwiOlwiaHR0cHM6XC9cL2FwaS1jcGUuc3VuYXQuZ29iLnBlXCIsXCJyZWN1cnNvXCI6W119LHtcImFwaVwiOlwiaHR0cHM6XC9cL2FwaS1jdWVudGF1bmljYS5zdW5hdC5nb2IucGVcIixcInJlY3Vyc29cIjpbXX1dIiwidXNlcmRhdGEiOnsibnVtUlVDIjoiMjA1MDg3MjAxNzQiLCJ0aWNrZXQiOiIxMjk3MTE1MDU2NDIxIiwibnJvUmVnaXN0cm8iOiIiLCJhcGVNYXRlcm5vIjoiIiwibG9naW4iOiIyMDUwODcyMDE3NE1PRERBVE9TIiwibm9tYnJlQ29tcGxldG8iOiJTT0xFUkEgU1lTVEVNUyBTLkEuQy4iLCJub21icmVzIjoiU09MRVJBIFNZU1RFTVMgUy5BLkMuIiwiY29kRGVwZW5kIjoiMDAyMyIsImNvZFRPcGVDb21lciI6IiIsImNvZENhdGUiOiIiLCJuaXZlbFVPIjowLCJjb2RVTyI6IiIsImNvcnJlbyI6IiIsInVzdWFyaW9TT0wiOiJNT0REQVRPUyIsImlkIjoiIiwiZGVzVU8iOiIiLCJkZXNDYXRlIjoiIiwiYXBlUGF0ZXJubyI6IiIsImlkQ2VsdWxhciI6bnVsbCwibWFwIjp7ImlzQ2xvbiI6ZmFsc2UsImRkcERhdGEiOnsiZGRwX251bXJ1YyI6IjIwNTA4NzIwMTc0IiwiZGRwX251bXJlZyI6IjAwMjMiLCJkZHBfZXN0YWRvIjoiMDAiLCJkZHBfZmxhZzIyIjoiMDAiLCJkZHBfdWJpZ2VvIjoiMTUwMTQwIiwiZGRwX3RhbWFubyI6IjAzIiwiZGRwX3Rwb2VtcCI6IjM5IiwiZGRwX2NpaXUiOiI3MjIwMiJ9LCJpZE1lbnUiOiIxMjk3MTE1MDU2NDIxIiwiam5kaVBvb2wiOiJwMDAyMyIsInRpcFVzdWFyaW8iOiIwIiwidGlwT3JpZ2VuIjoiSVQiLCJwcmltZXJBY2Nlc28iOnRydWV9fSwibmJmIjoxNTQwMzk5ODU2LCJjbGllbnRJZCI6IjI1MWJhMzY3LTMyODMtOGYxMC1hNTE3LTlkZjFjODEzZTE4OSIsImlzcyI6Imh0dHBzOlwvXC9hcGktc2VndXJpZGFkLnN1bmF0LmdvYi5wZVwvdjFcL2NsaWVudGVzc29sXC8yNTFiYTM2Ny0zMjgzLThmMTAtYTUxNy05ZGYxYzgxM2UxODlcL29hdXRoMlwvdG9rZW5cLyIsInByb2ZpbGVzIjpbIipWSVNJQkxFKiIsIipNRU5VKiJdLCJleHAiOjE1NDA0MDM0NTYsImdyYW50VHlwZSI6InBhc3N3b3JkIiwiaWF0IjoxNTQwMzk5ODU2fQ.SXSnhxENEgPbwKAc10W8Ob-GOutii8JmRKZ28DqgVupczZH72MFu2r1VSDJG4IhZnZ8y53HyLeG1HoE79P572WjoHOKmH7Bbb1mZvGAOfKc9YSPN52K4SB5xJvZ4oiegHmRZka0Cbu34hTsNZlEKJt2gdeoQyMtcUzfOwHTsSdNNPDMSWy4FNZU7Yv8lOEcLaAui1aI3bd_v_spppbpu4MDonXzhQYQo0wNnAQt7phV3CwdU0iv-A9MTi4oafoXWeSpnMKsGHGBOrsmGCBqPLu1HbV9gXXZ0-f4fN97bLNiYjX3hYzZzPVwquMLpXuX7CcON0K_GeAk3Kh1GwgzSAw

-- armamos el valor de apiValue del request
local apiValue = ngx.var.scheme .. "://" ..  ngx.var.host
-- armamos el valor de recursoValue del request
local recursoValue = ngx.var.uri

-- VALIDAMOS SI EXISTE LA AUDIENCIA
-- recorremos las api del aud del token
for i, ivalue in pairs(parseJsonAud) do
	-- y comparamos cada api del aud del token con el apiValue del request
	if(ivalue.api == apiValue) then
		-- recorremos los recurso del api del aud del token 
		for j, jrecurso in pairs(ivalue.recurso) do
			--ngx.print(jrecurso.id .. "\n")
			-- y comparamos cada recurso del api del aud del token con el recursoValue del request
			if(validateAuid(recursoValue, jrecurso.id, jrecurso.indicador, jrecurso.gt, ngx.var.jwt_claim_grantType)) then	
				resultAud = true
				--return 1			
				break
			end
		end
	end
end

ngx.log(ngx.NOTICE,'El recurso solicitado existe: '..resultAud)

-- Retorno del codigo lua
if(resultAud) then
	return 1
else
	return 0
end
