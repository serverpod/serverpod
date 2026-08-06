# Serverpod PostgreSQL image

The official PostgreSQL image for Serverpod projects: upstream PostgreSQL with
the two extensions Serverpod supports out of the box already installed.

- **pgvector** - backs `Vector` columns.
- **PostGIS** - backs `Geography` columns.

It is published to the GitHub Container Registry as
`ghcr.io/serverpod/postgres` and is the image referenced by the
`docker-compose.yaml` of newly created Serverpod projects, so `serverpod
create` gives you a database that can run every migration Serverpod can
generate - no local image build required.

## Tags

| Tag                | Points at                                          |
| ------------------ | -------------------------------------------------- |
| `latest`           | The major version new projects are created with.   |
| `16`, `pg16`       | Latest build of the PostgreSQL 16 line.            |
| `16.<patch>`       | Latest build of that PostgreSQL patch release.     |

All tags are rolling: a rebuild picks up new PostGIS/pgvector packages under
the same tag. Pin by digest (`ghcr.io/serverpod/postgres@sha256:...`) when you
need a bit-for-bit reproducible database.

## Usage

```yaml
services:
  postgres:
    image: ghcr.io/serverpod/postgres:16
    ports:
      - '8090:5432'
    environment:
      POSTGRES_USER: postgres
      POSTGRES_DB: projectname
      POSTGRES_PASSWORD: '<password>'
```

The image is a drop-in replacement for the official `postgres` image and takes
the same environment variables and volume layout. Extensions are installed, not
enabled - Serverpod's generated migrations run `CREATE EXTENSION` for the ones
your models need.

## Publishing

`.github/workflows/publish-postgres-image.yaml` builds `linux/amd64` and
`linux/arm64`, smoke-tests that both extensions load, and pushes. It runs on any
branch push that touches this directory or the workflow itself, and on
`workflow_dispatch`. Publishing from a branch is deliberate: a compose file that
points at a tag which does not exist yet cannot pass CI, so the branch that
changes the recipe publishes it first, and the PR that consumes it is green from
its first run. `latest` is the exception and only moves from `main` or a manual
dispatch. Fork pull requests build and smoke-test without publishing.

A new tag is not pullable by anyone until the package itself is public: the
first publish creates `serverpod/postgres` as a **private** GHCR package, and it
has to be switched to public once (organization → Packages → `postgres` →
Package settings → Change visibility). Generated projects pull it anonymously.

Building it locally, e.g. to try a different base:

```bash
docker build -t serverpod-postgres docker/postgres \
  --build-arg BASE_IMAGE=pgvector/pgvector:pg16
```
