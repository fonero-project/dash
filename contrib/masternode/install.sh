#!/bin/bash
if free | awk '/^Swap:/ {exit !$2}'; then
echo "Have swap"
else
sudo touch /var/swap.img
sudo chmod 600 /var/swap.img
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
mkswap /var/swap.img
sudo swapon /var/swap.img
sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
fi
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install mc htop git python-virtualenv ntpdate -y
sudo ntpdate -u pool.ntp.org
sudo mkdir /opt/fonero-core
cd /opt/fonero-core
wget https://github.com/fonero-project/fonero/releases/download/0.12.3.4/fonero-0.12.3.4-linux-x64.tgz
tar -xvf fonero-0.12.3.4-linux-x64.tgz
rm fonero-0.12.3.4-linux-x64.tgz
mv fonero-0.12.3.4-linux-x64/fonerod ./fonerod
mv fonero-0.12.3.4-linux-x64/fonero-cli ./fonero-cli
rm -rf fonero-0.12.3.4-linux-x64
chmod -R 755 /opt/fonero-core
cd /opt
git clone https://github.com/fonero-project/fonero-sentinel fonero-sentinel
cd fonero-sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
cat <(crontab -l) <(echo "* * * * * cd /opt/fonero-sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1") | crontab -
cd /opt/fonero-core
./fonerod -daemon
sleep 10
masternodekey=$(./fonero-cli masternode genkey)
./fonero-cli stop
sleep 3
echo -e "\ndaemon=1\nmaxconnections=256\nmasternode=1\nmasternodeprivkey=$masternodekey" >> "/root/.fonerocore/fonero.conf"
sleep 3
sudo sed -i -e "s/exit 0/sudo \-u root \/opt\/fonero-core\/fonerod \> \/dev\/null \&\nexit 0/g" /etc/rc.local
./fonerod -daemon
echo "Masternode private key: $masternodekey"
echo "Job completed successfully"
