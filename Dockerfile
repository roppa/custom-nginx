FROM nginx

#clean default conf
RUN rm /etc/nginx/conf.d/default.conf

#copy default config
COPY nginx.conf /etc/nginx/
