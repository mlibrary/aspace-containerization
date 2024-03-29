FROM ubuntu:22.04 as build_release

ARG ASPACE_VERSION=latest
ENV ASPACE_VERSION=$ASPACE_VERSION

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
      ca-certificates \
      git \
      wget \
      unzip \
      default-jdk \
      xmlstarlet && \
    rm -rf /var/lib/apt/lists/*

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
    mv /archivesspace/config/config.rb /archivesspace/config/config-$ARCHIVESSPACE_VERSION.rb

# indexConfig/lockType is set to single in solrconfig.xml to prevent issues that occur with
# file-based locks when Solr exits improperly.
# lockType cannot be set via SOLR_OPTS because an indexConfig variable is not provided in
# the ArchivesSpace release's configuration.
# This change also needs to be made in the app image because the application compares
# the checksums of its and Solr's configuration files.
RUN xmlstarlet edit --inplace \
    --subnode "/config" --type elem -n indexConfig \
    --subnode "/config/indexConfig" --type elem -n lockType --value "\${solr.lock.type:single}" \
    /archivesspace/solr/solrconfig.xml

# Install Java MySQL Connector
RUN wget -q https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar && \
    cp /mysql-connector-java-8.0.30.jar /archivesspace/lib/

# Monkey Patch 088_rights_management.rb in archivesspace/lib/common.jar at /common/db/migrations
COPY 088_rights_management.rb /db/migrations/088_rights_management.rb
RUN jar --verbose --update --file=/archivesspace/lib/common.jar /db/migrations/088_rights_management.rb

FROM ubuntu:22.04

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
      gettext-base \
      vim && \
    rm -rf /var/lib/apt/lists/*

# Install Auth Plugin
RUN cd /archivesspace/plugins && \
    git clone --depth 1 --branch oidc https://github.com/mlibrary/aspace-oauth.git

RUN cd /archivesspace && \
    ./scripts/initialize-plugin.sh aspace-oauth

# Install AppConfig file
COPY config.rb /archivesspace/config/config.rb

# Install Start Up Script
COPY startup.sh /archivesspace/startup.sh
RUN chmod u+x /archivesspace/startup.sh

# Support arbitrary user ids - https://docs.openshift.com/container-platform/4.13/openshift_images/create-images.html#use-uid_create-images
RUN chgrp -R 0 /archivesspace/ && chmod -R g=u /archivesspace/

HEALTHCHECK --interval=1m --timeout=5s --start-period=5m --retries=2 \
  CMD wget -q --spider http://localhost:8089/ || exit 1

CMD ["/archivesspace/startup.sh"]
