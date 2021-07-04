docker build --no-cache -t kyamamoto0work/php80-fpm-alpine_laravel-worker-postgresql .
docker login
docker push kyamamoto0work/php80-fpm-alpine_laravel-worker-postgresql:latest
pause