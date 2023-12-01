#!/bin/bash

# Script: Django Project Initialization with pyenv-virtualenv
# Author: Alexandre Guillin

set -e
DEBUG=true

# ===================================== #
# =========  Fonctions utiles ========= #
# ===================================== #

# Affichage des messages
print_error() {
    echo -e "\033[0;31m[!!!] $1\033[0m"
}

print_success() {
    echo -e "\033[0;32m[OK] $1\033[0m"
}

print_info() {
    echo -e "\033[0;34m[INFO] $1\033[0m"
}

print_additional_info() {
    echo -e "\033[0;33m[***] $1\033[0m"
}

check_python_version() {
    if pyenv versions | grep -q $1 ; then
        return 0
    else
        return 1
    fi
}

run_command_silently() {
    if [ "$DEBUG" = true ]; then
        echo "[*] Exécution de la commande: $@"
    fi
    # Exécute la commande et capture la sortie standard (stdout) et la sortie d'erreur (stderr)
    output=$(eval "$@" 2>&1)

    if [ $? -eq 0 ]; then
        # La commande a réussi, affiche la commande exécutée
        if [ "$DEBUG" = true ]; then
            echo "[*] Commande exécutée avec succès: $@"
        fi
        return 0
    else
        # La commande a échoué, affiche la commande exécutée
        echo "[!!!] La commande '$@' a échoué avec la sortie suivante:"
        # Affiche la sortie d'erreur de la commande
        print_error "$output"
        return 1
    fi
}

open_terminal_and_run_commands() {
    commands=("$@")

    # Création de la commande à exécuter dans le terminal
    osascript -e "tell application \"Terminal\" to do script \"$(IFS=';'; echo "${commands[*]}")\""
    if [ $? -eq 0 ]; then
        print_success "Un terminal a été ouvert et les commandes ont été exécutées."
    else
        print_error "Une erreur est survenue lors de l'ouverture du terminal et de l'exécution des commandes."
    fi
}

clean_venv() {
    # Suppression de l'environnement virtuel
    read -p "Voulez-vous supprimer un environnement virtuel ? (y/n) " delete_env
    if [ "$delete_env" == "y" ]; then
        print_additional_info "Voici une liste des environnements virtuels installés :"
        pyenv virtualenvs
        read -p "Taper le nom de l'environnement virtuel à supprimer : " env_name
        pyenv virtualenv-delete $env_name
        if [ $? -eq 0 ]; then
            print_success "L'environnement virtuel $env_name a été supprimé."
            return 0
        else
            print_error "L'environnement virtuel $env_name n'a pas été supprimé."
            return 1
        fi
    else
        print_info "Suppression de l'environnement virtuel annulée."
        exit 0
    fi
}

clean_project() {
    project_path=$1
    # Vérifie si le dossier existe
    print_info "Vérification de l'existence du dossier $project_path..."
    if [ ! -d "$project_path" ]; then
        print_error "Le dossier $project_path n'existe pas."
        exit 1
    fi
    # Suppression du dossier du projet et de l'environnement python local
    read -p "Voulez-vous supprimer le dossier du projet Django et l'environnement python local ? (y/n) " delete_project
    if [ "$delete_project" == "y" ]; then
        print_additional_info "Suppression du dossier du projet et de l'environnement python local..."
        run_command_silently rm -rf $project_path
        if [ $? -eq 0 ]; then
            print_success "Le dossier $project_path et l'environnement python local ont été supprimés."
            return 0
        else
            print_error "Le dossier $project_path et l'environnement python local n'ont pas été supprimés, une erreur est survenue."
            return 1
        fi
    else
        print_info "Suppression du dossier du projet et de l'environnement python local annulée."
        exit 0
    fi
}

# ===================================== #
# ========= Script principal =========  #
# ===================================== #

# ***************************** #
# *** Commandes de nettoyage ** #
# ***************************** #

# Vérifie si une option --clean a été passée (suppression de l'environnement virtuel)
if [ "$1" == "--clean" ]; then
    # Suppression de l'environnement virtuel
    clean_venv
    exit 0
    # Véfirier si une option --clean-all a été passée (suppression du dossier du projet et de l'environnement python local)
