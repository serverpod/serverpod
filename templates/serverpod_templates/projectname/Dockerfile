# Build stage
FROM dart:3.8.0 AS build
WORKDIR /workspace
COPY . .

# Install dependencies and compile the server executable
RUN mkdir -p /build_workspace
RUN cp -R /workspace/projectname_server /build_workspace/projectname_server
RUN cp /workspace/pubspec.lock /build_workspace/pubspec.lock
# Create a minimal root pubspec by removing dependency_overrides and
# non-server workspace members so `dart pub get` can run without Flutter.
RUN awk ' \
  /^dependency_overrides:/ { skip=1; next } \
  skip && /^[^[:space:]]/ { skip=0 } \
  !skip && $0 !~ /projectname_client/ && $0 !~ /projectname_flutter/ { print } \
' /workspace/pubspec.yaml > /build_workspace/pubspec.yaml
RUN mkdir -p \
  /build_workspace/projectname_server/config \
  /build_workspace/projectname_server/web \
  /build_workspace/projectname_server/migrations
WORKDIR /build_workspace
RUN dart pub get
RUN dart compile exe projectname_server/bin/main.dart -o projectname_server/bin/server

# Final stage
FROM alpine:latest
WORKDIR /app

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable
COPY --from=build /build_workspace/projectname_server/bin/server server

# Copy configuration files and resources
COPY --from=build /build_workspace/projectname_server/config/ config/
COPY --from=build /build_workspace/projectname_server/web/ web/
COPY --from=build /build_workspace/projectname_server/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /build_workspace/projectname_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command
ENTRYPOINT ["sh", "-c", "exec ./server --mode=\"$runmode\" --server-id=\"$serverid\" --logging=\"$logging\" --role=\"$role\""]
