#!/usr/bin/env bash

set -eu

do_link() {
  [ -f $1 ] || [ -d $1 ] && [ ! -L $1 ] && mv $1 $1.old
  ln -svf "$ROOT/$1"
}

install_ctags() {
  if command -v ctags && (ctags --version | grep "Universal Ctags"); then
    return
  fi
  $PKG_INSTALL autoconf automake pkg-config
  rm -rf /tmp/ctags
  git clone https://github.com/universal-ctags/ctags.git /tmp/ctags
  pushd /tmp/ctags
  ./autogen.sh
  ./configure --prefix=/usr/local
  make -j16
  sudo make install
  popd
}

install_ccls() {
  command -v ccls && return
  $PKG_INSTALL zlib1g-dev python3-dev clang-9 libclang-9-dev llvm-9-dev liblua5.2-dev libncurses5-dev rapidjson-dev ninja-build
  git clone https://github.com/MaskRay/ccls /tmp/ccls
  pushd /tmp/ccls
  cmake -H. -GNinja -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/llvm-9 -DLLVM_INCLUDE_DIR=/usr/lib/llvm-9/include
  cmake --build Release
  cd Release
  sudo ninja install
  rm -rf /tmp/ccls
  popd
}

install_ycm() {
  [ -f ".vim/plugged/YouCompleteMe/third_party/ycmd/ycm_core.so" ] && return
  pushd .vim/plugged/YouCompleteMe
  ./install.py
  popd
}

install_cc() {
  [ -f ".vim/plugged/color_coded/color_coded.so" ] && return
  if [ "$(uname -s)" != 'Darwin' ]; then
    sudo ln -sf $(command -v llvm-config-9) /usr/bin/llvm-config
  fi
  pushd .vim/plugged/color_coded
  rm -rf build
  mkdir -p build
  cmake -DDOWNLOAD_CLANG=0 ..
  make -j16
  make install
  popd
}

install_git() {
  $PKG_INSTALL git
}

config_git() {
  git config --global user.email "yxj0207@gmail.com"
  git config --global user.name "Xiaojie Yuan"
  git config --global core.editor vim
  git config --global push.default simple
  git config --global core.excludesfile "$HOME/.gitignore"
  git config --global rebase.instructionformat "[%an] %s"
  do_link .gitignore
}

install_vim() {
  $PKG_INSTALL vim
}

config_vim() {
  do_link .vimrc
  vim --noplugin +PlugInstall +qall
  install_ctags
  install_ccls
  install_ycm
  install_cc
}

install_zsh() {
  $PKG_INSTALL zsh
}

config_zsh() {
  if [ ! -d .oh-my-zsh ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
  fi
  if [ ! -d .oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions .oh-my-zsh/custom/plugins/zsh-autosuggestions
  fi
  rm -f .oh-my-zsh/themes/llseek.zsh-theme
  ln -svf "$ROOT"/llseek.zsh-theme .oh-my-zsh/themes/
  do_link .zshrc
  sudo chsh -s "$(command -v zsh)" $LOGNAME
}

install_tmux() {
  $PKG_INSTALL tmux
}

config_tmux() {
  if [ ! -d .tmux/plugins/tpm ]; then
    mkdir -p .tmux/plugins
    git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
  fi
  do_link .tmux.conf
}

ROOT=$PWD

if [ "$(uname -s)" == 'Darwin' ]; then
  brew upgrade
  PKG_INSTALL='brew install'
  FIREFOX_PROFILE='Library/Application\ Support/Firefox/Profiles'
  FONTS_DIR='Library/Fonts'
else
  sudo apt -y update
  PKG_INSTALL='sudo apt -y install'
  FIREFOX_PROFILE='.mozilla/firefox'
  FONTS_DIR='.fonts'
fi

cd "$HOME"

$PKG_INSTALL global             \
             curl               \
             ack                \
             cmake              \
             fontconfig         \
             lsof               \
             bear

if [ "$(uname -s)" = 'Darwin' ]; then
  $PKG_INSTALL rg bat
fi

install_git
config_git
install_vim
config_vim
install_zsh
config_zsh
install_tmux
config_tmux

echo '    StrictHostKeyChecking no' | sudo tee -a /etc/ssh/ssh_config
echo '    UserKnownHostsFile /dev/null' | sudo tee -a /etc/ssh/ssh_config

mkdir -p $FONTS_DIR
cp "$ROOT"/fonts/* $FONTS_DIR
fc-cache -f

# NOTE: need to toolkit.legacyUserProfileCustomizations.stylesheets to true in about:config
#       https://github.com/piroor/treestyletab/wiki/Code-snippets-for-custom-style-rules#slightly-betterworse-option-for-hiding-tabs-depending-on-what-you-want
if [ -d "$FIREFOX_PROFILE" ]; then
  d=$(ls -d "$FIREFOX_PROFILE"/*default*)
  mkdir -p "$d"/chrome
  cp "$ROOT"/firefox/userChrome.css "$d"/chrome
  echo "Firefox's userChrome.css: $d/chrome/userChrome.css"
fi

echo "Asia/Shanghai" | sudo tee /etc/timezone
