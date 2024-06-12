#!/bin/bash

set -e

# Fonction pour vérifier et installer Homebrew
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrew n'est pas installé. Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew est déjà installé."
  fi
}

# Fonction pour installer iTerm2
install_iterm2() {
  if ! brew list --cask | grep -q "^iterm2$"; then
    echo "Téléchargement et installation d'iTerm2..."
    brew install --cask iterm2
  else
    echo "iTerm2 est déjà installé."
  fi
}

# Fonction pour installer Zsh
install_zsh() {
  if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/local/bin/zsh" ]; then
    if ! brew list | grep -q "^zsh$"; then
      echo "Installation de Zsh..."
      brew install zsh
    else
      echo "Zsh est déjà installé."
    fi
    chsh -s "$(which zsh)"
  else
    echo "Zsh est déjà le shell par défaut."
  fi
}

# Fonction pour installer Oh My Zsh
install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installation d'Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "Oh My Zsh est déjà installé."
  fi
}

# Fonction pour installer Hack Nerd Font
install_font() {
  if ! brew list --cask | grep -q "^font-hack-nerd-font$"; then
    echo "Téléchargement et installation de Hack Nerd Font..."
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
  else
    echo "Hack Nerd Font est déjà installé."
  fi
}

# Fonction pour installer Powerlevel10k
install_powerlevel10k() {
  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installation du thème Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  else
    echo "Powerlevel10k est déjà installé."
  fi
}

# Fonction pour configurer Zsh
configure_zsh() {
  echo "Configuration de Zsh..."
  if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
    sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
  fi
  if [ ! -f ~/.p10k.zsh ]; then
    echo "Configuration par défaut de Powerlevel10k..."
    curl -o ~/.p10k.zsh https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/config/p10k-classic.zsh
  fi
  if ! grep -q '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' ~/.zshrc; then
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
  fi
  source ~/.zshrc
}

# Fonction pour configurer iTerm2
configure_iterm2() {
  echo "Configuration d'iTerm2..."
  if [ ! -f ~/GruvboxDark.itermcolors ]; then
    curl -o ~/GruvboxDark.itermcolors https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/GruvboxDark.itermcolors
    open ~/GruvboxDark.itermcolors
  else
    echo "Le schéma de couleurs GruvboxDark est déjà téléchargé."
  fi
  echo "‼️ Allez dans iTerm2 -> Préférences -> Profiles -> Colors et importez GruvboxDark.itermcolors si ce n'est pas déjà fait."
}

# Exécution des fonctions
install_homebrew
install_iterm2
install_zsh
install_oh_my_zsh
install_font
install_powerlevel10k
configure_zsh
configure_iterm2

echo "Installation et configuration terminées avec succès !"
