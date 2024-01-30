#!/bin/bash

# Read OS information from /etc/os-release
source /etc/os-release

install_for_rhel_family(){
  echo "Updating the operation system"
  yum update -y
  echo "adding epel release repo"
  yum install epel-release -y
  echo "installing basic tools"
  yum install vim curl wget zip unzip htop iftop -y
  echo "installation for x11 frowarding"
  #yum install xorg-x11-xauth xorg-x11-fonts-* xorg-x11-font-utils xorg-x11-fonts-Type1 -y
  yum group install base-x -y
  echo "installing some advanced tools"
  yum install gparted nm-connection-editor firewall-config cloud-utils-growpart xfsprogs trash-cli timeshift -y
  echo "installing welcome message"
  cat <<EOT > /etc/motd
░██████╗██╗░░░██╗███╗░░██╗░█████╗░██████╗░░█████╗░░██████╗░██████╗
██╔════╝╚██╗░██╔╝████╗░██║██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝
╚█████╗░░╚████╔╝░██╔██╗██║██║░░╚═╝██████╔╝██║░░██║╚█████╗░╚█████╗░
░╚═══██╗░░╚██╔╝░░██║╚████║██║░░██╗██╔══██╗██║░░██║░╚═══██╗░╚═══██╗
██████╔╝░░░██║░░░██║░╚███║╚█████╔╝██║░░██║╚█████╔╝██████╔╝██████╔╝
╚═════╝░░░░╚═╝░░░╚═╝░░╚══╝░╚════╝░╚═╝░░╚═╝░╚════╝░╚═════╝░╚═════╝░

Powered by Sincos R&D
EOT
  echo "creating certificate file"
  mkdir $HOME/.ssh
  touch $HOME/.ssh/authorized_keys
  echo "$(tput setaf 2)key file location: $HOME/.ssh/authorized_keys
  $(tput setaf 1)Please insert the public key and then run the post installation scripts
  NB: don't forget to stop the password auth at /etc/ssh/sshd_config file$(tput sgr0)"
}

# Check for Rocky Linux 8 or 9 specifically
if [[ $ROCKY_SUPPORT_PRODUCT = "Rocky-Linux-8" ]]; then
  echo "Installing for Rocky Linux 8"
  install_for_rhel_family
elif [[ $ROCKY_SUPPORT_PRODUCT = "Rocky-Linux-9" ]]; then
  echo "Installing for Rocky Linux 9"
  install_for_rhel_family
elif [[ $ALMALINUX_MANTISBT_PROJECT = "AlmaLinux-8" ]]; then
  echo "Installing for AlmaLinux 8"
  install_for_rhel_family
elif [[ $ALMALINUX_MANTISBT_PROJECT = "AlmaLinux-9" ]]; then
  echo "Installing for AlmaLinux 9"
  install_for_rhel_family
else
  echo "Not Rocky or Alma Linux 8 or 9"
fi
