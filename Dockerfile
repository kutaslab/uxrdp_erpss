FROM danielguerra/ubuntu-xrdp:20.04

# install i386 libs
RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get -y install libstdc++6:i386 libx11-6:i386

# install ERPSS and patch /etc/profile.d/custom.sh PATH
ADD erpss_install/erp.tgz /usr/local
ADD erpss_install/erpss_patch_custom.sh /usr/bin
RUN bash erpss_patch_custom.sh
    
# optional but useful
COPY erpss_install /opt/erpss_install
RUN apt-get -y install build-essential emacs
RUN addgroup --gid 1001 lab && \
    useradd -m -u 1001 -s /bin/bash -g 1001 lab && \
    echo "lab:$(openssl passwd -1 lab)" | /usr/sbin/chpasswd -e && \
    usermod -aG sudo lab
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    runuser -u lab -- bash /tmp/miniconda.sh -b -p /home/lab/miniconda && \
    runuser -u lab -- /home/lab/miniconda/bin/conda shell.bash hook | sed  's/conda activate base//' >> /home/lab/.bashrc && \
    runuser -u lab -- /home/lab/miniconda/bin/conda install mamba -c conda-forge --strict-channel-priority -y && \
    runuser -u lab -- cp -r /opt/erpss_install/tests /home/lab && \
    rm /tmp/miniconda.sh
