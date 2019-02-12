FROM arilot/docker-bitcoind

WORKDIR /opt/

COPY docker/start-bitcoind.sh .

RUN chmod +x start-bitcoind.sh

RUN pwd
RUN ls -al

CMD ["./start-bitcoind.sh"]
