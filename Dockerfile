FROM ubuntu:16.04

RUN apt-get update \
    && apt-get -qq --no-install-recommends install \
        libcurl3 curl wget\
    && rm -r /var/lib/apt/lists/*

#RUN set -x \
#    && buildDeps=' \
#        automake \
#        ca-certificates \
#        gcc \
#        libc6-dev \
#        libcurl4-openssl-dev \
#        make \
#    ' \
#    && apt-get -qq update \
#    && apt-get -qq --no-install-recommends install $buildDeps \
#    && rm -rf /var/lib/apt/lists/* \
#    && mkdir -p /usr/local/src/wolf9466-cpuminer-multi \
#    && cd /usr/local/src/wolf9466-cpuminer-multi \
#    && curl -sL https://github.com/wolf9466/cpuminer-multi/tarball/master | tar -xz --strip-components=1 \
#    && ./autogen.sh \
##    && CFLAGS="-march=native" ./configure \
#    && CFLAGS="-O3 -march=native" ./configure --disable-aes-ni \
#    && make -j"$(nproc)" \
#    && make install \
#    && cd .. \
#    && rm -r wolf9466-cpuminer-multi \
#    && apt-get -qq --auto-remove purge $buildDeps
#
RUN set -x \
&& cd /opt \
&& wget http://10.55.102.5/pooler-cpuminer-2.5.0-linux-x86_64.tar.gz \
&& tar zxf pooler-cpuminer-2.5.0-linux-x86_64.tar.gz
COPY multipool.sh /usr/local/bin/multipool.sh
RUN chmod +x /usr/local/bin/multipool.sh
ENTRYPOINT ["multipool.sh"]
CMD ["-p","stratum+tcp://us-east.multipool.us:7777","-u","multipimpin.worker"]
