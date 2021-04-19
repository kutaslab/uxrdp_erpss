Installing precompiled ERPSS 32-bit binaries and source on Ubuntu 20.04


Installation
------------

The installation lives in this Ubuntu 20.04 docker image prepared with xrdp by Daniel Guerrera.
The ERPSS installation and addition of one user is painted on the end of the setup and fully automated.

* The 32-bit ERPSS binaries need the libc6 i386 libraries, additionally graphics needs libX11.so.6.

* The erp.tar directory tree must live exactly in /usr/local/erp/* because of ancient hardcoded path spaghetti.

* The PATH to the executables for login shells is added for all users by updating /etc/profile.d/custom.sh


Launching the container
-----------------------


* Start the docker image as in DG's instructions

	docker run -d --name uxrdp_erpss --hostname terminalserver \
        --shm-size 1g -p 3389:3389 -p 2222:22 uxrdp_erpss

* Launch Microsoft Remote Desktop app and connect to PC localhost:3389

* log in as user lab, password lab


Installing merp2table
---------------------

Open a terminal window and conda install it like so

    conda activate
    conda install merp2tbl -c kutaslab -c defaults -c conda-forge -y


Testing ERPSS and merp2table
----------------------------

Open a terminal window, navigate to /home/lab/tests and run

    ./run_test.sh
	merp2table typical_good.mcf | less -S


Files
------

* The erp.tar tarball is snapshot of ERPSS Slackware 11 /usr/local/erp/* as Paul Krewski left it circa 2017.   The files in this tree are also available on UCSD kutaslab linux /mklab/home/backups/erp/*

* update_custom.sh creates or extends /etc/profile.d/custom.sh for PATH to to ERPSS executables.

* tests contains non-human subjects test data files and the run_tests.sh bash script to smoke test the installation.





