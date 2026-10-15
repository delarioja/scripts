FROM joomla:latest

ENV JOOMLA_DB_HOST=mariadb \
    JOOMLA_DB_NAME=joomla \
    JOOMLA_DB_USER=joomlauser \
    JOOMLA_DB_PASSWORD=org

VOLUME /var/www/html

# docker build -t dac-joomla -f joomla.dockerfile .
# docker run --rm -d --name joomla \
#     -p 8088:80 \
#     --network joomla-network \
#     dac-joomla
