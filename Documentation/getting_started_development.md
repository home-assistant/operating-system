# Getting started with HassOS development using Docker on GNU/Linux

First, install `docker-ce` for your distribution. I'd advise to use your distro's provided packages, since that will make sure permissions et al. are sanely set up for what you are about to run. You're also expected to have your current user properly set up in in your sudoers policy, so that this account may elevate to root and execute arbitrary commands as UID 0 (this is required, since at some point during the build process, a new loopback device-backed filesystem image will be mounted inside a Docker container - which requires a "privileged" container to run, which can only be done as root).

Next, make sure the Docker daemon is running:

```bash
$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: https://docs.docker.com
```

My desktop distro doesn't start newly installed services by default, which means I'll have to manually fire up the `docker` service:

```bash
$ sudo systemctl start docker
$ sudo systemctl --no-pager status docker -n0
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2018-10-10 21:08:23 CEST; 25s ago
     Docs: https://docs.docker.com
 Main PID: 1531 (dockerd)
    Tasks: 27 (limit: 4915)
   Memory: 163.4M
   CGroup: /system.slice/docker.service
           ├─1531 /usr/bin/dockerd -H fd://
           └─1539 docker-containerd --config /var/run/docker/containerd/containerd.toml
```

Now, change your working directory to your home-assistant/operating-system repository checkout (please adapt path names as needed), make sure your intended changes to the source tree are applied (and committed, ideally :)), and execute the `enter.sh` helper script:

```bash
$ cd ~/codebase/operating-system/
$ sudo scripts/enter.sh
Sending build context to Docker daemon  30.48MB
Step 1/6 : FROM ubuntu:18.04
[...]
 ---> 4dc25a21556b
Successfully built 4dc25a21556b
Successfully tagged hassbuildroot:latest
```

Note that the current iteration of `enter.sh` will try to load the **overlayfs** kernel module, which is not strictly required for Docker's operation, as far as I can tell. It's OK if loading that module fails; the shell script will continue executing. If everything works out, you will find yourself in an interactive login shell inside your Docker container/build environment, where you can peek around:

```bash
root@somehashinhex:/build#
root@somehashinhex:/build# make help
[...]
```

The HassOS developers provide a `Makefile` that will build HassOS images for a list of targets. For example run the command below to start building the _ova_ variant, and go make a cup of tea. Or fifteen.

```bash
root@0db6f7079872:/build# make ova
[...]
```

That will result in a single VMDK image file at the very end of the build process. This image file is a compressed block device dump with a proper GPT partition table, prepared to ship into any OVA-compatible hypervisor's innards. For me, the end of the **ova** build steps looks like this:

```bash
[...]
2097152+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 12.2145 s, 87.9 MB/s
make: Leaving directory '/build/buildroot'
make: Entering directory '/build/buildroot'
rm -rf /build/buildroot/output/target /build/buildroot/output/images /build/buildroot/output/host  \
	/build/buildroot/output/build /build/buildroot/output/staging \
	/build/buildroot/output/legal-info /build/buildroot/output/graphs
make: Leaving directory '/build/buildroot'
```

The artifacts you just built are placed in the `target/` subdirectory:

```bash
root@fd292c061896:/build# ls -lh release/
total 141M
-rw-r--r-- 1 root root 141M Oct 10 20:22 hassos_ova-2.2.vmdk.gz
```

In order to be able to use this image file with the QEMU hypervisor, you'll need to unpack it, and convert it to an image format that QEMU can work with. Conveniently, the HassOS buildenv already provides all the tools we need for this conversion:

```bash
root@fd292c061896:/build# gunzip release/hassos_ova-2.2.qcow2.gz
root@fd292c061896:/build# ls -lh release/
total 673M
-rw-r--r-- 1 root root 337M Oct 10 20:25 hassos_ova-2.2.qcow2
```

Now, exit the docker container's environment, and find the build artifacts in the `releases/` directory beneath your repository checkout dir. (The generated files will be owned by _root_; make sure to `chown` them to your user account, if needed.)

From there, QEMU can try to boot it. Since the generated image assumes UEFI support in the host/hypervisor, this is slightly more tricky than with "classic"(/legacy) MBR-based images. On the *Debian* host I use to run my QEMU virtual machine on, you'll need to install the **ovmf** package which provides the "UEFI firmware for 64-bit x86 virtual machines". That package will install a **TianoCore**-derived QEMU UEFI image build at `/usr/share/OVMF/OVMF_CODE.fd`, which we'll use with QEMU to boot the generated qcow2 image. (Please adapt path names as necessary, for example if you have installed the ovmf firmware image at another location.)

```bash
$ /usr/bin/qemu-system-x86_64 -enable-kvm -name hassos_ova -smp 2 -m 1024 -drive file=release/hassos_ova-2.2.qcow2,index=0,media=disk,if=ide,cache=none,format=qcow2 -drive file=/usr/share/ovmf/x64/OVMF_CODE.fd,if=pflash,format=raw,readonly=on
```

This should pop up QEMU's SDL frontend, displaying _hassos_' VT/CLI environment. Specifying additional options and flags to QEMU for network access, keyboard layout et al. are left as an exercise for the reader.

After the boot process has finished, you can log in to _hassos_ without a password, providing *root* as the username. From there, executing `login` on the *ha>* shell prompt will yield a root shell in the host OS.
