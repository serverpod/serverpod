# If you update the dart version, make sure the image is
# compatible with the busybox image.
FROM dart:3.2.5 AS build

WORKDIR /app
COPY . .

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/main

# If you update the busybox version, make sure the image is
# compatible with the dart image.
FROM busybox:1.36.1-glibc

ENV runmode=development
ENV serverid=default
ENV logging=normal
ENV role=monolith

COPY --from=build /runtime/ /
COPY --from=build /app/bin/main /app/bin/main
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/

EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

CMD app/bin/main --mode $runmode --server-id $serverid --logging $logging --role $role
