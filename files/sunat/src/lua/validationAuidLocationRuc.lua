local function validateAuid(recursoValue, valueCompare)
  ngx.log(ngx.NOTICE, '*** recursoValue : ' .. recursoValue)
  ngx.log(ngx.NOTICE, '*** valueCompare : ' .. valueCompare)
  
  v, one, segundoContexto, tercerContexto = string.match(recursoValue, '/(%a+)(%d+)/(%a+)/(%a+)')
  primerContexto = v .. one
  concatToCompare = "/"..primerContexto .. "/" .. segundoContexto .. "/".. tercerContexto
  
  if(concatToCompare == valueCompare) then
    return true
  end
  
  return false

end


local cjson = require "cjson"
local jwt = require "resty.jwt"

local jwt_token = string.sub(ngx.req.get_headers()["authorization"], 8)
ngx.log(ngx.NOTICE,'**** jwt_token : ' .. jwt_token)
local jwt_obj = jwt:verify("lua-resty-jwt", jwt_token)
local encode  = cjson.encode(jwt_obj)
ngx.log(ngx.NOTICE,'**** encode : ')
ngx.log(ngx.NOTICE,'-----------------------------------------------------')
ngx.log(ngx.NOTICE,'')
ngx.log(ngx.NOTICE,encode)
ngx.log(ngx.NOTICE,'')
ngx.log(ngx.NOTICE,'-----------------------------------------------------')
--PARSING JSON
local parseJsonJWT = cjson.decode(encode)
local parseJsonAud = cjson.decode(parseJsonJWT.payload.aud)



local existe = false

local apiValue = ngx.var.scheme .. "://" ..  ngx.var.host

local recursoValue = ngx.var.uri

--OBTENIENDO SI EXISTE LA AUDIENCIA
for i, ivalue in pairs(parseJsonAud) do
	if(ivalue.api == apiValue) then
		for j, jrecurso in pairs(ivalue.recurso) do
			--ngx.print(jrecurso.id .. "\n")			
			if(validateAuid(recursoValue, jrecurso.id)) then	
				existe = true
				--return 1			
				break
			end
		end
	end
end


ngx.log(ngx.NOTICE,existe)

--ROUTER
if(existe) then
	return 1
else
	return 0

end
