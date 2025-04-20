# Configuration d'un Serveur NFS

Ce document décrit comment configurer un serveur NFS (Network File System) pour partager des dossiers sur votre réseau local.

## Introduction

NFS (Network File System) est un protocole de système de fichiers distribué permettant à un utilisateur d'accéder à des fichiers sur un réseau comme s'ils étaient stockés localement. Ce document explique la configuration d'un serveur NFS.

## Prérequis

- Un système Linux (Ubuntu, Debian, CentOS, etc.)
- Privilèges administrateur (sudo)
- Connaissance de base de l'adressage IP et des réseaux

## Installation

Sur la plupart des distributions Linux, vous devez installer le package NFS server:

### Debian/Ubuntu:
```bash
sudo apt update
sudo apt install nfs-kernel-server
```

### CentOS/RHEL:
```bash
sudo yum install nfs-utils
```

## Configuration

### 1. Créer un dossier à partager

Créez le répertoire que vous souhaitez partager:

```bash
sudo mkdir -p /srv/nfs/shared
```

Assurez-vous que les permissions sont correctement configurées:

```bash
sudo chown nobody:nogroup /srv/nfs/shared
sudo chmod 777 /srv/nfs/shared
```

### 2. Configurer le fichier exports

Modifiez le fichier de configuration NFS `/etc/exports` pour spécifier quels répertoires sont partagés et avec quelles machines:

```bash
sudo nano /etc/exports
```

Ajoutez la ligne suivante (exemple):

```
/srv/nfs/shared 192.168.1.0/24(rw,sync,no_subtree_check)
```

Cette configuration permet:
- Partage du dossier `/srv/nfs/shared`
- Accessible au réseau `192.168.1.0/24` (tous les hôtes de 192.168.1.1 à 192.168.1.254)
- `rw`: Accès en lecture et écriture
- `sync`: Écriture synchrone
- `no_subtree_check`: Améliore la fiabilité

### 3. Appliquer les changements

Après avoir modifié le fichier exports, appliquez les changements:

```bash
sudo exportfs -a
```

### 4. Redémarrer le service NFS

```bash
sudo systemctl restart nfs-kernel-server    # Debian/Ubuntu
# ou
sudo systemctl restart nfs-server           # CentOS/RHEL
```

## Configuration du Pare-feu

Si vous utilisez un pare-feu, vous devez autoriser le trafic NFS:

### UFW (Ubuntu):
```bash
sudo ufw allow from 192.168.1.0/24 to any port nfs
```

### Firewalld (CentOS/RHEL):
```bash
sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --reload
```

## Configuration du Client

Pour monter le partage NFS sur un client:

```bash
sudo mkdir -p /mnt/nfs/shared
sudo mount -t nfs SERVER_IP:/srv/nfs/shared /mnt/nfs/shared
```

Pour un montage persistant, ajoutez cette ligne à `/etc/fstab`:

```
SERVER_IP:/srv/nfs/shared /mnt/nfs/shared nfs defaults 0 0
```

## Dépannage

- Vérifiez le statut du service: `systemctl status nfs-server`
- Vérifiez les partages NFS actifs: `showmount -e localhost`
- Consultez les journaux: `journalctl -u nfs-server`

## Sécurité

- NFS n'est pas chiffré par défaut. Utilisez-le uniquement sur des réseaux de confiance.
- Limitez l'accès aux adresses IP spécifiques nécessaires.
- Envisagez d'utiliser NFSv4 avec Kerberos pour une sécurité accrue.

## Ressources supplémentaires

- Documentation officielle NFS
- Manuel: `man exports`
- Manuel: `man nfs`