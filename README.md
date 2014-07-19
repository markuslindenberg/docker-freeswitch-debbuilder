# What is it?

This is a *Dockerfile* and shell script to create a Docker image that will, when run, build Debian packages of the current FreeSWITCH `master` branch. 

# Usage

```
git clone https://github.com/markuslindenberg/docker-freeswitch-debbuilder.git
cd docker-freeswitch-debbuilder
docker build -t fsbuild .
docker run fsbuild
``` 

# How to build repeatedly

You can restart a used container anytime. The container will pull the git repo and do a full build **only when new commits were pulled**. 

```
docker start -a CONTAINER
```

# How does it work?

I didn't use pbuilder. Instead, a shell script will run the few steps necessary:

* `git pull`
* Bootstrap FreeSWITCH
* Use `git-buildpackage` to create a source package
* Place package into a repository
* Install dependencies using `apt-get build-dep`
* Build packages using `apt-get source --build`
* Create repository tree using `aptly`

# What's missing but easily doable

* Signing
* Building other branches
* Building for other debian releases
