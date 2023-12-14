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
      xmlstarlet

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

# indexConfig/lockType is set to single in solrconfig.xml to prevent lock issues when Solr exits improperly.
# lockType cannot be set via SOLR_OPTS because an indexConfig variable is not provided in
# the ArchivesSpace release's configuration.
RUN xmlstarlet edit --inplace \
    --subnode "/config" --type elem -n indexConfig \
    --subnode "/config/indexConfig" --type elem -n lockType --value "\${solr.lock.type:single}" \
    /archivesspace/solr/solrconfig.xml

RUN cat /archivesspace/solr/solrconfig.xml

# List Archives Space Solr Conf Files
RUN ls -l /archivesspace/solr

FROM solr:8.10

ENV SOLR_JAVA_MEM="-Xms1024m -Xmx1024m"
ENV SOLR_HEAP="1024m"

COPY --from=build_release /archivesspace/solr /opt/solr/server/solr/configsets/archivesspace/conf

CMD solr-create -p 8983 -c archivesspace -d archivesspace
