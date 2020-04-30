# php-grpc
Docker image for simple building php grpc clients. Available in dockerhub https://hub.docker.com/r/svobol13/php-grpc.

# Example
1. Go to folder with `service.proto` file
2. Create folder `php_generated` in there.
3. Execute following command:
`docker run --rm -v /$(pwd)://workdir -w //workdir svobol13/php-grpc --php_out=./php_generated --php-grpc_out=./php_generated --proto_path=./ --plugin=protoc-gen-php-grpc=//usr/local/bin/grpc_php_client_plugin service.proto`

