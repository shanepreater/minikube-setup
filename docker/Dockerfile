FROM python:3.8

ADD kubehello.tar.gz /

WORKDIR /

ENV SERVER_PORT 8080
ENV SERVER_HOST 0.0.0.0

RUN cd kubehello-1.0.0 \
 && python setup.py install

USER nobody

ENTRYPOINT start-server