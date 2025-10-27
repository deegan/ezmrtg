FROM alpine:edge

# RUN stuff to build image.
RUN apk add --update 
RUN apk add bash nginx mrtg git php-fpm
RUN git clone https://github.com/deegan/ezmrtg.git /mrtg
RUN mkdir /etc/periodic/1min
RUN mkdir /mrtg/cfg/
RUN cp /mrtg/scripts/update-mrtg.sh /etc/periodic/1min 

# COPY necessary files.
COPY crontabs /etc/crontabs/root
COPY mrtg.conf /etc/nginx/conf.d/default.conf

# RUN the processes.
WORKDIR /mrtg/scripts
CMD /usr/sbin/php-fpm7 && /usr/sbin/nginx -c /etc/nginx/nginx.conf && /usr/sbin/crond && /mrtg/scripts/wrapper.sh && tail -f /var/log/nginx/mrtg.access.log && wait
