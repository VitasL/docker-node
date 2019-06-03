# docker-nodejs

Node.js is a JavaScript-based platform for server-side and networking applications.

## Description

This image is based on the popular Alpine Linux project, available in the alpine official image. Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

Currently, the node version is `v8.9.4` for the default tag `latest`. And I have replaced `npm v5.6.0` with `yarn v1.3.2`.

## Build

You can pull the image from `hub.docker.com`.

```sh
$ docker pull bingozb/nodejs
```

Or, you can build with source repository by yourself. It will take a lot of time.

```sh
$ git clone https://github.com/bingozb/docker-nodejs.git
$ cd docker-nodejs
$ docker build -t bingozb/nodejs .
```

## Usage

As we know, the node.js project usually deploy with thus steps.

```sh
$ yarn install
$ yarn run build
$ yarn start
```

I recommend separating build and deployment. It is recommended to use two hosts, one for build and one for deployment.

| Host | Job | Command |
| --- | --- | --- |
| Host A | build | yarn install && yarn run build |
| Host B | deploy | yarn start |

### Host A

First, put your node.js project in your host machine via `git` or `scp` and so on, and run the container with the command `install` and `run build`.

```sh
$ sudo docker run --rm -v /path/to/yourproject:/app bingozb/nodejs install
$ sudo docker run --rm -v /path/to/yourproject:/app bingozb/nodejs run build
```

Once the execution is complete, you will find a new folder `node_modules` and a new file `yarn.lock` in your project.

Then, copy all of your project to Host B. You can do some compression to make the file transfer faster.

e.g.:

```sh
$ cd /path/to/yourproject
$ touch app.tar.gz && tar --exclude=app.tar.gz -zcf app.tar.gz .
$ scp app.tar.gz user@HostB:/path/to/yourproject
```

### Host B

Decompress first, if necessary.

```sh
$ tar -xzf /path/to/yourproject/app.tar.gz -C /path/to/yourproject/ 
$ rm -f /path/to/yourproject/app.tar.gz
```

Then run a container:

```sh
$ sudo docker run --restart always -d --name yourapp \
-p 3000:3000 \
-v /path/to/yourproject:/app \
bingozb/nodejs
```

After that, you can access your project with Host B and 3000 port.

### One Host

If you think it's not necessary to use two hosts, you can certainly do it on the same host.

```sh
$ sudo docker run --rm -v /path/to/yourproject:/app bingozb/nodejs install
$ sudo docker run --rm -v /path/to/yourproject:/app bingozb/nodejs run build
$ sudo docker run --restart always -d --name yourapp -p 3000:3000 -v /path/to/yourproject:/app bingozb/nodejs
```

**Why do we need to separate build and deployment?**

It depends on the actual situation. As for me, there is dozens of projects in my machine. If do the build at the same time, it could lead to a shortage of resources. Therefore, we have two hosts, one for build and one for deployment. And the host which for build was using the `jenkins` service to do the building job.

