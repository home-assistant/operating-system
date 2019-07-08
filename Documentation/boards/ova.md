# OVA

OVA stands for Open Virtual Appliance. We had to remove the ova files and publish as a vmdk virtual disk,
until we have a better OVF template to generate an OVA. This VMDK work with (you may need to convert the disk):
- HyperV
- VirtualBox
- VMware

## Virtual Machine

You can use this vmdk in a virtual machine with follow requirements:
- OS: Other 4.x or later Linux (64-bit)
- UEFI boot
- min. 1GB RAM
- 2x vcpu
- 1x Network
