try:
    import RPi.GPIO  # noqa
except RuntimeError as e:
    assert(str(e) == 'This module can only be run on a Raspberry Pi!')
else:
    raise RuntimeError('Import succeeded when it should not have!')
