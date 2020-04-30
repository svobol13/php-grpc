ARG PHP_VERSION=7.2.15
ARG GRPC_VERSION=1.20.0
# TODO remove dependency on grpc/php which is obsolete
FROM grpc/php AS grpc
FROM php:${PHP_VERSION}-cli-stretch AS build

# Mandatory libs to install stuff
ARG BUILD_DEPENDENCIES="${PHPIZE_DEPS} zlib1g-dev libtool git automake wget"

# Copy protoc executable
COPY --from=grpc /usr/local/bin/protoc /usr/local/bin/protoc

RUN apt-get update && apt-get -y install ${BUILD_DEPENDENCIES}
RUN pecl install grpc && docker-php-ext-enable grpc && pecl install protobuf && docker-php-ext-enable protobuf
WORKDIR /
RUN git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc
WORKDIR /grpc
RUN git submodule update --init
RUN make grpc_php_plugin

FROM php:7.2-cli-stretch
COPY --from=grpc /usr/local/bin/protoc /usr/local/bin/protoc
COPY --from=build /grpc/bins/opt/grpc_php_plugin /usr/local/bin/grpc_php_client_plugin
ENTRYPOINT [ "protoc" ]
