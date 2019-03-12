FROM arilot/docker-bitcoind


#RUN mkdir -p /bitcoin/.bitcoin/shared

#WORKDIR /bitcoin/.bitcoind/shared

RUN apt-get update

RUN apt-get install -y python3-pip

#RUN pwd
RUN ls -al /tmp

#ADD https://github.com/bitcoin/bitcoin/blob/master/share/rpcauth/rpcauth.py /tmp/

#RUN chmod 755 /tmp/rpcauth.py

COPY docker/rpcauth.py /tmp/
COPY docker/setup-rpc.sh /tmp/

RUN ls -al /tmp




#COPY docker-entrypoint.sh /usr/local/bin/
#ENTRYPOINT ["docker-entrypoint.sh"]
#
#CMD ["btc_oneshot"]


#WORKDIR /opt/
#
COPY docker/start-bitcoind.sh /usr/local/bin/

ENTRYPOINT ["./start-bitcoind.sh"]

#
#RUN chmod +x start-bitcoind.sh
#
#RUN pwd
#RUN ls -al
#
#EXPOSE 443
#ENV PATH "/opt/bitcoind/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#
#CMD ["./start-bitcoind.sh"]
