FROM alpine:latest

ENV NGINX_VERSION nginx-1.15.9
ENV FFMPEG_ARCH amd64

RUN apk --update add openssl-dev pcre-dev zlib-dev wget unzip build-base && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
	wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-${FFMPEG_ARCH}-static.tar.xz && \
    wget http://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
RUN	cd /tmp/src && \
	tar -xvf ffmpeg-release-${FFMPEG_ARCH}-static.tar.xz && \
	rm ffmpeg-release-${FFMPEG_ARCH}-static.tar.xz && \
	mv ffmpeg*/ff* /usr/bin && \
    unzip master.zip && \
    tar -zxvf ${NGINX_VERSION}.tar.gz && \
    cd /tmp/src/${NGINX_VERSION} && \
    ./configure \
		--with-threads \
		--with-poll_module \
		--with-pcre-jit \
		--with-http_v2_module \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --prefix=/etc/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/local/sbin/nginx \
        --add-module=../nginx-rtmp-module-master \
        --with-cc-opt="-Wno-error" \
        --build=PauneyTV && \
    make && \
    make install && \
    apk del build-base wget unzip && \
    rm -rf /tmp/src && \
	rm -rf /var/cache/apk/*
RUN mkdir -p /data/hls/{source,small,medium} /data/vod

VOLUME ["/var/log/nginx", "/data/vod"]

WORKDIR /etc/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY www /srv/www

CMD ["nginx", "-g", "daemon off;"]
