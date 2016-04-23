### Lychee

This is a docker container that only contains an install of lychee with php fpm. It is designed to be used with a separate mysql container that handles the database and nginx container that handles the serving of static content and proxying the php requests to php fpm.

### Usage
To run it:

    $ docker run -d --name "lychee" \
        --expose 9000 \
        -v /path/to/uploads:/uploads \
        -v /path/to/data:/data \
        mrskensington/lychee

For nginx you will need to run your nginx docker container with...

    --volumes-from lychee

and your nginx configuration should look something like...

    upstream lychee.upstream {
        server <lychee-docker-ip>:9000;
    }

    server {
        listen 80 ;

        index index.php index.html;
        root /code/lychee;
        error_log  /var/log/nginx/lychee_error.log;
        access_log /var/log/nginx/lychee_access.log;

        client_max_body_size 0; #max size disabled
        client_header_timeout 30m;
        client_body_timeout 30m;

        location ~ \.php$ {
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass lychee.upstream;
            fastcgi_send_timeout 30m;
            fastcgi_read_timeout 30m;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $fastcgi_path_info;
        }
    }
