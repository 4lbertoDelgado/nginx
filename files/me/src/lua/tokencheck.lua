-- Cargamos las librerias necesarias
local cjson = require "cjson"
local jwt = require "resty.jwt"

local token
local token2
local kid
local kid2
local aud
local aud2
local uri

-- Primero intentamos encontrar el JWT token como parametro de la url e.g. ?token=BLAH
token = ngx.var.arg_token

-- Segundo intentamos encontrar el JWT token como Cookie e.g. token=BLAH
if token == nil then
    token = ngx.var.cookie_token
end

-- Tercero intentamos encontrar el JWT token en el Authorization header Bearer string
-- Forma 1 de obtener el token desde una variable del nginx
if token == nil then
    local auth_header = ngx.var.http_Authorization
    if auth_header then
        _, _, token = string.find(auth_header, "Bearer%s+(.+)")
    end
end

-- Forma 2 de obtener el token desde codigo lua
if token2 == nil then
    local auth_header = ngx.req.get_headers()["Authorization"]
    if auth_header then
        _, _, token2 = string.find(auth_header, "Bearer%s+(.+)")
    end
end

-- Finalmente, si no hay JWT token, mostramos un error and salimos
if token == nil then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say("{\"error\": \"missing JWT token or Authorization header\"}")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end


-- Forma 1 de obtener el kid desde una variable del nginx
kid = ngx.var.jwt_header_kid
aud = ngx.var.jwt_claim_aud

-- Forma 2 de obtener el kid desde codigo lua
-- Con load_jwt cargamos el token como objeto para accder a sus propiedades
local jwt_obj = jwt:load_jwt(token)

-- validamos que el jwt sea correcto
if not jwt_obj.valid then
  ngx.status = ngx.HTTP_BAD_REQUEST
  ngx.say("invalid jwt")
  ngx.exit(ngx.HTTP_OK)
end

kid2 = jwt_obj.header.kid
aud2 = jwt_obj.payload.aud

-- validamos que kid exista
if kid == nil then
  ngx.status = ngx.HTTP_BAD_REQUEST
  ngx.say("missing kid")
  ngx.exit(ngx.HTTP_OK)
end

-- Utilizamos la libreria cjson para mostrar el token string en formato json string
-- Se utiliza el metodo verify para verificar la estructura del token antes de encodificarlo en un json string

local jwt_obj2 = jwt:verify("lua-resty-jwt", token)

-- Con encode convertimos, codificamos  el token que es un string en un json string
-- (encode devuelve un string)
-- (decode se puede utilizar para convertir ese string en un objeto json y acceder a sus propiedades)

local encode = cjson.encode(jwt_obj2)
ngx.say(encode)

-- Obtenemos la uri del request
uri = ngx.var.uri

--------------------------------------------------------------------


-- Explicitly read the req body
ngx.req.read_body()

local body = ngx.req.get_body_data()
local header = ngx.req.get_headers()
ngx.say("=======================================")
ngx.say("body data:")
ngx.say(body)
ngx.say("header data:")
-- ngx.say(header)
ngx.say("=======================================")
ngx.say(tostring(token))
ngx.say(tostring(token2))
ngx.say("=======================================")
ngx.say(kid)
ngx.say(kid2)
ngx.say(aud)
ngx.say(aud2)
ngx.say(uri)











