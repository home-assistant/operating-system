workflow "Shellcheck" {
  on = "push"
  resolves = ["Buildroot Scripts", "Helper Scripts", "Board Scripts", "OS/sbin Scripts", "OS/libexec Scripts", "OS/rauc Scripts"]
}

action "Init Shellcheck" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "pull koalaman/shellcheck"
}

action "Helper Scripts" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run run -v $(pwd):/mnt koalaman/shellcheck scripts/*.sh"
  needs = ["Init Shellcheck"]
}

action "Buildroot Scripts" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run -v $(pwd):/mnt koalaman/shellcheck buildroot-external/scripts/*.sh"
  needs = ["Init Shellcheck"]
}

action "Board Scripts" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run -v $(pwd):/mnt koalaman/shellcheck buildroot-external/board/**/*.sh"
  needs = ["Init Shellcheck"]
}

action "OS/sbin Scripts" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run -v $(pwd):/mnt koalaman/shellcheck buildroot-external/rootfs-overlay/usr/sbin/*"
  needs = ["Init Shellcheck"]
}

action "OS/libexec Scripts" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run -v $(pwd):/mnt koalaman/shellcheck buildroot-external/rootfs-overlay/usr/libexec/*"
  needs = ["Init Shellcheck"]
}

action "OS/rauc Scripts" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run -v $(pwd):/mnt koalaman/shellcheck buildroot-external/rootfs-overlay/usr/lib/rauc/*"
  needs = ["Init Shellcheck"]
}
