#!/bin/bash

# Vérifier si le script est exécuté avec les droits d'administration
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté avec les droits d'administration" 
   exit 1
fi

echo "Mise à jour de Homebrew et installation des outils de développement nécessaires..."

# Installation de Homebrew s'il n'est pas déjà installé
if ! command -v brew &> /dev/null; then
    echo "Homebrew non détecté. Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Ajouter Homebrew au PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew est déjà installé."
fi

# Mise à jour de Homebrew
brew update

# Liste des outils de développement à installer
TOOLS=(
    git
    node
    python
    wget
    cmake
)

# Installation des outils
for TOOL in "${TOOLS[@]}"; do
    if ! brew list $TOOL &> /dev/null; then
        echo "Installation de $TOOL..."
        brew install $TOOL
    else
        echo "$TOOL est déjà installé."
    fi
done

echo "Installation terminée."
