# Déploiement de l'environnement de production pour WordPress en On-Premise avec Kubernetes et Vagrant

Ce dépôt permet de déployer un environnement de production pour WordPress en On-Premise avec Kubernetes et Vagrant.

## Contenu du dépôt

- `Vagrantfile`: Un fichier de configuration Vagrant pour spécifier les paramètres des machines virtuelles et déployer un nœud Master et deux  nœuds worker Kubernetes.
- `install-master.sh`: Un script shell pour installer et configurer un nœud Master Kubernetes.
- `install-worker.sh`: Un script shell pour installer et configurer un nœud worker Kubernetes.
- `setup-hosts.sh`: Un script shell pour configurer les fichiers hosts sur les nœuds pour la résolution des noms.

## Instructions d'utilisation

1. Clonez ce dépôt sur votre machine locale :

   ```bash
   git clone https://github.com/MassiTZ/Projet02-Kubernetes.git
   
2. Changez de répertoire vers le dépôt cloné :

   ```bash
   cd Projet02-Kubernetes

3. Démarrez les machines virtuelles Vagrant en exécutant la commande suivante :
   
    ```bash
    vagrant up
  - Cela lancera trois machines virtuelles Ubuntu, un nœud Master et deux nœuds Worker Kubernetes.
