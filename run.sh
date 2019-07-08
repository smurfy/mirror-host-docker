#!/bin/sh

/bin/sed -i "s|BASEURL|${BASEURL}|" /etc/Caddyfile
/bin/sed -i "s|PUBLIC_KEY|${PUBLIC_KEY}|" /root/.ssh/authorized_keys

if [ "$ENABLE_SSL" == true ]; then
    /bin/sed -i "s|EMAIL|${EMAIL}|" /etc/Caddyfile
    /bin/sed -i "s|SCHEME|https://|" /etc/Caddyfile
else
    /bin/sed -i "s|EMAIL|off|" /etc/Caddyfile
    /bin/sed -i "s|SCHEME|http://|" /etc/Caddyfile
fi

# Unlock ROOT
usermod -p '' root

# Run sshd
/usr/sbin/sshd -e -f /etc/ssh/sshd_config

# Run caddy
/bin/parent caddy --conf /etc/Caddyfile --log stdout --agree=true
