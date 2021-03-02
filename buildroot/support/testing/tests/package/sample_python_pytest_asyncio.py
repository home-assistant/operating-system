import asyncio
import pytest


x = 1


@pytest.fixture()
def f1():
    global x
    x = 2
    yield 15
    x = 3


@pytest.mark.asyncio
async def test_1():
    assert x == 1


@pytest.mark.asyncio
async def test_2(f1):
    assert x == 2
    assert f1 == 15


@pytest.mark.asyncio
async def test_3():
    assert x == 3
    await asyncio.sleep(0.1)
    assert x == 3
