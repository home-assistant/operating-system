import pytest


x = 1


@pytest.fixture()
def f1():
    global x
    x = 2
    yield 15
    x = 3


def test_1():
    assert x == 1


def test_2(f1):
    assert x == 2
    assert f1 == 15


def test_3():
    assert x == 3
