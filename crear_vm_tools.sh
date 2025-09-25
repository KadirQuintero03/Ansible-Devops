#!/bin/bash
# Script para crear y arrancar una VM en VirtualBox

OUT_ISO="/vm/iso/debian-13.0.0-amd64-netinst-custom.iso"

# Crear VM
VBoxManage createvm --name "tools" --ostype Debian_64 --basefolder /vm --register

# Configuración básica
VBoxManage modifyvm "tools" --firmware bios --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm "tools" --memory 6144 --cpus 3 --audio-driver none --graphicscontroller vmsvga --vram 16

# Disco duro
VBoxManage createhd --filename /vm/tools/tools.vdi --size 35000 --variant Standard
VBoxManage storagectl "tools" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "tools" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /vm/tools/tools.vdi --nonrotational on --hotpluggable on

# Configuración avanzada
VBoxManage modifyvm "tools" --macaddress1 0800272762D6
VBoxManage setextradata "tools" "VBoxInternal/Devices/ahci/0/Config/Port0/IsSSD" 1
VBoxManage modifyvm "tools" --nic1 bridged --bridgeadapter1 enp43s0

# Controladora IDE y montaje ISO
VBoxManage storagectl "tools" --name "IDE Controller" --add ide
VBoxManage storageattach "tools" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$OUT_ISO"

# Iniciar VM
VBoxManage startvm "tools"
