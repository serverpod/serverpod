@echo off

@REM Start docker
echo Starting docker
docker-compose up --build --detach

:LOOP
netstat -o -n -a | >nul findstr "8090" && (
    echo Waiting for Postgres...
    sleep 2
    goto :PORT_FOUND
)
echo Waiting for Postgres...
goto :LOOP

:PORT_FOUND
echo Postgres is ready
cat .\generated\tables-serverpod.pgsql | docker-compose run -T postgres env PGPASSWORD="DB_PASSWORD" psql -h postgres -U postgres -d projectname
echo Stopping docker
docker-compose stop
pause
exit /b