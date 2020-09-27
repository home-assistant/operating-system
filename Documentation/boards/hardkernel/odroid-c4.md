# Odroid-C4

## Experimental

Odroid-C4 support is based heavily on the Odroid-C2 and N2 configurations. Given the similarity of the SoCs, as well as the comparable level of support in the Linux kernel, the C4 should hopefully present few surprises. However, Home Assistant support should be regarded as experimental.

Please also refer to the documentation pages for the [Odroid-C2](./odroid-c2.md) and [Odroid-N2](./odroid-n2.md), as some of that information may apply to the C4 as well.

## Known issues

1. Boot hangs in various places
  * `Waiting for root device PARTUUID=48617373-06...`
  * `No soundcards found.`
  * `netconsole: network logging started`
  * these lines appear just after `meson-gx-mmc ffe05000.sd: Got CD GPIO` so maybe related to SD card?
1. Boot from eMMC not working (U-Boot comes up but does not load HassOS)
1. Serial terminal login is not possible due to `rlwrap: error: My terminal reports width=0 (is it emacs?)  I can't handle this, sorry!` and infinite loop

## GPIO

Refer to [the odroid wiki](https://wiki.odroid.com/odroid-c4/hardware/expansion_connectors).
