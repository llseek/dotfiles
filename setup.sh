#!/usr/bin/env bash

set -eu

ZTV_ROOT=$PWD

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

git config user.email "yxj0207@gmail.com"
git config user.name "Xiaojie Yuan"
git config core.editor vim
git config push.default simple
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

cp "$ZTV_ROOT"/llseek.zsh-theme ./.oh-my-zsh/themes/

sudo chsh -s "$(command -v zsh)" $LOGNAME

for f in .zshrc .tmux.conf .vimrc .ackrc .ssh .gitignore; do
  [ -f $f ] || [ -d $f ] && [ ! -L $f ] && mv $f $f.old
  ln -svf "$ZTV_ROOT/$f" .
done

vim --noplugin +PlugInstall +qall

# install universal-ctags
if ! command -v ctags || ! (ctags --version | grep "Universal Ctags"); then
  rm -rf /tmp/ctags
  git clone https://github.com/universal-ctags/ctags.git /tmp/ctags
  pushd /tmp/ctags
  ./autogen.sh
  ./configure --prefix=/usr/local
  make -j16
  sudo make install
  popd
fi

# install ccls
if ! command -v ccls; then
  $PKG_INSTALL zlib1g-dev python3-dev clang-9 libclang-9-dev llvm-9-dev liblua5.2-dev libncurses5-dev rapidjson-dev ninja-build
  git clone https://github.com/MaskRay/ccls /tmp/ccls
  pushd /tmp/ccls
  cmake -H. -GNinja -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/llvm-9 -DLLVM_INCLUDE_DIR=/usr/lib/llvm-9/include
  cmake --build Release
  cd Release
  sudo ninja install
  rm -rf /tmp/ccls
  popd
fi

# install ycm
if [ ! -f ".vim/plugged/YouCompleteMe/third_party/ycmd/ycm_core.so" ]; then
  pushd .vim/plugged/YouCompleteMe
  ./install.py
  popd
fi

# install cc
if [ ! -f ".vim/plugged/color_coded/color_coded.so" ]; then
  sudo ln -sf $(command -v llvm-config-9) /usr/bin/llvm-config
  pushd .vim/plugged/color_coded
  mkdir -p build
  cd build
  if [ "$(uname -s)" != 'Darwin' ]; then
    cmake -DDOWNLOAD_CLANG=0 ..
  else
    cmake ..
  fi
  make -j16
  make install
  popd
fi

echo '    StrictHostKeyChecking no' | sudo tee -a /etc/ssh/ssh_config
echo '    UserKnownHostsFile /dev/null' | sudo tee -a /etc/ssh/ssh_config

mkdir -p $FONTS_DIR
cp "$ZTV_ROOT"/fonts/* $FONTS_DIR
fc-cache -f

# NOTE: need to toolkit.legacyUserProfileCustomizations.stylesheets to true in about:config
#       https://github.com/piroor/treestyletab/wiki/Code-snippets-for-custom-style-rules#slightly-betterworse-option-for-hiding-tabs-depending-on-what-you-want
if [ -d "$FIREFOX_PROFILE" ]; then
  d=$(ls -d "$FIREFOX_PROFILE"/*default*)
  mkdir -p "$d"/chrome
  cp "$ZTV_ROOT"/firefox/userChrome.css "$d"/chrome
  echo "Firefox's userChrome.css: $d/chrome/userChrome.css"
fi

echo "Asia/Shanghai" | sudo tee /etc/timezone
