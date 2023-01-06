ARG mode=development

FROM dart:stable
ARG mode
RUN echo "Building Image in ${mode} mode"

WORKDIR /app
COPY . .

RUN  dart pub get
RUN dart compile exe bin/main.dart

FROM alpine:3.4

COPY --from=0 /runtime/ /
COPY --from=0 /app/bin/main.exe /app/bin/
COPY --from=0 /app/config/ config/
COPY --from=0 /app/generated/ generated/
COPY --from=0 /app/web/ web/

ARG mode
ENV runmode=$mode

EXPOSE 8080
EXPOSE 8081
EXPOSE 8082 

CMD app/bin/main.exe --mode ${runmode}