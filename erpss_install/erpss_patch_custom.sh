#!/bin/bash
# create or update etc/profile.d/custom.sh for ERPSS paths
custom_sh="/etc/profile.d/custom.sh"
if [[ ! -e "$custom_sh" ]]; then
    echo "#!/bin/sh" > $custom_sh
fi
echo "# add paths to ERPSS executables" >> $custom_sh
echo 'PATH=$PATH:/usr/local/erp/bin:/usr/local/erp/scripts' >> $custom_sh

