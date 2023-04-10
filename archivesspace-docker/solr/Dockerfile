FROM solr:8.10
ARG AS_VERSION

ENV SOLR_VERSION=8.10
ENV ARCHIVESSPACE_CONFIGSET_PATH=/opt/solr/server/solr/configsets/archivesspace/conf
ENV GITHUB=https://github.com/archivesspace/archivesspace

USER root

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get -y install --no-install-recommends wget

WORKDIR $ARCHIVESSPACE_CONFIGSET_PATH

RUN \
    # Determine AS Version
    if [ "x$AS_VERSION" = "x" ]; then \
        ARCHIVESSPACE_VERSION=${SOURCE_BRANCH:-`git ls-remote --tags --sort="v:refname" $GITHUB.git | \
            cut -d "/" -f 3 | egrep '^v[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$' | tail -1`} ; \
    else ARCHIVESSPACE_VERSION=$AS_VERSION ; fi && \
    echo "Using version: $ARCHIVESSPACE_VERSION" && \
    # Get the Solr configs from GitHub
    GIT=https://raw.githubusercontent.com/archivesspace/archivesspace && \
    wget -q $GIT/$ARCHIVESSPACE_VERSION/solr/schema.xml && \
    wget -q $GIT/$ARCHIVESSPACE_VERSION/solr/solrconfig.xml && \
    # These are currently empty, but still pulling them in case they ever add content to them
    wget -q $GIT/$ARCHIVESSPACE_VERSION/solr/stopwords.txt && \
    wget -q $GIT/$ARCHIVESSPACE_VERSION/solr/synonyms.txt && \
    # Change ownership of files
    chown solr:solr *

USER solr

CMD solr-create -p 8983 -c archivesspace -d archivesspace

VOLUME /opt/solr/server/solr/archivesspace/data
