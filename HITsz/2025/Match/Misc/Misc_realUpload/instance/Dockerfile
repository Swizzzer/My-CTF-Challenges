FROM python:3.10-alpine

RUN adduser -D -h /home/ctf ctf
RUN pip install --no-cache-dir flask

ADD --chown=ctf:ctf src /home/ctf
COPY --chown=ctf:ctf --chmod=500 init.sh /init.sh

USER ctf
WORKDIR /home/ctf

CMD /init.sh
