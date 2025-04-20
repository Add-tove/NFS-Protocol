#! /bin/bash

sudo apt update
sudo apt install nfs-common -y

Server_IP="192.168.186.129"
FolderPath="/home/ubuntu-user/NFS_Server"
MountedPath="/home/$(whoami)/NFS_Client"

sudo mkdir -p "$MountedPath"
echo "NFS Mounted Directory Created at $MountedPath"

sudo mount $Server_IP:"$FolderPath" "$MountedPath"
echo "NFS Mounted Directory at $MountedPath"
echo "NFS Server IP: $Server_IP"
