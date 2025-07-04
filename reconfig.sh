#!/bin/bash
VM_NAME='name'
INTERFACE='ens18'
IP_LOCAL='10.161.0.xx'
IP_GW='10.161.0.1'
#IP_PUB=''
#AMBIENTE='dev'
#IP_NFS=''

hostnamectl set-hostname $VM_NAME
sudo sed -i "s/ubuntubase/${VM_NAME}/"  /etc/hosts
cat /etc/hosts

cat <<EOF >  /etc/netplan/00-installer-config.yaml 
# This is the network config written by 'subiquity'
network:
  ethernets:
    interface:
      addresses:
      - ip_local/24
      nameservers:
        addresses: [10.129.19.5,10.129.19.4]
        search:
        - teste.edu.br
      routes:
      - to: default
        via: ip_gw
  version: 2
EOF

###  Configura IPs
echo 'Configura REDE'
sudo sed -i "s/interface/${INTERFACE}/" /etc/netplan/00-installer-config.yaml
sudo sed -i "s/ip_local/${IP_LOCAL}/" /etc/netplan/00-installer-config.yaml 
sudo sed -i "s/ip_pub/${IP_PUB}/"  /etc/netplan/00-installer-config.yaml
sudo sed -i "s/ip_gw/${IP_GW}/"  /etc/netplan/00-installer-config.yaml

cat /etc/netplan/00-installer-config.yaml

# /etc/fstab
#cat <<EOF >> /etc/fstab
#ip_nfs:/srv/nfs4/ambiente  /mnt/dados nfs rw,sync,hard,intr 0 0
#EOF

#sudo sed -i "s/ambiente/${AMBIENTE}/"  /etc/fstab
#sudo sed -i "s/ip_nfs/${IP_NFS}/"  /etc/fstab
#cat /etc/fstab
