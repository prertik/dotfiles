#!/bin/bash

# Bootstrap a fresh Debian install based on my dotfiles and gems/debs lists.

set -e

ME=$1

cd /home/$ME/bin/init

# don't write atimes
chattr +A /

echo "Installing packages via apt-get and rubygems..."

apt-get install -y $(cat debs | tr '\n' ' ')

sudo -u $ME gem install --user --no-rdoc --no-ri bundler ghi bananajour cheat

cp xsession.desktop /usr/share/xsessions/xsession.desktop

# No thank you
rm -rf /home/$ME/Desktop /home/$ME/Documents /home/$ME/Music \
    /home/$ME/Pictures /home/$ME/Public \ /home/$ME/Templates \
    /home/$ME/Videos /home/$ME/Downloads

# um... dude?
update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 500
update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.9.1 500
# this causes issues on wheezy
# update-alternatives --install /usr/bin/irb irb /usr/bin/irb1.9.1 500

if [ -f /etc/mpd.conf ]; then
  sed -i "s/var\/lib\/mpd\/music/home\/$ME\/music/" /etc/mpd.conf
  sed -i "s/user\t\t\t\t\"mpd\"/user \"phil\"/" /etc/mpd.conf

  mkdir -p /var/run/mpd && chown -R $ME /var/run/mpd
  mkdir -p /var/lib/mpd && chown -R $ME /var/lib/mpd
fi

if [ ! -x /usr/bin/heroku ]; then
  wget -qO- https://toolbelt.heroku.com/install.sh | bash
fi

sudo -u $ME gconftool --load /home/$ME/.gconf.xml

echo "All done! Happy hacking."
