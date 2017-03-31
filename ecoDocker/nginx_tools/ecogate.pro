server {

  listen   80;

  root /var/www/ecogate-tools/htdocs;
       
  index index.php index.html;

  server_name 192.168.99.100; #ecogate.tools

  location / {
    try_files $uri $uri/ /index.php;
  }
  

  location ~ \.php$ {

#    set $phproot $document_root;
    try_files $uri =404;

    fastcgi_index index.php;


    fastcgi_split_path_info       ^(.+\.php)(/.+)$;
fastcgi_pass phpfpm:9000;

    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	#    include fastcgi_params;

	#fastcgi.conf
	fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
	fastcgi_param  SERVER_SOFTWARE    nginx;
	fastcgi_param  QUERY_STRING       $query_string;
	fastcgi_param  REQUEST_METHOD     $request_method;
	fastcgi_param  CONTENT_TYPE       $content_type;
	fastcgi_param  CONTENT_LENGTH     $content_length;
	fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
	fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
	fastcgi_param  REQUEST_URI        $request_uri;
	fastcgi_param  DOCUMENT_URI       $document_uri;
	fastcgi_param  DOCUMENT_ROOT      $document_root;
	fastcgi_param  SERVER_PROTOCOL    $server_protocol;
	fastcgi_param  REMOTE_ADDR        $remote_addr;
	fastcgi_param  REMOTE_PORT        $remote_port;
	fastcgi_param  SERVER_ADDR        $server_addr;
	fastcgi_param  SERVER_PORT        $server_port;
	fastcgi_param  SERVER_NAME        $server_name;
include fastcgi_params;
    #fastcgi_pass 127.0.0.1:9400; #php5
    #fastcgi_pass phpfpm:9000; #unix:/run/php/php7.0-fpm.sock; #php7
  }
}

#server {
#    listen  80;
#
#    # this path MUST be exactly as docker-compose.fpm.volumes,
#    # even if it doesn't exists in this dock.
#    root /usr/share/nginx/html;
#    index index.php index.html index.html;
#    
#    server_name 192.168.99.100;
#
#    location / {
#        try_files $uri /index.php$is_args$args;
#    }
#
#    location ~ \.php$ {
#        fastcgi_split_path_info ^(.+\.php)(/.+)$;
#        fastcgi_pass phpfpm:9000; 
#        fastcgi_index index.php;
#        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
#        include fastcgi_params;
#    }
#}
