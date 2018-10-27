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
wget https://github.com/fonero-project/fonero/releases/download/v0.13.0.3/fonero-0.13.0.3-linux.tgz
tar -xvf fonero-0.13.0.3-linux.tgz
rm fonero-0.13.0.3-linux.tgz
mv fonero-0.13.0.3-linux/fonerod ./fonerod
mv fonero-0.13.0.3-linux/fonero-cli ./fonero-cli
mv fonero-0.13.0.3-linux/fonero-tx ./fonero-tx
mv fonero-0.13.0.3-linux/fonero-qt ./fonero-qt
rm -rf fonero-0.13.0.3-linux
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
echo -e "server=1\nlisten=1\ndaemon=1\nmaxconnections=256\nmasternode=1\nmasternodeprivkey=$masternodekey\nrpcuser=fonerorpc\nrpcpassword=d92bb33446cefaf765ad6202f518709b\nrpcport=19192\nrpcallowip=127.0.0.1\naddnode=85.10.194.14:19190\naddnode=188.40.62.51:19190\naddnode=37.9.52.254:19190\naddnode=37.9.52.253:19190\naddnode=37.9.52.252:19190\naddnode=37.9.52.17:19190\naddnode=37.9.52.16:19190\naddnode=5.188.205.146:19190\naddnode=5.188.205.112:19190\naddnode=5.188.204.7:19190\naddnode=5.188.204.5:19190\naddnode=5.188.204.4:19190\naddnode=5.188.204.3:19190\naddnode=5.188.63.248:19190\naddnode=5.188.63.247:19190\naddnode=5.188.63.102:19190\naddnode=5.188.63.50:19190\n" >> "/root/.fonerocore/fonero.conf"
sleep 3
sudo sed -i -e "s/exit 0/sudo \-u root \/opt\/fonero-core\/fonerod \> \/dev\/null \&\nexit 0/g" /etc/rc.local
./fonerod -daemon
echo "Masternode private key: $masternodekey"
echo "Job completed successfully"
