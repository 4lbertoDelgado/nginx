
Instalar nginx
-----------------------------------
nginx-plus-15-2.el7.ngx.x86_64.rpm

Instalar los mudulos de ndk y lua de nginx en ese orden
--------------------------------------------------------
Estos modulos son necesarios para enganchar nginx con lua  
https://github.com/openresty/lua-nginx-module  

nginx-plus-module-ndk-15+0.3.0-2.el7.ngx.x86_64.rpm  
nginx-plus-module-lua-15+0.10.13-2.el7.ngx.x86_64.rpm  

Instalar plugins adicionales a lua basados en codigo lua
---------------------------------------------------------
Crear el siguiente directorio lua-plugins en /etc/nginx  
mkdir -p /etc/nginx/lua-plugins  
  
En el directorio /etc/nginx/lua-plugins descargar los siguientes plugins  
Estos plugins son necesarios para agregarles funcionabilidades al codigo lua

Funcionabilidades de hash  
https://github.com/jkeys089/lua-resty-hmac  
lua-resty-hmac

Funcionabilidades de JWT  
https://github.com/SkyLothar/lua-resty-jwt  
lua-resty-jwt

Utilidades para conexion con redis  
https://github.com/openresty/lua-resty-redis  
lua-resty-redis

Utilidades de cadena y funciones hash comunes  
https://github.com/openresty/lua-resty-string  
lua-resty-string

Copiar de directorio lua-plugins, los plugins en la ruta indicada.

Instalar plugins adicionales a lua basados en codigo c
-------------------------------------------------------
Crear el directorio








