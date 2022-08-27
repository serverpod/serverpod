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
docker-compose exec -u postgres postgres psql -f /generated/tables-serverprod.pgsql
echo Stopping docker
docker-compose stop
pause
exit /b