
Instalar nginx

nginx-plus-15-2.el7.ngx.x86_64.rpm

Instalar los mudulos de ndk y lua de nginx en ese orden
Estos modulos son necesarios para enganchar nginx con lua
https://github.com/openresty/lua-nginx-module

nginx-plus-module-ndk-15+0.3.0-2.el7.ngx.x86_64.rpm
nginx-plus-module-lua-15+0.10.13-2.el7.ngx.x86_64.rpm

Crear el siguiente directorio lua-plugins en /etc/nginx
mkdir -p /etc/nginx/lua-plugins

En el directorio /etc/nginx/lua-plugins descargar los siguientes plugins
Estos plugins son necesarios para agregarles funcionabilidades al codigo lua

https://github.com/jkeys089/lua-resty-hmac
lua-resty-hmac

lua-resty-jwt
lua-resty-redis

https://github.com/openresty/lua-resty-string
lua-resty-string

