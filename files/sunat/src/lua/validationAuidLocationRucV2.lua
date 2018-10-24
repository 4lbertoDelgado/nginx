
-- OBJETIVO: evaluar si el recurso (location) solicitado es igual al recurso que viene en la aud del token
-- la especificacion de la aud del token se genera de BD de acuerdo a los permisos que tenga el usuario que requiere el recurso
-- en esta nueva version, adicionalmente comparamos el indicador y la clave de ceros y unos gt que vienen en la aud del token 
-- y el grant_type que viene en el token

-- ---------------------------------------------------------------
-- Funcion que compara si recurso del api del auid del token es igual al recurso solicitado del request
local function validateAuid(recursoValue, valueCompare)
  ngx.log(ngx.NOTICE, '*** recursoValue : ' .. recursoValue)
  ngx.log(ngx.NOTICE, '*** valueCompare : ' .. valueCompare)
  
  -- armamos el valor de recursoValue del request
  -- /v1/contribuyente/contribuyentes/
  v, one, segundoContexto, tercerContexto = string.match(recursoValue, '/(%a+)(%d+)/(%a+)/(%a+)')
  primerContexto = v .. one
  concatToCompare = "/"..primerContexto .. "/" .. segundoContexto .. "/".. tercerContexto
	
  -- y comparamos cada recurso del api del auid del token con el recursoValue del request
  if(concatToCompare == valueCompare) then
    return true
  end
  return false
end
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
ngx.log(ngx.NOTICE,'**** encode : ')
ngx.log(ngx.NOTICE,'-----------------------------------------------------\n')
ngx.log(ngx.NOTICE,'')
ngx.log(ngx.NOTICE,encode)
ngx.log(ngx.NOTICE,'')
ngx.log(ngx.NOTICE,'-----------------------------------------------------\n')

-- decodificamos ese json string en un objeto json
local parseJsonJWT = cjson.decode(encode)

-- decodificamos la aud de ese objeto json en un objeto json
local parseJsonAud = cjson.decode(parseJsonJWT.payload.aud)

-- definimos la variable existe como false
local existe = false

-- cuando llega el request, viene que api y que recurso (location) es el que desea consumir
-- dentro de la auid del token vienen diferentes apiValue y recursos de esas apis a la que tiene acceso el usuario 
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

-- armamos el valor de apiValue del request
local apiValue = ngx.var.scheme .. "://" ..  ngx.var.host
-- armamos el valor de recursoValue del request
local recursoValue = ngx.var.uri

-- VALIDAMOS SI EXISTE LA AUDIENCIA
-- recorremos las api del auid del token
for i, ivalue in pairs(parseJsonAud) do
	-- y comparamos cada api del auid del token con el apiValue del request
	if(ivalue.api == apiValue) then
		-- recorremos los recurso del api del auid del token 
		for j, jrecurso in pairs(ivalue.recurso) do
			--ngx.print(jrecurso.id .. "\n")
			-- y comparamos cada recurso del api del auid del token con el recursoValue del request
			if(validateAuid(recursoValue, jrecurso.id, jrecurso.indicador, jrecurso.gt, ngx.var.jwt_claim_grantType)) then	
				existe = true
				--return 1			
				break
			end
		end
	end
end

ngx.log(ngx.NOTICE,'El recurso solicitado existe: '..existe)

-- Retorno del codigo lua
if(existe) then
	return 1
else
	return 0
end
