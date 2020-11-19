#!/usr/bin/env bash

set -eu

ZTV_ROOT=$PWD

if [ "$(uname -s)" == 'Darwin' ]; then
  PKG_INSTALL='brew install'
  FIREFOX_PROFILE='Library/Application\ Support/Firefox/Profiles'
  FONTS_DIR='Library/Fonts'
else
  PKG_INSTALL='sudo apt -y install'
  FIREFOX_PROFILE='.mozilla/firefox'
  FONTS_DIR='.fonts'
fi

git config user.email "yxj@gmail.com"
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
             ctags              \
             global             \
             curl               \
             ack                \
             cmake              \
             fontconfig

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

echo "Enter your sudo passwd to chsh: "
chsh -s "$(command -v zsh)"

for f in .zshrc .tmux.conf .vimrc .ssh .gitignore; do
  [ -f $f ] || [ -d $f ] && [ ! -L $f ] && mv $f $f.old
  ln -svf "$ZTV_ROOT/$f" .
done

vim +PlugInstall +qall

if [ "$(uname -s)" != 'Darwin' ]; then
  $PKG_INSTALL zlib1g-dev python3-dev libclang-dev llvm-dev
fi

# install ycm
pushd .vim/plugged/YouCompleteMe
./install.py --clangd-completer
popd

# install cc
pushd .vim/plugged/color_coded
mkdir -p build
cd build
cmake -DDOWNLOAD_CLANG=0 ..
make -j16
make install
popd

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
