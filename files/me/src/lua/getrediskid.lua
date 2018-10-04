

-- Conexion a redis

local redis = require "resty.redis"
local red = redis:new()

local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

local res, err = red:get("kid")
if not res then
    ngx.say("failed to get kid: ", err)
    return
end

if res == ngx.null then
    ngx.say("kid not found.")
    return
end

local ok, err = red:close()
if not ok then
    ngx.say("failed to close: ", err)
    return
end

-- Pasamos el resultado obtenido a una variable de nginx
ngx.var.rediskid = res;

-- No se debe de usar un ngx.say antes de la redireccion porque dara un ERROR
-- ngx.say("REDISKID " .. tostring(ngx.var.rediskid))

-- Redirecionamos a otro location
ngx.exec("/kidcheck")













