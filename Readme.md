## Description

An Ubuntu 20.04 Docker container recipe and support files for testing Kutas Lab compiled 32-bit binary EEG analysis software and conda packages.

## ERPSS

32-bit compiled EEG data analysis programs  
Kutas Cognitive Electrophysiology Lab  
University of California San Diego  

## Quickstart

* `git clone` this repo to the machine where you will build and run the Docker container

* on whatever machine you have ERPSS installed, make a tarball of the `/usr/local/erp` directory as `erp.tgz`

* move or copy `erp.tgz` to the `uxrdp_erpss/erpss_install` directory of this repo.


* In the repository root directory build the docker image like so.

  ```
  docker build -t uxrdp_erpss .
  ```
  
* This will automatically
  * Install Ubuntu 20.04
  * Install the XRDP server
  * Untar `erp.tgz` where it belongs in `/usr/local/erp`
  * Update `/etc/profile.d/custom.sh` so the default user PATH includes `/usr/local/erp/bin`
  * Create an admin user, with userid `lab` and password `lab`
  * Install `minconda3` so user `lab` can create and activate conda environments and install conda packages

* Start the container:

  ```
  docker run -d \
	--name uxrdp_erpss --hostname erpss_server --shm-size 1g \
	-p 3389:3389 -p 2222:22 \
	uxrdp_erpss
   ```
* Connect Microsoft Remote Desktop client to ```localhost:3389```
and login is a user `lab`, password `lab`

* In the Ubuntu FXCE desktop, open a terminal window,  navigate to /home/lab/tests and enter

  ```./run_test.sh```
  
  
* Install the `merp2tbl` utility into the base conda environment like so:

  ```
  conda activate base
  conda install merp2tbl -c kutaslab -c defaults -c conda-forge -y
  cd /home/lab/tests
  merp2table typical_good.mcf | less -S
  ```

## Notes

* Miniconda is pre-installed per-user only for user lab.

* To see host files from inside the Ubuntu run the container with the `-v` option like, for example, like so:

  ```
  docker run -d \
	--name uxrdp_erpss --hostname erpss_server --shm-size 1g \
	-p 3389:3389 -p 2222:22 \
	-v /Users/username/Work:/mnt/Work:/mnt:ro \
	uxrdp_erpss
  ```


---

# Docker image notes
https://github.com/danielguerra69/ubuntu-xrdp

## Ubuntu 20.04/18.04/16.04  Multi User Remote Desktop Server

Fully implemented Multi User xrdp
with xorgxrdp and pulseaudio
on Ubuntu 20.04/18.04/16.04.
Copy/Paste and sound is working.
Users can re-login in the same session.
Xfce4, Firefox are pre installed.

# Tags

danielguerra/ubuntu-xrdp:16.04
danielguerra/ubuntu-xrdp:18.04  or latest
danielguerra/ubuntu-xrdp:20.04

## Usage

Start the rdp server
(WARNING: use the --shm-size 1g or firefox/chrome will crash)

```bash
docker run -d --name uxrdp --hostname terminalserver --shm-size 1g -p 3389:3389 -p 2222:22 danielguerra/ubuntu-xrdp:20.04
```
*note if you already use a rdp server on 3389 change -p <my-port>:3389
	  -p 2222:22 is for ssh access ( ssh -p 2222 ubuntu@<docker-ip> )

Connect with your remote desktop client to the docker server.
Use the Xorg session (leave as it is), user and pass.

## Creation of users

To automate the creation of users, supply a file users.list in the /etc directory of the container.
The format is as follows:

```bash
id username password-hash list-of-supplemental-groups
```

The provided users.list file will create a sample user with sudo rights

Username: ubuntu
Password: ubuntu

To generate the password hash use the following line

```bash
openssl passwd -1 'newpassword'
```

Run the xrdp container with your file

```bash
docker run -d -v $PWD/users.list:/etc/users.list
```

You can change your password in the rdp session in a terminal

```bash
passwd
```

## Add new users

No configuration is needed for new users just do

```bash
docker exec -ti uxrdp adduser mynewuser
```

After this the new user can login

## Add new services

To make sure all processes are working supervisor is installed.
The location for services to start is /etc/supervisor/conf.d

Example: Add mysql as a service

```bash
apt-get -yy install mysql-server
echo "[program:mysqld] \
command= /usr/sbin/mysqld \
user=mysql \
autorestart=true \
priority=100" > /etc/supervisor/conf.d/mysql.conf
supervisorctl update
```

## Volumes
This image uses two volumes:
1. `/etc/ssh/` holds the sshd host keys and config
2. `/home/` holds the `ubuntu/` default user home directory

When bind-mounting `/home/`, make sure it contains a folder `ubuntu/` with proper permission, otherwise no login will be possible.

```
mkdir -p ubuntu
chown 999:999 ubuntu
```

## Installing additional packages during build

The Dockerfile has support for the build argument ADDITIONAL_PACKAGES to install additional packages during build. Either pass it with `--build-arg` during `docker build` or add it 
as `args` in your `docker-compose.override.yml` and run `docker-compose build`.

## To run with docker-compose

```bash
git clone https://github.com/danielguerra69/ubuntu-xrdp.git
cd ubuntu-xrdp/
vi docker-compose.override.yml # if you want to override any default value
docker-compose up -d
```
