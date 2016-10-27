FROM nginx

#clean default conf
RUN rm /etc/nginx/conf.d/default.conf

RUN mkdir /etc/nginx/sites
RUN mkdir /etc/nginx/html
RUN mkdir /etc/nginx/includes

#copy default config
COPY nginx.conf /etc/nginx/
