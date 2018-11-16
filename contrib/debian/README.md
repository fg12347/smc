
Debian
====================
This directory contains files used to package smcd/smc-qt
for Debian-based Linux systems. If you compile smcd/smc-qt yourself, there are some useful files here.

## smc: URI support ##


smc-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install smc-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your smc-qt binary to `/usr/bin`
and the `../../share/pixmaps/smc128.png` to `/usr/share/pixmaps`

smc-qt.protocol (KDE)

