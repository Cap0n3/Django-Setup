# Script d'Initialisation de Projet Django avec pyenv-virtualenv

## Description

Ce script Bash facilite la création d'un environnement virtuel avec `pyenv` et l'initialisation d'un projet Django. Il vérifie l'installation de `pyenv` et `virtualenv`, installe les dépendances nécessaires, crée un environnement virtuel avec une version spécifiée de Python, et initialise un projet Django dans un dossier spécifié.

## Utilisation

### Installation des Prérequis

1. Assurez-vous que pyenv n'est pas installé en exécutant `pyenv --version`.
2. Si pyenv n'est pas installé, le script propose de l'installer avec les dépendances nécessaires.
3. Assurez-vous que virtualenv n'est pas installé en exécutant `virtualenv --version`.
4. Si virtualenv n'est pas installé, le script propose de l'installer.

### Création d'un Environnement Virtuel et Initialisation d'un Projet Django

```bash
./DjangoSetup.sh <chemin_dossier> <version_python> <version_django> <project_name>
```
- `<chemin_dossier>`: Le chemin du dossier où vous souhaitez initialiser le projet.
- `<version_python>`: La version de Python à utiliser pour l'environnement virtuel.
- `<version_django>`: La version de Django à installer dans le projet.
- `<project_name>`: Le nom du projet Django.

#### Exemple

```bash
./DjangoSetup.sh /chemin/vers/le/projet 3.8.5 3.1.2 MonProjet
```

### Commandes de Nettoyage

Pour supprimer un environnement virtuel:

```bash
./DjangoSetup.sh --clean
```

> Le script affiche une liste des environnements virtuels installés et vous demande de choisir celui à supprimer.

Pour supprimer le dossier du projet et l'environnement python local associé:

```bash
./DjangoSetup.sh --clean-all <chemin_dossier>
```

> Le script affiche une liste des environnements virtuels installés et vous demande de choisir celui à supprimer. Il vérifie ensuite l'existence du dossier passé en argument, puis demande confirmation avant de procéder à la suppression.

## Remarques

- Assurez-vous que pyenv et Homebrew sont installés pour garantir le bon fonctionnement du script.
- L'environnement virtuel peut être supprimé ultérieurement avec la commande `pyenv virtualenv-delete <env_name>`.
