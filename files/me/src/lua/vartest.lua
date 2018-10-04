-- Asignamos los valores de variables de nginx a variables locales lua
local ngx_var = ngx.var.var_thing;
local ngx_undef = ngx.var.undefined_var;

ngx.say("var_thing is type: " .. type(ngx_var))
ngx.say("var_thing contains: " .. tostring(ngx_var))

ngx.say("undefined_var is type: " .. type(ngx_undef))
ngx.say("undefined_var contains: " .. tostring(ngx_undef))

