# nginx
Proyectos nginx

Datos Generales
----------------
Rutas de archivos de configuracion: 
/etc/nginx/nginx.conf

Metodos para iniciar nginx:
Existen 2 metodos para iniciar nginx
  * Por proceso: 
    ` # nginx `
    # ps -aux | grep 
  - Por servicio: 
    # systemctl start nginx
    # systemctl stop nginx
    # systemctl restart nginx
  
Para ver la version:
    # nginx -v

Para ver los modulos configurados durante la instalacion
    # nginx -V

Para probar que los archivos de configuracion esten bien
    # nginx -t
    
Para enviar una señal a nginx
  - Para recargar los archivos de configuracion sin reiniciar
    # nginx -s reload

Archivos de configuracion de nginx
-----------------------------------





    
    
