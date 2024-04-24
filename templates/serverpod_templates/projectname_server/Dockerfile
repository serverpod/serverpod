FROM dart:3.3.0 AS build

WORKDIR /app
COPY . .

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

FROM alpine:latest

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server server
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/
COPY --from=build /app/migrations/ migrations/

EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

ENTRYPOINT ["/app/bin/main"]
CMD ["--mode", "production", "--server-id", "default", "--logging", "normal", "--role", "monolith"]
