#!/bin/sh
set -e


if click chroot -a armhf -f ubuntu-sdk-15.04 run echo 1 ; then
    echo 'ready: click was already installed'
else
  cd /
  DEBOOTSTRAP_MIRROR=http://old-releases.ubuntu.com/ubuntu/ click chroot -a armhf -f ubuntu-sdk-15.04 create -k
  sed -i 's/overlayfs/none/' /etc/schroot/chroot.d/click-ubuntu-sdk-15.04-armhf
  sed -i 's/source-root-users=root,root/#source-root-users=root,root/'  /etc/schroot/chroot.d/click-ubuntu-sdk-15.04-armhf
  sed -i 's/source://' /usr/lib/python3/dist-packages/click_package/chroot.py
  rm /var/lib/schroot/chroots/click-ubuntu-sdk-15.04-armhf/var/lib/dpkg/statoverride
  mkdir -p /var/lib/schroot/chroots/click-ubuntu-sdk-15.04-armhf/app
  click chroot -a armhf -f ubuntu-sdk-15.04 run echo 1
  
  click chroot -a armhf -f ubuntu-sdk-15.04 install cmake libicu-dev:armhf pkg-config qtbase5-dev:armhf qtchooser qtdeclarative5-dev:armhf qtfeedback5-dev:armhf qtlocation5-dev:armhf qtmultimedia5-dev:armhf qtpim5-dev:armhf libqt5sensors5-dev:armhf qtsystems5-dev:armhf

  sed -i 's/=directory/=plain/' /etc/schroot/chroot.d/click-ubuntu-sdk-15.04-armhf 

  echo 'ready: click has been installed'
  
fi

mount --bind /app /var/lib/schroot/chroots/click-ubuntu-sdk-15.04-armhf/app

cd /app
exec "$@"
