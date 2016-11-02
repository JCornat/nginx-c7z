FROM nginx

RUN echo Europe/Paris > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
