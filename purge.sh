#!/bin/bash

dpkg --get-selections | grep firefox

sudo apt-get purge -y firefox firefox-locale-en unity-scope-firefoxbookmarks xul-ext-ubufox \
                      libappstream3 snapd unity-webapps-common thunderbird totem rhythmbox \
                      empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese \
                      gnome-orca webbrowser-app gnome-sudoku landscape-client-ui-install onboard deja-dup

sudo apt autoremove -y
