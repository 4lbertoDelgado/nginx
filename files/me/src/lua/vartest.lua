local ngx_var = ngx.var.var_thing;
local ngx_undef = ngx.var.undefined_var;
local ngx_var2 = ngx.var.var_thing2;

ngx.say("var_thing is type: " .. type(ngx_var))
ngx.say("var_thing contains: " .. tostring(ngx_var))

ngx.say("undefined_var is type: " .. type(ngx_undef))
ngx.say("undefined_var contains: " .. tostring(ngx_undef))

ngx.say("var_thing2 is type: " .. type(ngx_var2))
ngx.say("var_thing2 contains: " .. tostring(ngx_var2))
