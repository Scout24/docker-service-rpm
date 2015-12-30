# docker-service-rpm

[Docker](https://docker.io) provides a convenient way to package entire applications into runnable containers. OTOH in the data center we use RPM packages to deliver software and configuration to our servers.

This wrapper build a bridge between Docker appliances and Linux services by packaging a Docker image as a Linux service into an RPM package.

The resulting Linux service can be simply used like any other Linux service, for example start the service with `service schlomo start`.

## Installation

Simply clone this git repo.

## Building the example appliances

For demonstration purposes this repo includes an example app `schlomo` (nginx with a custom HTML page). To build the RPM with the example app simply run

```
make example
```

to build an RPM package. To test install the RPM package on a system with docker-engine already installed. Then start the service with

```
service schlomo start
```

and validate the running service with

```
curl http://localhost
```

After a reboot the schlomo service should come up again.

## Building for your own Docker image

To build an RPM from your own Docker image or an appliance you find on DockerHub simply run `make` with a few parameters like this

```
make rpm IMAGE=nginx:latest NAME=nginx VERSION=74 RELEASE=4.110 REQUIRES=is24-docker RUNARGS="-p 80:80 --env-file=/etc/nginx-environment"
```

The `IMAGE` and `RUNARGS` variables define the Docker image to take and additional arguments to `docker run`. Use this to pass in environment variables, set Docker volumes etc.

The `NAME`, `VERSION`, `RELEASE` variables define the name, version and release of the RPM.

The `REQUIRES` variable defines the RPM requires of the RPM, for example at ImmobilienScout24 we ship Docker in the `is24-docker` RPM. You can also add here another RPM that will provide required components for the service, e.g. a Docker data container or configuration files.
