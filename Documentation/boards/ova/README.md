# Virtual Machine

## Supported Hypervisors

| Hypervisor          | Vendor    | Support         | Config             |
|---------------------|-----------|-----------------|--------------------|
| HyperV              | Microsoft | yes, via VMDK   | [ova](../../../buildroot-external/configs/ova_defconfig)              |
| VirtualBox          | Oracle    | yes, via VMDK   | [ova](../../../buildroot-external/configs/ova_defconfig)              |
| VMware              | VMware    | yes, via VMDK   | [ova](../../../buildroot-external/configs/ova_defconfig)              |

Currently we only publish a VMDK virtual disk due to issues with our previous OVA distribution. We are investigating our options to bring back the OVA distribution, however, the VMDK works for the hypervisors listed above.

## Requirements

Using this VMDK in a virtual machine requires the following:

- Operating system: Other 4.x or later Linux (64-bit)
- Enabled support for UEFI boot
- SATA disk controller
- Minimal of 1GB RAM
- At least 2x vCPU
- An assigned network
