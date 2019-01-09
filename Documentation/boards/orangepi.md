# Raspberry PI

Supported Hardware:

| Device | Board | 
|--------|-----------|
| Orange Pi Prime | opi-prime |

## Serial console

The serial port on the Orange Pi Prime is a 3 pin header located between the
power and reset buttons. The pins are labelled away from the board edge. Flow
control must be disabled in order to send data. The serial specs are 3.3V TTL,
115200,8,n,1

## I2C

Add `dtparam=i2c0=on` to `cmdline.txt`

[config]: ../configuration.md#automatic
