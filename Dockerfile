FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y build-essential curl

RUN curl -o dante.tar.gz -L http://www.inet.no/dante/files/dante-1.4.3.tar.gz && \
    tar -zxf dante.tar.gz && \
    rm dante.tar.gz

WORKDIR /dante-1.4.3

RUN ./configure && make && make install

WORKDIR /

RUN apt-get remove -y build-essential curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /dante-1.4.3

COPY ./data/sockd.conf /etc/sockd.conf

COPY ./data/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1080

# CMD ["sockd", "-f", "/etc/sockd.conf"]
ENTRYPOINT ["/entrypoint.sh"]