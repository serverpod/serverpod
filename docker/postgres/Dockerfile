# Serverpod's official PostgreSQL image: upstream PostgreSQL with both
# extensions Serverpod supports out of the box preinstalled - pgvector (vector
# columns) and PostGIS (geography columns).
#
# Published to ghcr.io/serverpod/postgres by
# .github/workflows/publish-postgres-image.yaml and used by the docker-compose
# file of newly created Serverpod projects. The base is pgvector's image, which
# is the official postgres image plus pgvector, so only PostGIS is added here.
ARG BASE_IMAGE=pgvector/pgvector:pg16
FROM ${BASE_IMAGE}

# PG_MAJOR is set by the official postgres base image; deriving the PostGIS
# package name from it keeps this recipe valid for any base tag, and the
# guard turns an unexpected base into a build failure rather than an image
# silently missing PostGIS. Passing a new PACKAGE_REFRESH re-resolves the
# packages instead of reusing an apt layer cached before an upstream update;
# the publishing workflow varies it when a publish is requested by hand.
ARG PACKAGE_REFRESH=local
RUN set -eux; \
    echo "Package refresh: $PACKAGE_REFRESH"; \
    : "${PG_MAJOR:?not set by the base image - is this an official postgres derivative?}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends "postgresql-$PG_MAJOR-postgis-3"; \
    rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.title="Serverpod PostgreSQL" \
      org.opencontainers.image.description="PostgreSQL with pgvector and PostGIS, the database image used by Serverpod projects." \
      org.opencontainers.image.source="https://github.com/serverpod/serverpod"
