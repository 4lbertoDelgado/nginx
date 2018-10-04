
-- Asignamos una variable de nginx a una variable local en luai
-- Las variables deben existir previamente en nginx

local ngx_var = ngx.var.var_thing;
local ngx_undef = ngx.var.undefined_var;
local ngx_var2 = ngx.var.var_header_alg;
local ngx_var3 = ngx.var.var_header_kid;
local ngx_var4 = ngx.var.var_payload_sub;
local ngx_var5 = ngx.var.var_payload_iss;


local kid = "0001";


if ( ngx_var3 == kid ) then
    ngx.say("true, kid del nginx coincide con el de redis")
    --return ngx.redirect("/lua_content")
end








ngx.say("var_thing is type: " .. type(ngx_var))
ngx.say("var_thing contains: " .. tostring(ngx_var))

ngx.say("undefined_var is type: " .. type(ngx_undef))
ngx.say("undefined_var contains: " .. tostring(ngx_undef))

ngx.say("var_header_alg is type: " .. type(ngx_var2))
ngx.say("var_header_alg alg: " .. tostring(ngx_var2))
ngx.say("var_header_kid is type: " .. type(ngx_var3))
ngx.say("var_header_kid kid: " .. tostring(ngx_var3))
ngx.say("var_payload_sub is type: " .. type(ngx_var4))
ngx.say("var_payload_sub sub: " .. tostring(ngx_var4))
ngx.say("var_payload_iss is type: " .. type(ngx_var5))
ngx.say("var_payload_iss iss: " .. tostring(ngx_var5))

