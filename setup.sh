#!/usr/bin/env bash

set -eu

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

git config --global user.email "yxj0207@gmail.com"
git config --global user.name "Xiaojie Yuan"
git config --global core.editor vim
git config --global push.default simple
git config --global core.excludesfile "$HOME/.gitignore"
git config --global rebase.instructionformat "[%an] %s"

cd "$HOME"

$PKG_INSTALL git                \
             zsh                \
             tmux               \
             vim                \
             global             \
             curl               \
             ack                \
             cmake              \
             fontconfig         \
             lsof               \
             bear

if [ "$(uname -s)" = 'Darwin' ]; then
  $PKG_INSTALL rg bat
fi

if [ ! -d .oh-my-zsh ]; then
  git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh || exit
fi

if [ ! -d .oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions .oh-my-zsh/custom/plugins/zsh-autosuggestions || exit
fi

if [ ! -d .tmux/plugins/tpm ]; then
  mkdir -p .tmux/plugins
  git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
fi

rm -f .oh-my-zsh/themes/llseek.zsh-theme
ln -svf "$ROOT"/llseek.zsh-theme .oh-my-zsh/themes/

sudo chsh -s "$(command -v zsh)" $LOGNAME

for f in .zshrc .tmux.conf .vimrc .ackrc .gitignore; do
  [ -f $f ] || [ -d $f ] && [ ! -L $f ] && mv $f $f.old
  ln -svf "$ROOT/$f" .
done

vim --noplugin +PlugInstall +qall

install_ctags
install_ccls
install_ycm
install_cc

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
