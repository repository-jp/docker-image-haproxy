FROM repositoryjp/centos
MAINTAINER Shinya Kinoshita <skinoshita@repositories.jp>

LABEL name="HAProxy Image" \
      description="The Image For Creating L7 Load Balancer Container." \
      distribution="centos" \
      centos-version="6.6" \
      haproxy-version="1.6.4" \
      vendor="REPOSITORY <http://www.repositories.jp>" \
      license="MIT"

USER root
WORKDIR /usr/local/src

# Add group of haproxy.
RUN groupadd haproxy

# Add user of haproxy.
RUN useradd -g haproxy -s /sbin/nologin -M haproxy

# Download compressed file of haproxy 1.6.4.
RUN wget http://www.haproxy.org/download/1.6/src/haproxy-1.6.4.tar.gz

# Uncompress file of haproxy-1.6.4.tar.gz.
RUN tar xvzf haproxy-1.6.4.tar.gz

WORKDIR /usr/local/src/haproxy-1.6.4

# Make and make install.
RUN make TARGET=linux26 ARCH=x86_64 && make install

# Make symbolic link of haproxy.
RUN ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy

# Copy init.d script of haproxy and grant permission of execution for its script.
RUN cp -p examples/haproxy.init /etc/init.d/haproxy && chmod +x /etc/init.d/haproxy

# Register init.d script of haproxy.
RUN chkconfig --add haproxy && chkconfig haproxy on

# Copy configuration file of haproxy.
COPY etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg

# Remove folder of haproxy-1.6.4.
WORKDIR /usr/local/src
RUN rm -rf /usr/local/src/haproxy-1.6.4

# Configure rsyslog.
RUN sed -ri 's/^#$ModLoad imudp/$ModLoad imudp/' /etc/rsyslog.conf && \
    sed -ri 's/^#$UDPServerRun 514/$UDPServerRun 514/' /etc/rsyslog.conf

# Configure haproxy log.
RUN mkdir -p /var/log/haproxy
COPY etc/rsyslog.d/haproxy.conf /etc/rsyslog.d/haproxy.conf

# Configure container
USER root
WORKDIR /root

VOLUME ["/etc/haproxy/"]

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/etc/init.d/rsyslog start && /etc/init.d/haproxy start && /bin/bash"]
