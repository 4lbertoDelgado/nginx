
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
```sh
mkdir -p /etc/nginx/lua-plugins  
```

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

Copiar de directorio plugins-lua, los plugins en la ruta indicada.

Instalar plugins adicionales a lua basados en codigo c
-------------------------------------------------------
Crear el directorio /usr/local/lib/lua/5.1/  
```sh
mkdir -p /usr/local/lib/lua/5.1/
```
En el directorio /usr/local/lib/lua/5.1/ descargar los siguientes plugins  

Lua CJSON is a fast JSON encoding/parsing module for Lua  
https://github.com/openresty/lua-cjson  
Descargar fuentes  
https://www.kyne.com.au/~mark/software/lua-cjson.php  
Manual instalacion de Funetes  
https://www.kyne.com.au/~mark/software/lua-cjson-manual.html#_installation  

Copiar de directorio plugins-c, los plugins en la ruta indicada.

Cargar modulos de lua y plugins en nginx
------------------------
Editar el archivo de configuracion de nginx.conf ubicado en /etc/nginx/  
```sh
vi /etc/nginx/nginx.conf
```
Al inicio del documento, como una directiva libre agregar  
```sh
#Cargando modulos lua
load_module modules/ndk_http_module.so;
load_module modules/ngx_http_lua_module.so;
```
En la directiva http se debe agregar la configuracion para cargar los plugins
```sh
# Establecemos las rutas de búsqueda para bibliotecas externas Lua puras
lua_package_path "/etc/nginx/lua-plugins/lua-resty-string/lib/?.lua;/etc/nginx/lua-plugins/lua-resty-hmac/lib/?.lua;/etc/nginx/lua-plugins/lua-resty-redis/lib/?.lua;/etc/nginx/lua-plugins/lua-resty-jwt/lib/?.lua;;";

# Establecemos las rutas de búsqueda para bibliotecas externas de Lua escritas en C
lua_package_cpath "/usr/local/lib/lua/5.1/?.so;;";
```






