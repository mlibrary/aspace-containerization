FROM nginx:1.13

COPY archivesspace.conf /etc/nginx/conf.d/default.conf
RUN rm /var/log/nginx/*

EXPOSE 80
EXPOSE 443
