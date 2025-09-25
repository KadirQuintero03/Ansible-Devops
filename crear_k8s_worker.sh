#!/bin/bash
# Script para crear y arrancar la VM k8s-worker en VirtualBox

OUT_ISO="/vm/iso/debian-13.0.0-amd64-netinst-custom.iso"

# Crear VM
VBoxManage createvm --name "k8s-worker" --ostype Debian_64 --basefolder /vm --register

# Configuración básica
VBoxManage modifyvm "k8s-worker" --firmware bios --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm "k8s-worker" --memory 10240 --cpus 5 --audio-driver none --graphicscontroller vmsvga --vram 16

# Disco duro
VBoxManage createhd --filename /vm/k8s-worker/k8s-worker.vdi --size 40000 --variant Standard
VBoxManage storagectl "k8s-worker" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "k8s-worker" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /vm/k8s-worker/k8s-worker.vdi --nonrotational on --hotpluggable on

# Configuración de red y MAC
VBoxManage modifyvm "k8s-worker" --macaddress1 080027923B5C
VBoxManage modifyvm "k8s-worker" --nic1 bridged --bridgeadapter1 enp43s0

# Controladora IDE y montaje ISO
VBoxManage storagectl "k8s-worker" --name "IDE Controller" --add ide
VBoxManage storageattach "k8s-worker" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$OUT_ISO"

# Iniciar VM
VBoxManage startvm "k8s-worker"
