FROM arilot/docker-bitcoind

COPY docker/start-bitcoind.sh .

RUN chmod +x start-bitcoind.sh

CMD ["./start-bitcoind.sh"]
