#!/bin/bash
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser útil,
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
#
# Veja a Licença Pública Geral GNU para mais detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Descrição: Script to download the "last" version of NVIDIA drivers "source"
#
# Last update: 04/08/2022
#
#https://slackbuilds.org/repository/15.0/system/nvidia-kernel/
#https://slackbuilds.org/repository/15.0/system/nvidia-driver/

echo -e "\nDownload source to build nvidia driver\n"

versionDl="515.57"
linkDl="https://download.nvidia.com/XFree86"

download_x86_64=("$linkDl/Linux-x86_64/$versionDl/NVIDIA-Linux-x86_64-$versionDl.run"
"$linkDl/nvidia-installer/nvidia-installer-$versionDl.tar.bz2"
"$linkDl/nvidia-modprobe/nvidia-modprobe-$versionDl.tar.bz2"
"$linkDl/nvidia-persistenced/nvidia-persistenced-$versionDl.tar.bz2"
"$linkDl/nvidia-settings/nvidia-settings-$versionDl.tar.bz2"
"$linkDl/nvidia-xconfig/nvidia-xconfig-$versionDl.tar.bz2")

md5sum_x86_64=("784e4b8b84d62b0342d4106cb4cb4de5"
"61964546300ffd588f83d59064ef7f78"
"a02b777d215533947f5358aaa261d42d"
"0f07ed6ed0266e6d86de6cf9248d69f7"
"ac90f728c33bfd4183c5974c5610e1d1"
"2c48eaa1de7f4e2e4de95f67fc7d9351")

mkdir -p "source $versionDl/nvidia-driver/nvidia-kernel"
cd "source $versionDl/nvidia-driver/"

checksum(){
    sum=$(md5sum $1 | cut -d ' ' -f1)

    if [ "$sum" != "$2" ]; then
        echo -e "\nWARNING: checksum failed: $1\n"
        sleep 3
    else
        echo -e "md5sum $1: Ok"
    fi
}

len=${#download_x86_64[@]}
for (( i=0; i < $len; i++ )); do
    echo -e "\nwget -c ${download_x86_64[$i]}"
    wget -qc ${download_x86_64[$i]}

    checksum $(basename ${download_x86_64[$i]}) ${md5sum_x86_64[$i]}
done
