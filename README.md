# Docker Image for HAProxy

This repository contains Dockerfile of [HAProxy](http://www.haproxy.org/) for [Docker](https://www.docker.com/)'s automated build published to the public [Docker Hub Registry](https://hub.docker.com/).

## Base Docker Image

* [repositoryjp/centos](https://hub.docker.com/r/repositoryjp/centos/)

## HAProxy Version

* 1.6.4

## Installation

1. Install [Docker](https://www.docker.com/).

2. Download automated build from public [Docker Hub Registry](https://hub.docker.com/): `docker pull repositoryjp/haproxy`

## Usage

    docker run -i -t -d -v (the directory path for haproxy.cfg):/etc/haproxy/ repositoryjp/haproxy


*) You need to add some port options (-p) depending on your haproxy configurations.

	# Example: run haproxy container as load balancer for http and https.
	docker run -i -t -d -v /home/centos/haproxy/:/etc/haproxy/ -p 80:80 -p 443:443 repositoryjp/haproxy
	

## License

See the file [LICENSE](LICENSE).

## The Author

This Dockerfile was designed and developed by Shinya Kinoshita (From [REPOSITORY](http://www.repositories.jp)) in 2016.
