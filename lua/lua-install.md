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

Validación de integración de nginx con lua
-------------------------------------------
https://github.com/openresty/lua-nginx-module/#installation  
Creamos un nuevo archivo de configuracion lua.conf en /etc/nginx/conf.d para no ensuciar nuestra configuracion por defecto.  
Editamos el archivo /etc/nginx/conf.d/lua.conf
```sh
vi /etc/nginx/conf.d/lua.conf
```

Agregamos las siguientes lineas de codigo
```sh

server {
    listen       8080 default_server;
    server_name  localhost;

    error_log    /var/log/nginx/api-gateway-error.log debug;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;
    
    # No tocamos el location por default
    location / {
        default_type text/html;
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    
    # Creamos un nuevo location 
    location /lua_content {
         # MIME type determined by default_type:
         default_type 'text/plain';
         
         # Agregamos un bloque de codigo lua que se ejecutara al llegar a este location
         content_by_lua_block {
             ngx.say('Hello,world!')
         }
     }
}
```
Para validar invocamos la url  
http://localhost:8080/lua_content

Transforma a JSON con sodico integramente lua sin librerias adiconales
----------------------------------------------------------------------  
http://regex.info/blog/lua/json  

He codificado algunas rutinas de codificación / descodificación JSON simples en Lua puro y pensé en compartirlas en caso de que alguien más las encontrara útiles. Los uso en Adobe Lightroom, pero son Lua 5 puros, por lo que se pueden usar en cualquier lugar donde esté Lua.  

```sh
JSON = (loadfile "/etc/nginx/src/lua/JSON.lua")() -- one-time load of the routines  

-- decode example JSON String a JSON Object
local lua_value = JSON:decode(raw_json_text) 


-- encode example JSON Object a JSON String
local raw_json_text    = JSON:encode(lua_table_or_value)       
-- "pretty printed" version JSON Object a JSON String
local pretty_json_text = JSON:encode_pretty(lua_table_or_value) 
```






