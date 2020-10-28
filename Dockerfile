FROM alpine:edge

# RUN stuff to build image.
RUN apk add --update 
RUN apk add nginx mrtg git
RUN git clone https://github.com/deegan/mrtg.git /mrtg
RUN mkdir /etc/periodic/5min

# COPY necessary files.
COPY crontabs /etc/crontabs/root
COPY mrtg.conf /etc/nginx/conf.d/mrtg.conf

# CMD the processes.
CMD ["php-fpm7"]
CMD ["nginx -cf /etc/nginx/nginx.conf"]
CMD ["/mrtg/scripts/wrapper.sh"]
CMD ["cp", "/mrtg/scripts/mrtg-udpate.sh" "/etc/periodic/5min"]
