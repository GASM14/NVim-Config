#!/bin/bash
set -e

# ----- Detect OS and set package manager / tool paths -----
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt update && sudo apt install -y"
    NEORGS_DEPENDS="lua5.1 luarocks g++ imagemagick npm git curl"
  elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
    NEORGS_DEPENDS="lua5.1 luarocks gcc-c++ ImageMagick nodejs npm git curl"
  else
    echo "Unsupported Linux distribution."
    exit 1
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  PKG_MANAGER="brew"
  INSTALL_CMD="brew install"
  NEORGS_DEPENDS="lua@5.1 luarocks gcc imagemagick node npm git curl"
  # Ensure Homebrew is installed
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Please install it first: https://brew.sh"
    exit 1
  fi
else
  echo "Unsupported OS."
  exit 1
fi

# ----- Install system dependencies (Neovim + tools) -----
echo "Installing system packages..."
if [[ "$PKG_MANAGER" == "apt" ]]; then
  sudo apt update
  sudo apt install -y neovim $NEORGS_DEPENDS
elif [[ "$PKG_MANAGER" == "dnf" ]]; then
  sudo dnf install -y neovim $NEORGS_DEPENDS
elif [[ "$PKG_MANAGER" == "brew" ]]; then
  brew install neovim $NEORGS_DEPENDS
fi

# ----- Install tree‑sitter CLI (npm) -----
echo "Installing tree‑sitter CLI..."
sudo npm install -g tree-sitter-cli

# ----- Clone your Neovim config (if not already present) -----
if [ ! -d "$HOME/.config/nvim" ]; then
  git clone https://github.com/GASM14/NVim-Config.git "$HOME/.config/nvim"
fi

# ----- Install Lazy plugins -----
echo "Installing Neovim plugins..."
nvim --headless "+Lazy sync" +qa

# ----- Compile and install norg parsers -----
echo "Building norg treesitter parsers..."
mkdir -p /tmp/parsers
cd /tmp/parsers

git clone https://github.com/nvim-neorg/tree-sitter-norg.git
cd tree-sitter-norg
tree-sitter generate && tree-sitter build
mkdir -p ~/.local/share/nvim/site/parser
cp tree-sitter-norg.so ~/.local/share/nvim/site/parser/norg.so

cd /tmp/parsers
git clone https://github.com/nvim-neorg/tree-sitter-norg-meta.git
cd tree-sitter-norg-meta
tree-sitter generate && tree-sitter build
cp tree-sitter-norg-meta.so ~/.local/share/nvim/site/parser/norg_meta.so

cd ~ && rm -rf /tmp/parsers

# ----- Install Neorg rocks -----
echo "Installing Neorg Lua rocks..."
cd ~/.local/share/nvim/lazy/neorg
luarocks --tree ./.rocks install dkjson lua-utils.nvim nui.nvim pathlib.nvim nvim-nio

echo "✅ Neovim configuration installed successfully!"
