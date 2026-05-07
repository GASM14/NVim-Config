#!/bin/bash
set -e

# ----- Detect OS and set package manager / tool paths -----
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt update && sudo apt install -y"
    OS_DEPENDS="lua5.1 luarocks g++ imagemagick npm git curl"
  elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
    OS_DEPENDS="lua5.1 luarocks gcc-c++ ImageMagick nodejs npm git curl"
  else
    echo "Unsupported Linux distribution."
    exit 1
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  PKG_MANAGER="brew"
  INSTALL_CMD="brew install"
  # Homebrew already handles luarocks, imagemagick, node, npm, git, curl, gcc
  OS_DEPENDS="luarocks imagemagick node npm git curl"
  # neovim is also installed via homebrew later
else
  echo "Unsupported OS."
  exit 1
fi

# ----- Install system dependencies (Neovim + core tools) -----
echo "Installing system packages..."
if [[ "$PKG_MANAGER" == "apt" ]]; then
  sudo apt update
  sudo apt install -y neovim $OS_DEPENDS
elif [[ "$PKG_MANAGER" == "dnf" ]]; then
  sudo dnf install -y neovim $OS_DEPENDS
elif [[ "$PKG_MANAGER" == "brew" ]]; then
  brew install neovim $OS_DEPENDS

  # Compile and install Lua 5.1 from source (needed for Neorg/Luarocks)
  echo "Installing Lua 5.1 from source (required by Neorg)..."
  cd /tmp
  curl -LO https://www.lua.org/ftp/lua-5.1.5.tar.gz
  tar -xzf lua-5.1.5.tar.gz
  cd lua-5.1.5
  make macosx test
  sudo make install
  cd ~ && rm -rf /tmp/lua-5.1.5*
fi

# ----- Install tree‑sitter CLI (npm) -----
echo "Installing tree‑sitter CLI..."
if [[ "$PKG_MANAGER" == "brew" ]]; then
  # npm is user‑owned on Homebrew; installing globally with sudo can break permissions
  npm install -g tree-sitter-cli
else
  sudo npm install -g tree-sitter-cli
fi

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

# Compile norg (has external scanner)
git clone https://github.com/nvim-neorg/tree-sitter-norg.git
cd tree-sitter-norg
tree-sitter generate
# Manually compile scanner and parser, then link
g++ -c -I./src ./src/scanner.cc -o scanner.o
gcc -c -I./src ./src/parser.c -o parser.o
g++ -shared -o tree-sitter-norg.so parser.o scanner.o
mkdir -p ~/.local/share/nvim/site/parser
cp tree-sitter-norg.so ~/.local/share/nvim/site/parser/norg.so
cd ..

# Compile norg_meta (no scanner, simpler)
git clone https://github.com/nvim-neorg/tree-sitter-norg-meta.git
cd tree-sitter-norg-meta
tree-sitter generate
gcc -c -I./src ./src/parser.c -o parser.o
gcc -shared -o tree-sitter-norg-meta.so parser.o
cp tree-sitter-norg-meta.so ~/.local/share/nvim/site/parser/norg_meta.so

cd ~ && rm -rf /tmp/parsers

# ----- Install Neorg rocks -----
echo "Installing Neorg Lua rocks..."
cd ~/.local/share/nvim/lazy/neorg
luarocks --tree ./.rocks install dkjson lua-utils.nvim nui.nvim pathlib.nvim nvim-nio

echo "✅ Neovim configuration installed successfully!"
