

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

ngx.var.rediskid = res;

--ngx.say("REDISKID " .. tostring(ngx.var.rediskid))

ngx.exec("/kidcheck")