elif [ "$1" == "--clean-all" ]; then
    # Vérifier si un deuxième argument a été passé (chemin du dossier du projet)
    if [ -z "$2" ]; then
        print_error "Veuillez spécifier le chemin du dossier du projet à supprimer."
        print_additional_info "Usage: $0 --clean-all <chemin_dossier>"
        print_additional_info "Exemple: $0 --clean-all /Users/username/Projects/MyProject"
        exit 1
    fi
    # Suppression de l'environnement virtuel
    clean_venv
    # Suppression du dossier du projet et de l'environnement python local
    clean_project $2
    exit 0
fi

# ********************* #
# ** Début du script ** #
# ********************* #

# Vérifie si pyenv est installé
if run_command_silently pyenv --version ; then
    print_info "pyenv est déjà installé"
else
    read -p "pyenv n'est pas installé. Voulez-vous l'installer maintenant ? (y/n) " install_pyenv
    if [ "$install_pyenv" == "y" ]; then
        # Installe les dépendances de pyenv
        if command -v brew &> /dev/null ; then
            brew install openssl readline sqlite3 xz zlib
            curl https://pyenv.run | bash
        else
            print_error "Homebrew n'est pas installé. Veuillez l'installer pour continuer."
            exit 1
        fi
    else
        print_error "Installation annulée. Vous devez avoir pyenv installé pour continuer."
        exit 1
    fi
fi

# Vérifie si virtualenv est installé
if run_command_silently virtualenv --version ; then
    print_info "virtualenv est déjà installé"
else
    read -p "virtualenv n'est pas installé. Voulez-vous l'installer maintenant ? (y/n) " install_virtualenv
    if [ "$install_virtualenv" == "y" ]; then
        print_info "Mise à jour de pip..."
        run_command_silently pip install --upgrade pip
        print_info "Installation de virtualenv..."
        run_command_silently pip install virtualenv
    else
        print_info "Installation annulée. Vous devez avoir virtualenv installé pour continuer."
        exit 1
    fi
fi

# Vérifie si le nombre d'arguments est correct
if [ "$#" -ne 4 ]; then
    print_error "Nombre d'arguments invalide."
    print_additional_info "Usage: $0 <chemin_dossier> <version_python> <version_django> <project_name>"
    print_additional_info "Exemple: $0 /Users/username/Projects/MyProject 3.8.5 3.1.2 MyProject"
    print_additional_info "Pour voir les versions de python : pyenv install --list | grep ' 3\.'"
    print_additional_info "Pour voir les version de django : pip install django=="
    exit 1
fi

# Vérifie si le dossier existe et demande si il faut créer le dossier
if [ ! -d "$1" ]; then
    read -p "Le dossier $1 n'existe pas. Voulez-vous le créer ? (y/n) " create_folder
    if [ "$create_folder" == "y" ]; then
        print_info "Création du dossier $1..."
        run_command_silently mkdir -p $1
        if [ $? -eq 0 ]; then
            print_success "Le dossier $1 a été créé."
        else
            print_error "Le dossier $1 n'a pas été créé, une erreur est survenue."
            exit 1
        fi
    else
        print_info "Création du dossier annulée."
        print_error "Vous devez créer un dossier pour continuer."
        exit 1
    fi
fi

dossier=$1
version_python=$2
version_django=$3
project_name=$4

# Vérifie si la version de python est déjà installée et l'installe si ce n'est pas le cas
if check_python_version $version_python ; then
    print_info "Python $version_python est déjà installé"
else
    print_additional_info "Python $version_python n'est pas installé, installation en cours..."
    run_command_silently pyenv install -v $version_python
fi

# Aller dans le dossier du projet
cd $dossier

# Création de l'environnement virtuel
print_info "Création de l'environnement virtuel..."
run_command_silently pyenv virtualenv $version_python $project_name
if [ $? -eq 0 ]; then
    print_success "L'environnement virtuel a été créé."
    print_additional_info "Il pourra être effacé avec la commande 'pyenv virtualenv-delete $project_name'"
fi

# Activation de la version de python dans le dossier (local)
print_info "Activation de la version $version_python de python dans le dossier $dossier (local)"
run_command_silently pyenv local $version_python
if [ $? -eq 0 ]; then
    print_success "La version $version_python de python a été activée dans le dossier $dossier (local)"
fi

print_info "Un terminal va s'ouvrir avec l'environnement virtuel activé et le projet django '$project_name' installé."

# Ouverture d'un terminal et exécution des commandes
open_terminal_and_run_commands "cd $dossier" "pyenv activate $project_name" "pip install --upgrade pip" "pip install django==$version_django" "django-admin startproject $project_name"
