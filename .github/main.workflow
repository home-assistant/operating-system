workflow "Shellcheck" {
  on = "push"
  resolves = ["Buildroot Scripts", "Helper Scripts", "Board Scripts", "OS/sbin Scripts", "OS/libexec Scripts", "OS/rauc Scripts"]
}

action "Helper Scripts" {
  uses = "actions/bin/shellcheck@master"
  args = "scripts/*.sh"
}

action "Buildroot Scripts" {
  uses = "actions/bin/shellcheck@master"
  args = "buildroot-external/scripts/*.sh"
}

action "Board Scripts" {
  uses = "actions/bin/shellcheck@master"
  args = "buildroot-external/board/**/*.sh"
}

action "OS/sbin Scripts" {
  uses = "actions/bin/shellcheck@master"
  args = "buildroot-external/rootfs-overlay/usr/sbin/*"
}

action "OS/libexec Scripts" {
  uses = "actions/bin/shellcheck@master"
  args = "buildroot-external/rootfs-overlay/usr/libexec/*"
}

action "OS/rauc Scripts" {
  uses = "actions/bin/shellcheck@master"
  args = "buildroot-external/rootfs-overlay/usr/lib/rauc/*"
}
