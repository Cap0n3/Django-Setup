# Script d'Initialisation de Projet Django avec pyenv-virtualenv

## Description

Ce script Bash facilite la création d'un environnement virtuel avec `pyenv` et l'initialisation d'un projet Django. Il vérifie l'installation de `pyenv` et `virtualenv`, installe les dépendances nécessaires, crée un environnement virtuel avec une version spécifiée de Python, et initialise un projet Django dans un dossier spécifié.

## Utilisation

---

### Installation des Prérequis
1. Assurez-vous que pyenv n'est pas installé en exécutant `pyenv --version`.
2. Si pyenv n'est pas installé, le script propose de l'installer avec les dépendances nécessaires.
3. Assurez-vous que virtualenv n'est pas installé en exécutant `virtualenv --version`.
4. Si virtualenv n'est pas installé, le script propose de l'installer.

### Création d'un Environnement Virtuel et Initialisation d'un Projet Django

```bash
./init_project.sh <chemin_dossier> <version_python> <version_django> <project_name>
```
- `<chemin_dossier>`: Le chemin du dossier où vous souhaitez initialiser le projet.
- `<version_python>`: La version de Python à utiliser pour l'environnement virtuel.
- `<version_django>`: La version de Django à installer dans le projet.
- `<project_name>`: Le nom du projet Django.

### Suppression d'un Environnement Virtuel

Pour supprimer un environnement virtuel, utilisez l'option `--clean`:
```bash
./init_project.sh --clean
```

Le script affichera une liste des environnements virtuels installés et vous demandera le nom de celui que vous souhaitez supprimer.

**Note:** Les dépendances nécessaires à pyenv (telles que OpenSSL, Readline, SQLite3, XZ, zlib) seront installées si elles ne le sont pas déjà, en utilisant Homebrew.

## Exemple

---

```bash
./init_project.sh /chemin/vers/le/projet 3.8.5 3.1.2 MonProjet
```

## Remarques

---

- Assurez-vous que pyenv et Homebrew sont installés pour garantir le bon fonctionnement du script.
- L'environnement virtuel peut être supprimé ultérieurement avec la commande `pyenv virtualenv-delete <env_name>`.
