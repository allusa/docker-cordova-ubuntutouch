========================
Cordova build for Ubuntu
========================

:github: https://github.com/allusa/docker-cordova-ubuntutouch
:dockerhub: https://hub.docker.com/r/timbaler/cordova-ubuntutouch
	    
Docker image ready for executing `cordova build ubuntu` resulting in:

* Ubuntu Touch 15.04 armhf click package
* Ubuntu Desktop 16.04 deb package

See cordova docs at https://cordova.apache.org/docs/en/7.x/guide/platforms/ubuntu/index.html


Docker image ready for executing `cordova build android` resulting in:

* Android apk package using only Android SDK and development tools already available into Debian

Currently there is only the target platform of API Level 23 packaged, so only apps targeted at android-23 can be built with only Debian packages. Only Build-Tools 24.0.0 is available, so in order to use the SDK, build scripts need to be modified [https://wiki.debian.org/AndroidTools]


See cordova docs at https://cordova.apache.org/docs/en/latest/guide/platforms/android/index.html



Docker images
=============

* timbaler/cordova-ubuntutouch:15:04
* timbaler/cordova-ubuntutouch:android23

  
  
Run
===

In order to build for ubuntu, use the docker image.

* `docker run --privileged --name cordova-ubuntutouch --rm -it timbaler/cordova-ubuntutouch:15:04 bash`

You will find a default cordova app inside `/app` which you can build for ubuntu touch or desktop (see below sections), e.g:

* `cordova build ubuntu --device`
 

 

Volumes
-------

You can mount your local cordova application as a volume on /app.

Locally, you have your cordova application, e.g.:

* `cordova create newapp; cd newapp; cordova platform add browser`

For the first time you need add the ubuntu platform (`cordova platform add ubuntu`):  
  
* `docker run --privileged --name cordova-ubuntutouch --rm -it -v ./YOUR/LOCAL/NEWAPP:/app timbaler/cordova-ubuntutouch:15:04 cordova platform add ubuntu`

  
Then you can build for ubuntu touch or desktop (see below sections), e.g:

* `docker run --privileged --name cordova-ubuntutouch --rm -it -v ./YOUR/LOCAL/NEWAPP:/app timbaler/cordova-ubuntutouch:15:04 cordova build ubuntu --device`


docker-compose
--------------

You can also put all in a Docker Compose file::
  
 version: '2'

 services:

   ubuntutouch:
     image: timbaler/cordova-ubuntutouch:15.04
     cap_add:
       - SYS_ADMIN
     security_opt:
       - apparmor:unconfined
     privileged: true
     volumes:
       - ./YOUR/LOCAL/NEWAPP:/app

First time:
       
* `docker-compose -f docker-compose.yml run ubuntutouch cordova platform add ubuntu`

Builds, e.g. for ubuntu touch:
  
* `docker-compose -f docker-compose.yml run ubuntutouch cordova build ubuntu --device`


Build for ubuntu touch
======================

**Ubuntu touch 15.04 armhf**


* `cordova build ubuntu --device`

  
Answer yes if you see the following error, it is probably already installed::

 Error: missing dependency inside armhf chroot
 run:
 sudo click chroot -a armhf -f ubuntu-sdk-15.04 install cmake libicu-dev:armhf pkg-config qtbase5-dev:armhf qtchooser qtdeclarative5-dev:armhf qtfeedback5-dev:armhf qtlocation5-dev:armhf qtmultimedia5-dev:armhf qtpim5-dev:armhf libqt5sensors5-dev:armhf qtsystems5-dev:armhf 
 Do you want install it now? (Yn)> 


Then you may found your package at::

 /app/platforms/ubuntu/ubuntu-sdk-15.04/armhf/prefix/<yourpackage>_armhf.click



Install on ubuntu touch
-----------------------

You can install locally on your ubuntu device:

* `pkcon install-local --allow-untrusted <yourpackage.click>`


Or you can submit to the Ubuntu Touch Apps OpenStore https://open-store.io/.




Build for ubuntu desktop
========================

**Ubuntu desktop 16.04**


* `cordova build ubuntu`
  
* `cd /app/platforms/ubuntu/native/<yourpackage>`
* `debuild -i -us -uc -b`

Then you may found your package at::

 /app/platforms/ubuntu/native/<yourpackage>_amd64.deb


Build for android
=================

**Android API Level 23**


For the first time you need add the android platform (`cordova platform add android@5.0.0`):  
  
* `docker run --name android --rm -it -v ./YOUR/LOCAL/NEWAPP:/app timbaler/cordova-ubuntutouch:android23 cordova platform add android@5.0.0`

  
Then you can build for android:

* `docker run --name android --rm -it -v ./YOUR/LOCAL/NEWAPP:/app timbaler/cordova-ubuntutouch:android23 cordova build android`


Then you may found your package at::

 /app/platforms/android/build/outputs/apk/<yourpackage>.apk


docker-compose
--------------

You can also put all in a Docker Compose file::
  
 version: '2'

 services:

   android:
     image: timbaler/cordova-ubuntutouch:android23
     volumes:
       - ./YOUR/LOCAL/NEWAPP:/app

First time:
       
* `docker-compose -f docker-compose.yml run android cordova platform add android@5.0.0`

Builds:
  
* `docker-compose -f docker-compose.yml run android cordova build android`



 

Build docker image
==================

If you want to build yourself this docker image, `docker-compose.yaml`::

 version: '2'

 services:

  ubuntutouch-build:
     build:
       context: ubuntu
     cap_add:
       - SYS_ADMIN
     security_opt:
       - apparmor:unconfined
     privileged: true

  android-build:
     build: android23


Android build:
     
* `docker-compose -f docker-compose.yaml build android-build`

Ubuntu Touch build. When running for the first time, it will build,
run and complete the Ubuntu Touch chroot installation:
    
* `docker-compose -f docker-compose.yaml up ubuntutouch-build`

Then you may create the image from the container’s changes:
  
* `docker commit ubuntutouch-build_1  cordova-ubuntutouch:15.04`
