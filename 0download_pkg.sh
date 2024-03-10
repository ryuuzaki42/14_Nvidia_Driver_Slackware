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
# Last update: 10/03/2024
#
#https://slackbuilds.org/repository/15.0/system/nvidia-kernel/
#https://slackbuilds.org/repository/15.0/system/nvidia-driver/
#
echo -e "\n# Download source to build nvidia driver #"

versionDl="550.54.14"
echo "Version: \"$versionDl\""
linkDl="https://download.nvidia.com/XFree86"

download_x86_64=("$linkDl/Linux-x86_64/$versionDl/NVIDIA-Linux-x86_64-$versionDl.run"
"$linkDl/nvidia-installer/nvidia-installer-$versionDl.tar.bz2"
"$linkDl/nvidia-modprobe/nvidia-modprobe-$versionDl.tar.bz2"
"$linkDl/nvidia-persistenced/nvidia-persistenced-$versionDl.tar.bz2"
"$linkDl/nvidia-settings/nvidia-settings-$versionDl.tar.bz2"
"$linkDl/nvidia-xconfig/nvidia-xconfig-$versionDl.tar.bz2")

md5sum_x86_64=("69e77647875bef192f8458912027e44b"
"41d2fa0cc25c12f7766648bc9cab4c52"
"5a78fce16d1a6e06b68ef80a1eded08b"
"4ad75ba0d9db01708c081c6b8a9c477b"
"785e1d61781b780779b5d120285837bb"
"120cbfb926790857e2572a0c0d2087bc")

mkdir -p "source_$versionDl/nvidia-driver/nvidia-kernel"
cd "source_$versionDl/nvidia-driver/" || exit

checksum(){
    sum=$(md5sum "$1" | cut -d ' ' -f1)

    if [ "$sum" != "$2" ]; then
        echo -e "\n\tWARNING: checksum failed: $1\n"
        sleep 3
    else
        echo -e "md5sum $1: Ok"
    fi
}

len=${#download_x86_64[@]}
for (( i=0; i < len; i++)); do
    echo -e "\nwget -c ${download_x86_64[$i]}"
    wget -qc "${download_x86_64[$i]}"

    #echo -e "\n${download_x86_64[$i]} ${md5sum_x86_64[$i]}"
    checksum "$(basename "${download_x86_64[$i]}")" "${md5sum_x86_64[$i]}"
done

# create link
ln -s $PWD/NVIDIA-Linux-x86_64-$versionDl.run nvidia-kernel/

echo -e "\nDone!\n"
