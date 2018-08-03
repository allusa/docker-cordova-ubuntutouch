FROM ubuntu:16.04
MAINTAINER "Aleix"

RUN apt-get update && apt-get install --no-install-recommends -y \
    	  click-dev phablet-tools debootstrap ubuntu-sdk \
	  nodejs nodejs-legacy npm \   
	  build-essential g++ \
	  sudo \
&& apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && npm install -g cordova@7.0.0

COPY ./docker-entrypoint.sh /

RUN echo "deb http://ppa.launchpad.net/ubuntu-sdk-team/ppa/ubuntu xenial main" >> /etc/apt/sources.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6C60C90EBF48F715D954A421F141B5F0C7122F9B && apt-get update && apt-get install -y ubuntu-sdk-ide \
   click gcc cmake libicu-dev pkg-config devscripts qtbase5-dev qtchooser qtdeclarative5-dev qtfeedback5-dev qtlocation5-dev qtmultimedia5-dev qtpim5-dev libqt5sensors5-dev qtsystems5-dev \
&& mkdir -p /root/.cache/click-reviewers-tools && echo '{"ubuntu-sdk-15.04": {"state": "available", "policy_vendor": "ubuntu-core", "policy_version": "16.04"}}' >> /root/.cache/click-reviewers-tools/frameworks.json \
 && ln -s /dev/shm /run/shm \
 && sed -i "s|ports.ubuntu.com/ubuntu-ports|old-releases.ubuntu.com/ubuntu|" /usr/lib/python3/dist-packages/click_package/chroot.py \
&& chmod u+x /docker-entrypoint.sh

RUN cordova create app \
    && cd app \
    && cordova platform add browser \
    && cordova platform add ubuntu

WORKDIR /app
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["cordova", "serve"]


