import enum
import os

import attr

from labgrid import target_factory, step
from labgrid.strategy import Strategy, StrategyError


class Status(enum.Enum):
    unknown = 0
    off = 1
    shell = 2


@target_factory.reg_driver
@attr.s(eq=False)
class QEMUShellStrategy(Strategy):
    """Strategy for starting a QEMU VM and running shell commands within it."""

    bindings = {
        "qemu": "QEMUDriver",
        "shell": "ShellDriver",
    }

    status = attr.ib(default=Status.unknown)

    def __attrs_post_init__(self):
        super().__attrs_post_init__()
        if "-accel kvm" in self.qemu.extra_args and os.environ.get("NO_KVM"):
            self.qemu.extra_args = self.qemu.extra_args.replace(
                "-accel kvm", ""
            ).strip()

    @step(args=["status"])
    def transition(self, status, *, step):  # pylint: disable=redefined-outer-name
        if not isinstance(status, Status):
            status = Status[status]
        if status == Status.unknown:
            raise StrategyError(f"can not transition to {status}")
        elif status == self.status:
            step.skip("nothing to do")
            return  # nothing to do
        elif status == Status.off:
            self.target.activate(self.qemu)
            self.qemu.off()
        elif status == Status.shell:
            self.target.activate(self.qemu)
            self.qemu.on()
            self.target.activate(self.shell)
        else:
            raise StrategyError(f"no transition found from {self.status} to {status}")
        self.status = status
