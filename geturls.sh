#! /bin/sh

((wget http://download.virtualbox.org/virtualbox/ -q -O -|sed -rn '/^<A HREF="/s@^<A HREF="([0-9]+\.[0-9]+\.[0-9]+[^/]*/)".*$@http://download.virtualbox.org/virtualbox/\1@p' ) | xargs wget -q -O - )|sed -rn '/^<A HREF="VirtualBox-/s@^<A HREF="(VirtualBox-([0-9]+\.[0-9]+\.[0-9]+(_(BETA|RC)[0-9]+)?)([_-]OSE)?\.tar\.bz2)".*$@http://download.virtualbox.org/virtualbox/\2/\1@p'
