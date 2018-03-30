FROM nginx:1.13.10

RUN echo Europe/Paris > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
