#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre: você pode redistribuí-lo e/ou
# modificá-lo sob os termos da Licença Pública Geral GNU (GPL)
# conforme publicada pela Free Software Foundation, tanto a versão 3
# da licença, como (a seu critério) qualquer versão posterior.
#
# Este programa é distribuído na esperança de que seja útil,
# mas SEM NENHUMA GARANTIA; nem mesmo a garantia implícita de
# COMERCIABILIDADE ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO.
# Consulte a Licença Pública Geral do GNU para mais detalhes.
#
# Script: Download the "last" version of NVIDIA "source" drivers
#
# Last update: 24/09/2026
#
# https://slackbuilds.org/repository/15.0/system/nvidia-kernel/
# https://slackbuilds.org/repository/15.0/system/nvidia-driver/ with COMPAT32="yes"
#
# https://slackbuilds.org/repository/15.0/system/nvidia-legacy580-kernel/
# https://slackbuilds.org/repository/15.0/system/nvidia-legacy580-driver/ with COMPAT32="yes"
#
echo -e "\n# Download source to build nvidia driver #"

versionDl="580.178.04"
echo "Version: \"$versionDl\""

linkDl="https://download.nvidia.com/XFree86"
#linkDl="https://us.download.nvidia.com/XFree86"

download_x86_64=("$linkDl/Linux-x86_64/$versionDl/NVIDIA-Linux-x86_64-$versionDl.run"
"$linkDl/nvidia-installer/nvidia-installer-$versionDl.tar.bz2"
"$linkDl/nvidia-modprobe/nvidia-modprobe-$versionDl.tar.bz2"
"$linkDl/nvidia-persistenced/nvidia-persistenced-$versionDl.tar.bz2"
"$linkDl/nvidia-settings/nvidia-settings-$versionDl.tar.bz2"
"$linkDl/nvidia-xconfig/nvidia-xconfig-$versionDl.tar.bz2")

md5sum_x86_64=("27a27276ca0bfad7881d635cb3388849"
"00b414bf3b930a8de674796983e2107f"
"48dfe3df153d9437195f3ed2754c30d0"
"bb592f2e8a7c4d28bde08dffb9908353"
"dae6e63e1aedd8683339677680513476"
"2c606deb3c09f0aab3267d559888147c"
"7bf74ea1d07730bb560e390351dc0fdf")

#legacy='' # Default
legacy="-legacy580" # Legacy version

mkdir -p "source_$versionDl/nvidia${legacy}-driver/nvidia${legacy}-kernel"
cd "source_$versionDl/nvidia${legacy}-driver/" || exit

checksum(){
    sum=$(md5sum "$1" | cut -d ' ' -f1)

    if [ "$sum" != "$2" ]; then
        echo -e "\n\tWARNING: checksum failed: $1\n"
        sleep 3
    else
        echo "md5sum $1: Ok"
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
ln -s "$PWD"/NVIDIA-Linux-x86_64-$versionDl.run nvidia${legacy}-kernel/

echo -e "\nDone!\n"
