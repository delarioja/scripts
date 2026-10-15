FROM mariadb:latest

ENV MYSQL_ROOT_PASSWORD=org \
    MYSQL_DATABASE=joomla \
    MYSQL_USER=joomlauser \
    MYSQL_PASSWORD=org

VOLUME /var/lib/mysql

# docker build -t dac-mariadb -f mariadb.dockerfile .
# docker run --rm -d --name mariadb \
#     --network joomla-network \
#     dac-mariadb
