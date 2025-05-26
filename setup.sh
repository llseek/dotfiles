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
  if [ "$(uname -s)" == 'Darwin' ]; then
    $PKG_INSTALL ccls
    return
  fi
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
  cd build
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
  if [ "$(uname -s)" == 'Darwin' ]; then
    $PKG_INSTALL vim
    return
  fi

  if vim --version | grep '+clipboard' && vim --version | grep '+lua'; then
    return
  fi

  $PKG_INSTALL xorg-dev liblua5.2-dev autoconf automake pkg-config python3-dev
  sudo ln -sf /usr/include/{lua5.2,lua}
  sudo ln -sf /usr/lib/x86_64-linux-gnu/{liblua5.2.so,liblua.so}
  rm -rf /tmp/vim
  git clone --depth 1 https://github.com/vim/vim /tmp/vim
  pushd /tmp/vim
  ./configure --prefix=/usr/local \
              --enable-fail-if-missing \
              --enable-luainterp=yes \
              --enable-python3interp=yes \
              --with-x
  make -j16
  sudo make install
  popd
}

config_vim() {
  do_link .vimrc
  vim --noplugin +PlugInstall +qall
  install_ctags
  #install_ccls
  #install_ycm
  #install_cc
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
  if [ ! -d .oh-my-zsh/custom/plugins/zsh-completions ]; then
    git clone https://github.com/zsh-users/zsh-completions .oh-my-zsh/custom/plugins/zsh-completions
  fi
  if [ ! -d .oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting .oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  fi
  rm -f .oh-my-zsh/themes/llseek.zsh-theme
  ln -svf "$ROOT"/llseek.zsh-theme .oh-my-zsh/themes/
  do_link .zshrc
  if systemctl list-units | grep -q sssd.service; then
    # ldap scenario
    sudo sss_override user-add $LOGNAME -s "$(command -v zsh)"
    sudo systemctl restart sssd
  else
    sudo chsh -s "$(command -v zsh)" $LOGNAME
  fi
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

config_ssh() {
  echo '    StrictHostKeyChecking no' | sudo tee -a /etc/ssh/ssh_config
  echo '    UserKnownHostsFile /dev/null' | sudo tee -a /etc/ssh/ssh_config
}

config_font() {
  mkdir -p $FONTS_DIR
  cp "$ROOT"/fonts/* $FONTS_DIR
  fc-cache -f
}

config_firefox() {
  # NOTE: need to toolkit.legacyUserProfileCustomizations.stylesheets to true in about:config
  #       https://github.com/piroor/treestyletab/wiki/Code-snippets-for-custom-style-rules#slightly-betterworse-option-for-hiding-tabs-depending-on-what-you-want
  if [ -d "$FIREFOX_PROFILE" ]; then
    for d in $(ls -d "$FIREFOX_PROFILE"/*default*); do
      mkdir -p "$d"/chrome
      cd "$d"/chrome
      do_link firefox/userChrome.css
      do_link firefox/userContent.css
      cd -
    done
  fi
}

config_timezone() {
  echo "Asia/Shanghai" | sudo tee /etc/timezone
}

config_fcitx() {
  [ "$(uname -s)" == 'Darwin' ] && return
  $PKG_INSTALL fcitx-googlepinyin fcitx-frontend-qt5
  mkdir -p ~/.config/plasma-workspace/env
  echo 'export QT_IM_MODULE=fcitx' > ~/.config/plasma-workspace/env/fcitx.sh
}

usage ()
{
  echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -v|version    Display script version"

}

zsh_only=false

while getopts ":hz" opt
do
  case $opt in
  h|help)
    usage
    exit 0
    ;;
  z|zsh_only)
    zsh_only=true
    ;;
  *)
    echo -e "\n  Option does not exist : $OPTARG\n"
    usage
    exit 1
    ;;
  esac
done
shift $(($OPTIND-1))

ROOT=$PWD

if [ "$(uname -s)" == 'Darwin' ]; then
  brew upgrade
  PKG_INSTALL='brew install'
  FIREFOX_PROFILE='Library/Application\ Support/Firefox/Profiles'
  FONTS_DIR='Library/Fonts'
else
  os_release="$(cat /etc/os-release)"
  FIREFOX_PROFILE='.mozilla/firefox'
  FONTS_DIR='.fonts'
  if [[ "$os_release" =~ "Kylin" ]]; then
    PKG_INSTALL='sudo yum -y install'
  else
    sudo apt -y update
    PKG_INSTALL='sudo apt -y install'
  fi
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

if $zsh_only; then
  install_zsh
  config_zsh
  exit
fi

install_git
config_git
install_vim
config_vim
install_zsh
config_zsh
install_tmux
config_tmux
config_ssh
config_font
config_firefox
config_timezone
config_fcitx
