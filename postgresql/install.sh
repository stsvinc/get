#!/bin/bash
set -e

echo "installing Docker"

postgres_install_dnf(){
  name=$PASSWD
  echo "Hello $name $PASSWD"
  exit;
  #1 First, disable the built-in  **PostgreSQL**  module by running the following  [dnf command](https://www.tecmint.com/dnf-commands-for-fedora-rpm-package-management/).
  sudo dnf -qy module disable postgresql

  #2 Next, enable the official  **PostgreSQL Yum Repository**  as shown.
  sudo dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

  #3 Next, install the  **PostgreSQL 12**  server and client packages.
  sudo dnf -y install postgresql12 postgresql12-server

  #4 Once the installation is complete, initialize the PostgreSQL database,
  # then start the  PostgreSQL-12  service and enable it to automatically start at system boot.
  # Then check if the service is up and running, and is enabled as shown.
  /usr/pgsql-12/bin/postgresql-12-setup initdb
  sudo systemctl start postgresql-12
  sudo systemctl enable postgresql-12
  #systemctl status postgresql-12
  sudo systemctl is-enabled postgresql-12
}

postgres_install_apt(){
  # 1. Update package lists
  sudo apt-get update
  echo "not supported the apt repo type yet"
  exit;
}


if [[ $(command -v systemctl) ]]; then

  if [[ $(command -v dnf) ]]; then
    echo "Repository type: DNF"
    OS_ID=$(grep ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')
    if [[ -n $OS_ID ]]; then
      echo "OS ID: $OS_ID"
      postgres_install_dnf
    fi
  elif [[ $(command -v apt) ]]; then
    echo "Repository type: APT"
    OS_ID=$(grep ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')
    if [[ -n $OS_ID ]]; then
      echo "OS ID: $OS_ID"
      postgres_install_apt
    fi
  elif [[ $(command -v apk) ]]; then
    echo "Repository type: APK"
    OS_ID=$(cat /etc/alpine-release)
    if [[ -n $OS_ID ]]; then
      echo "OS ID: $OS_ID"
      echo "PostgreSQL is not implemented for APK repo manager"
    fi
  else
    echo "Repository type not found."
    exit 1
  fi

else
  echo "Systemctl is not available."
fi






