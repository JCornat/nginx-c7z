FROM nginx:1.13.9

RUN echo Europe/Paris > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
