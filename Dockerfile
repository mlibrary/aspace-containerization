FROM ubuntu:22.04 as build_release

ARG ASPACE_VERSION=latest
ENV ASPACE_VERSION=$ASPACE_VERSION

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
      ca-certificates \
      git \
      wget \
      unzip

# Install Archives Space
RUN if [ "$ASPACE_VERSION" = "latest" ]; then \
        ARCHIVESSPACE_VERSION=${SOURCE_BRANCH:-`git ls-remote --tags --sort="v:refname" https://github.com/archivesspace/archivesspace.git | \
           cut -d "/" -f 3 | egrep '^v[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$' | tail -1`} ; \
    else \
        ARCHIVESSPACE_VERSION=$ASPACE_VERSION; \
    fi && \
    echo "Using version: $ARCHIVESSPACE_VERSION" && \
    wget -q https://github.com/archivesspace/archivesspace/releases/download/$ARCHIVESSPACE_VERSION/archivesspace-$ARCHIVESSPACE_VERSION.zip && \
    unzip -q /archivesspace-$ARCHIVESSPACE_VERSION.zip -d / && \
    cp /archivesspace/config/config.rb /archivesspace/config/config-$ARCHIVESSPACE_VERSION.rb

# Install Java MySQL Connector
RUN wget -q https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar && \
    cp /mysql-connector-java-8.0.30.jar /archivesspace/lib/

# Examples of how to setup themes and plugins
#echo "Setting up plugins" && \
#mkdir /archivesspace/plugins/msul-theme && \
#git clone https://gitlab.msu.edu/msu-libraries/public/archivesspace-customizations.git /archivesspace/plugins/msul-theme/  && \
#git clone https://github.com/AtlasSystems/ArchivesSpace-Aeon-Fulfillment-Plugin /archivesspace/plugins/aeon-fulfillment/ && \
#git clone https://github.com/MSU-Libraries/accession_slips.git /archivesspace/plugins/accession_slips/ && \

# Install Configuration
COPY config.rb /config.rb
RUN mv /config.rb /archivesspace/config
RUN ls -l /archivesspace/config
RUN cat /archivesspace/config/config.rb

# Install Start Up Script
COPY startup.sh /startup.sh
RUN mv /startup.sh /archivesspace && \
    chmod u+x /archivesspace/startup.sh

FROM ubuntu:20.04

ENV ARCHIVESSPACE_LOGS=/dev/null \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    TZ=UTC

COPY --from=build_release /archivesspace /archivesspace

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
      ca-certificates \
      git \
      openjdk-11-jre-headless \
      netbase \
      shared-mime-info \
      wget \
      unzip \
      tzdata \
      vim && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 archivesspace && \
    useradd -l -M -u 1000 -g archivesspace archivesspace && \
    chown -R archivesspace:archivesspace /archivesspace

USER archivesspace

EXPOSE 8080 8081 8089 8090 8092

HEALTHCHECK --interval=1m --timeout=5s --start-period=5m --retries=2 \
  CMD wget -q --spider http://localhost:8089/ || exit 1

CMD ["/archivesspace/startup.sh"]
