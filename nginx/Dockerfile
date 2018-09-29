ARG NGINX_VERSION=latest
FROM nginx:${NGINX_VERSION}

# Install updates and any additional packages
RUN apt-get update -y && \
    apt-get install openssl -y && \
    apt-get install procps -y

# Create a self signed cert
ARG PROJECT_NAME=project_name
RUN openssl req -new -nodes -x509 -subj "/C=US/ST=Virginia/L=Richmond/O=DevOrg/CN=Local Dev" \
    -days 3650 -keyout /etc/ssl/certs/${PROJECT_NAME}.key -out /etc/ssl/certs/${PROJECT_NAME}.crt -extensions v3_ca

COPY conf/nginx.conf /etc/nginx/

COPY conf/project.conf /etc/nginx/conf.d/

RUN sed -i 's/PROJECT_NAME/'"${PROJECT_NAME}"'/g' /etc/nginx/conf.d/project.conf

ARG VIRTUAL_HOST=local.dev
RUN sed -i 's/VIRTUAL_HOST/'"${VIRTUAL_HOST}"'/g' /etc/nginx/conf.d/project.conf

RUN rm /etc/nginx/conf.d/default.conf

RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx

RUN chown nginx:nginx /etc/ssl/certs/${PROJECT_NAME}.key && \
    chown nginx:nginx /etc/ssl/certs/${PROJECT_NAME}.crt

USER nginx