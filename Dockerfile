FROM python:3.9-alpine
LABEL description="Application for deploying and running Scrapy spiders."

ENV PYTHONUNBUFFERED 1

RUN set -ex && apk --no-cache --virtual .build-deps add build-base g++ bash curl gcc libgcc tzdata psutils supervisor linux-headers openssl-dev postgresql-dev libffi-dev libxml2-dev libxslt-dev

RUN ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
RUN echo "America/New_York" > /etc/timezone

RUN pip install -U pip
COPY ./requirements.txt /
RUN pip install -r requirements.txt

RUN mkdir /etc/scrapyd
RUN mkdir -p /scrapyd/logs
COPY scrapyd.conf /etc/scrapyd/
COPY supervisord.conf /etc/

VOLUME /scrapyd
EXPOSE 6800

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
