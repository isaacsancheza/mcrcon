FROM debian:trixie as builder

# install build tools
RUN apt-get update  \
    && export DEBIAN_FRONTEND=noninteractive \
    #
    # update certificates
    && apt-get install -y --reinstall ca-certificates \
    # 
    # install packaged
    && apt-get install -y --no-install-recommends git build-essential \
    #
    # clean-up/
    && apt-get autoremove -y  \
    && apt-get clean -y  \
    && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# install mcrcon
# https://github.com/Tiiffi/mcrcon
RUN git clone https://github.com/Tiiffi/mcrcon /tmp/mcrcon \
    && cd /tmp/mcrcon \
    && make \
    && make install


FROM debian:trixie

COPY --from=builder /usr/local/bin/mcrcon /usr/local/bin/mcrcon

ENTRYPOINT ["/usr/local/bin/mcrcon"]

