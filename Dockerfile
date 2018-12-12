FROM perl:latest
COPY spammer.pl /opt/
ENTRYPOINT perl /opt/spammer.pl

