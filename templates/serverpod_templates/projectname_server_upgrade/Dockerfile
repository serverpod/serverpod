FROM dart:3.2.5 AS build

WORKDIR /app
COPY . .

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

FROM scratch

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server server
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/


EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# The default flags used when starting the server, can be manually overridden by passing flags to the docker run command
ENTRYPOINT ["./server", "--mode=production", "--server-id=default", "--logging=normal", "--role=monolith"]
