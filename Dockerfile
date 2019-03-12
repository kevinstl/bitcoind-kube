FROM arilot/docker-bitcoind


#RUN mkdir -p /bitcoin/.bitcoin/shared

#WORKDIR /bitcoin/.bitcoind/shared

RUN apt-get update

RUN apt-get install -y wget python

#RUN pwd
RUN ls -al /tmp

ADD https://github.com/bitcoin/bitcoin/blob/master/share/rpcauth/rpcauth.py /tmp/

RUN chmod 755 /tmp/rpcauth.py

#COPY docker/rpcauth.py /bitcoin/.bitcoin/shared/

RUN ls -al /tmp





#WORKDIR /opt/
#
#COPY docker/start-bitcoind.sh .
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
