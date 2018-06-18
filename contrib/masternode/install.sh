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
sudo mkdir /opt/azart-core
cd /opt/azart-core
wget https://github.com/azartpay/azart/releases/download/0.12.3.3/azart-0.12.3.3-linux-x64.tgz
tar -xvf azart-0.12.3.3-linux-x64.tgz
rm azart-0.12.3.3-linux-x64.tgz
mv azart-0.12.3.3-linux-x64/azartd ./azartd
mv azart-0.12.3.3-linux-x64/azart-cli ./azart-cli
rm -rf azart-0.12.3.3-linux-x64
chmod -R 755 /opt/azart-core
cd /opt
git clone https://github.com/azartpay/azart-sentinel azart-sentinel
cd azart-sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
cat <(crontab -l) <(echo "* * * * * cd /opt/azart-sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1") | crontab -
cd /opt/azart-core
./azartd -daemon
sleep 10
masternodekey=$(./azart-cli masternode genkey)
./azart-cli stop
sleep 3
echo -e "\ndaemon=1\nmaxconnections=256\nmasternode=1\nmasternodeprivkey=$masternodekey" >> "/root/.azartcore/azart.conf"
sleep 3
./azartd -daemon
echo "Masternode private key: $masternodekey"
echo "Job completed successfully"
