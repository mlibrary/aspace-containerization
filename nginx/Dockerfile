FROM nginx:1.13
ARG ASPACE_VERSION=latest

RUN \
    # Determine Archives Space Version
    if [ "$ASPACE_VERSION" = "latest" ]; then \
        ARCHIVESSPACE_VERSION=${SOURCE_BRANCH:-`git ls-remote --tags --sort="v:refname" $GITHUB.git | \
            cut -d "/" -f 3 | egrep '^v[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$' | tail -1`} ; \
    else ARCHIVESSPACE_VERSION=$ASPACE_VERSION ; fi && \
    echo "Using version: $ARCHIVESSPACE_VERSION"

COPY archivesspace.conf /etc/nginx/conf.d/default.conf
RUN rm /var/log/nginx/*

EXPOSE 80
EXPOSE 443
