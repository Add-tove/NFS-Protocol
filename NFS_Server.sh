#! /bin/bash

sudo apt update
sudo apt install nfs-kernel-server -y

Client_IP="192.168.186.131"
FolderPath="/home/$(whoami)/NFS_Server"

sudo mkdir -p "$FolderPath"
echo "NFS Server Directory Created at $FolderPath"

sudo chown -R $(whoami):$(whoami) $FolderPath
echo "NFS Server Directory Ownership Changed to $(whoami)"


echo "$FolderPath $Client_IP(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
sudo systemctl restart nfs-kernel-server
echo "NFS Server Restarted"
