FROM openjdk:${openjdk.version}-sid

USER root
RUN apt-get update
RUN apt-get install bash -y

ENV DOCKERIZE_VERSION v0.6.0
RUN wget --quiet https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir -p /opt
WORKDIR /opt

RUN useradd -r -m tomee
RUN chown tomee:tomee -R /opt

USER tomee

COPY --chown=tomee:tomee mp.tar.gz .
RUN tar xzf mp.tar.gz && rm mp.tar.gz
RUN mv apache-* tomee
RUN rm -Rf /opt/tomee/webapps/*
WORKDIR /opt/tomee/conf/
COPY --chown=tomee:tomee logging.properties .

ENV JPDA_ADDRESS=8000
ENV JPDA_TRANSPORT=dt_socket
ENV JPDA_SUSPEND=n

EXPOSE 8080 8000

WORKDIR /opt/tomee/

COPY --chown=tomee:tomee start.sh .
RUN chmod u+x start.sh

ENTRYPOINT ["/opt/tomee/start.sh"]
CMD ["run"]