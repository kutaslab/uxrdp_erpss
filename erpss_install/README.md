# Install ERPSS executables and source on Ubuntu 20.04

Installation
------------

See the ../Dockerfile, installation on pre-configured 64-bit linux metal boxes is the same.

For testing in the docker image, the Dockerfile also adds the sudo user `lab` and pre-installs miniconda: https://docs.conda.io/en/latest/miniconda.html


Notes
-----

* The 32-bit ERPSS binaries need the libc6 i386 libraries and the X11 graphics needs libX11.so.6.

* The erp.tar directory tree must live exactly in /usr/local/erp/* because of ancient hardcoded path spaghetti.

* The PATH to the executables for login shells is added for all users by updating /etc/profile.d/custom.sh


Files
------

* The erp.tgz tarball is a snapshot of ERPSS in Slackware 11
  /usr/local/erp/* as Paul Krewski left it circa 2017.  The files in
  this tree are also available on UCSD kutaslab linux
  /mklab/home/backups/erp/*

* update_custom.sh creates or extends /etc/profile.d/custom.sh for
  PATH to to ERPSS executables.

* The tests directory contains non-human subjects test data files and the
  run_tests.sh bash script to smoke test the installation.

