FROM ubuntu:24.04 AS build_release

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
    unzip -q /archivesspace-$ARCHIVESSPACE_VERSION.zip -d /

# List Archives Space Solr Conf Files
RUN ls -l /archivesspace/solr

FROM solr:9.4

ENV SOLR_JAVA_MEM="-Xms2048m -Xmx2048m"
ENV SOLR_HEAP="2048m"
ENV SOLR_MODULES=analysis-extras
ENV SOLR_OPTS="$SOLR_OPTS -Dsolr.lock.type=single"

COPY --from=build_release /archivesspace/solr /opt/solr/server/solr/configsets/archivesspace/conf

CMD solr-create -p 8983 -c archivesspace -d archivesspace
