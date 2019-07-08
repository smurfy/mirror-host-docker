FROM abiosoft/caddy:1.0.1-no-stats AS base

FROM panubo/sshd

RUN apk add --no-cache ca-certificates

EXPOSE 80 443 22

VOLUME /root/.caddy /srv
WORKDIR /srv

COPY --from=base /usr/bin/caddy /usr/bin/caddy
COPY --from=base /bin/parent /bin/parent
COPY Caddyfile /etc/Caddyfile
COPY rsyncd.conf /root/rsyncd.conf
COPY authorized_keys /root/.ssh/authorized_keys
COPY sshd_config /etc/ssh/sshd_config

ENV BASEURL=127.0.0.1 \
    EMAIL=off \
    ENABLE_SSL=false \
    PUBLIC_KEY=MISSING

ADD ./run.sh /run.sh
RUN chmod 755 /run.sh

CMD ["/run.sh"]
