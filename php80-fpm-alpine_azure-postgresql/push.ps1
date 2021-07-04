docker build -t kyamamoto0work/php80-fpm-alpine_azure-postgresql .
docker login
docker push kyamamoto0work/php80-fpm-alpine_azure-postgresql:latest
pause