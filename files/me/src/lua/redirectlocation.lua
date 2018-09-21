

local ngx_var1 = ngx.var.rediskid;
local ngx_var2 = ngx.var.var_header_alg;
local ngx_var3 = ngx.var.var_header_kid;
local ngx_var4 = ngx.var.var_payload_sub;
local ngx_var5 = ngx.var.var_payload_iss;
local location = "";

if ngx_var3 == ngx_var1 then
    --ngx.say("true")
    --ngx.say("true, kid del nginx (" .. ngx_var3.. ") SI coincide con el kid del redis (" .. ngx_var1.. ")")
    location = "/lua_content";
    --ngx.say(location)
else
    --ngx.say("false") 
    --ngx.say("false, kid del nginx (" .. ngx_var3.. ") NO coincide con el kid del redis (" .. ngx_var1.. ")")
    location = "/lua_content2"
    --ngx.say(location)
end

ngx.exec(tostring(location))



ngx.say("var_header_alg alg: " .. tostring(ngx_var2))
ngx.say("var_header_kid kid: " .. tostring(ngx_var3))
ngx.say("var_payload_sub sub: " .. tostring(ngx_var4))
ngx.say("var_payload_iss iss: " .. tostring(ngx_var5))














