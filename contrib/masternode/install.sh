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
sudo apt-get install nano mc htop git -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common -y
sudo apt-get install libboost-all-dev -y
sudo apt-get install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get -y install python-virtualenv
sudo apt-get -y install ntpdate
sudo ntpdate -u pool.ntp.org
cd
basedir="/opt"
azartdir=$basedir"/azart/"
azartcoredir=$basedir"/.azartcore/"
sudo mkdir $azartdir
cd $azartdir
wget https://github.com/azartpay/azart/releases/download/0.12.3.3/azart-0.12.3.3-linux-x64.tgz
tar -xvf azart-0.12.3.3-linux-x64.tgz
rm azart-0.12.3.3-linux-x64.tgz
mv azart-0.12.3.3-linux-x64/azartd ./azartd
mv azart-0.12.3.3-linux-x64/azart-cli ./azart-cli
rm -rf azart-0.12.3.3-linux-x64
chmod -R 755 $azartdir
cd $basedir
git clone https://github.com/azartpay/azart-sentinel azart-sentinel
cd azart-sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
cat <(crontab -l) <(echo "* * * * * cd /opt/azart-sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1") | crontab -
cd $azartdir
./azartd -daemon
sleep 10
masternodekey=$(./azart-cli masternode genkey)
./azart-cli stop
sleep 1
echo -e "\nmaxconnections=256\nmasternode=1\nmasternodeprivkey=$masternodekey" >> $azartcoredir"azart.conf"
sleep 1
./azartd -daemon
echo "Masternode private key: $masternodekey"
echo "Job completed successfully"
