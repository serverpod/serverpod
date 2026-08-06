# Serverpod PostgreSQL image

The official PostgreSQL image for Serverpod projects. Ships with the two
extensions Serverpod supports out of the box already installed.

- **pgvector** - backs `Vector` columns.
- **PostGIS** - backs `Geography` columns.

Published to the GitHub Container Registry as `ghcr.io/serverpod/postgres` and
is the image referenced by the `docker-compose.yaml` of newly created Serverpod
projects, so `serverpod create` gives you a database that can run every
migration Serverpod can generate without requiring a local image build.

## Tags

| Tag          | Points at                                                     |
| ------------ | ------------------------------------------------------------- |
| `16`, `pg16` | Latest build of the PostgreSQL 16 line (`pg16` mirrors pgvector's naming). |

Major versions only, on purpose. A project pins the major it was created
against and keeps receiving patch and extension updates within it, and nothing
published here can move it to a different major. That is why there is no
`latest` - it would silently carry a compose file nobody revisits onto the next
major - and no patch-level tags either: `16.14` reads like a pin but still
changes whenever the image is rebuilt against newer PostGIS/pgvector packages.

For a database that genuinely never moves, pin the digest:

```yaml
image: ghcr.io/serverpod/postgres@sha256:...
```

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
that the models need.

## Publishing

The `.github/workflows/publish-postgres-image.yaml` builds `linux/amd64` and
`linux/arm64`, smoke-tests that both extensions load, and pushes. It runs on
any branch push that touches the `Dockerfile` or the workflow itself - the two
things that determine the published artifact - and on `workflow_dispatch`.
Publishing from a branch is deliberate: a compose file that points at a tag
which does not exist yet cannot pass CI, so the branch that changes the recipe
publishes it first, and the PR that consumes it is green from its first run.
Fork pull requests build and smoke-test without publishing.

Generated projects pull this image anonymously, so the GHCR package has to stay
public. It is - verified by an unauthenticated pull of `:16` - but a `denied`
or 403 on pull is what a flipped visibility looks like, and it is fixed under
organization → Packages → `postgres` → Package settings → Change visibility.

Building it locally, e.g. to try a different base image:

```bash
docker build -t serverpod-postgres docker/postgres \
  --build-arg BASE_IMAGE=pgvector/pgvector:pg16
```

The `smoke.sh` script is the gate the workflow runs before it pushes, and it
takes any image reference - a local build or a published tag:

```bash
docker/postgres/smoke.sh serverpod-postgres
docker/postgres/smoke.sh ghcr.io/serverpod/postgres:16
```

It boots the image, creates both extensions and round-trips a `vector` and a
`geography` column. It publishes no ports, so it will not collide with a
database already running on 5432 or 8090.
