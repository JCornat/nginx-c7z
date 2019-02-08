# nginx-c7z

## Production

### Requirements

Docker and docker-compose must be installed.

### Configuration

Docker Environment file `.env` must be present to project's root.  
Example :

```
NGINX_IMAGE=nginx:1.15.8
NGINX_CONTAINER_NAME=nginx
```

### Launch

```
docker-compose down
docker-compose build
docker-compose up -d
```

### Reference containers

Before use proxy configuration, containers you want to proxy pass must use nginx's network.  
Target `docker-compose.yml` files should end this :

```
networks:
    default:
        external:
            name: main
```

### Proxy configuration

Proxy configuration files should be located to `conf.d` folder.

#### HTTP only example 

```
server {
    listen 80;
    listen [::]:80;

    server_name sub.domaine.com; # Replace with your domain

    client_max_body_size 10M; # Set max upload size

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://container:3000; # Replace with a container name and correct port
    }
}
```

#### HTTPS example 

Add your SSL files under `ssl` folder.  
  
```
server {
    listen 80;
    listen [::]:80;

    server_name sub.domaine.com; # Replace with your domain

    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name sub.domaine.com;

    ssl on;
    ssl_certificate ssl/cert.pem;
    ssl_certificate_key ssl/key.pem;

    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;

    ssl_protocols TLSv1.2;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
    ssl_prefer_server_ciphers on;

    add_header Strict-Transport-Security max-age=15768000;

    ssl_stapling on;
    ssl_stapling_verify on;

    client_max_body_size 10M; # Set max upload size

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://container:3000; # Replace with a container name and correct port
    }
}
```
