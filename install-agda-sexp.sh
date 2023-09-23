# install zlib and
set -e

apt-get -y install zlib1g-dev libncurses5-dev

# install ghc
apt-get -y update && apt-get -y install ghc ghc-prof ghc-doc

# install cabal and agda dependecies
apt -y install cabal-install
cabal update
cabal install cabal-install
cabal install alex
cabal install happy

# install emacs
#apt-get install guix
#guix package -i emacs
#GUIX_PROFILE="/home/fmwsl/.guix-profile"
#     . "$GUIX_PROFILE/etc/profile"

export PATH=~/.cabal/bin:$PATH
sudo apt-get install libicu-dev
sudo apt-get install -y pkg-config

#--how to download agda/master-sexp??
#cabal install -f enable-cluster-counting



#--python requirements
#sudo apt install python3-pip
#pip install numpy tqdm py2neo