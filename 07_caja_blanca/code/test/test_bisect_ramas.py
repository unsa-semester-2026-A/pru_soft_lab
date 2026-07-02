"""Pruebas de Cobertura de Ramas (Branch Coverage) para bisect.py."""

import os
import sys
import importlib

# Asegurar que se use el directorio padre para importar bisect
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import pytest
import bisect
importlib.reload(bisect)

from bisect import bisect_left, bisect_right, insort_left, insort_right


# ==============================================================================
# Pruebas para bisect_left
# ==============================================================================

def test_bisect_left_lo_negative():
    """Flujo 1: lo < 0 es True -> Lanza ValueError (Nodos 1 -> 2 -> 15)"""
    with pytest.raises(ValueError, match="lo must be non-negative"):
        bisect_left([1, 2, 3], 2, lo=-1)


def test_bisect_left_flow_key_none():
    """Flujo 2: lo >= 0, hi is None, key is None (Nodos 1 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8 -> 6 -> 7 -> 9 -> 6 -> 15)"""
    # a[mid] < x es True en mid=1 (30 < 40) -> lo = 2
    # a[mid] < x es False en mid=2 (50 < 40 es Falso) -> hi = 2
    assert bisect_left([10, 30, 50], 40, lo=0, hi=None, key=None) == 2


def test_bisect_left_flow_key_present():
    """Flujo 3: lo >= 0, hi is not None, key is not None (Nodos 1 -> 3 -> 5 -> 10 -> 11 -> 12 -> 13 -> 11 -> 12 -> 14 -> 11 -> 15)"""
    # key(a[mid]) < x es True en mid=1 (30 < 40) -> lo = 2
    # key(a[mid]) < x es False en mid=2 (50 < 40 es Falso) -> hi = 2
    assert bisect_left([10, 30, 50], 40, lo=0, hi=3, key=lambda x: x) == 2


# ==============================================================================
# Pruebas para bisect_right
# ==============================================================================

def test_bisect_right_lo_negative():
    """lo < 0 es True -> Lanza ValueError"""
    with pytest.raises(ValueError, match="lo must be non-negative"):
        bisect_right([1, 2, 3], 2, lo=-1)


def test_bisect_right_flow_key_none():
    """lo >= 0, hi is None, key is None"""
    # x < a[mid] es False en mid=1 (not 40 < 30) -> lo = 2
    # x < a[mid] es True en mid=2 (40 < 50) -> hi = 2
    assert bisect_right([10, 30, 50], 40, lo=0, hi=None, key=None) == 2


def test_bisect_right_flow_key_present():
    """lo >= 0, hi is not None, key is not None"""
    # x < key(a[mid]) es False en mid=1 (not 40 < 30) -> lo = 2
    # x < key(a[mid]) es True en mid=2 (40 < 50) -> hi = 2
    assert bisect_right([10, 30, 50], 40, lo=0, hi=3, key=lambda x: x) == 2


# ==============================================================================
# Pruebas para insort_left
# ==============================================================================

def test_insort_left_key_none():
    """insort_left con key=None"""
    a = [10, 20, 30]
    insort_left(a, 25, key=None)
    assert a == [10, 20, 25, 30]


def test_insort_left_key_present():
    """insort_left con key != None"""
    a = [10, 20, 30]
    insort_left(a, 25, key=lambda x: x)
    assert a == [10, 20, 25, 30]


# ==============================================================================
# Pruebas para insort_right
# ==============================================================================

def test_insort_right_key_none():
    """insort_right con key=None"""
    a = [10, 20, 30]
    insort_right(a, 25, key=None)
    assert a == [10, 20, 25, 30]


def test_insort_right_key_present():
    """insort_right con key != None"""
    a = [10, 20, 30]
    insort_right(a, 25, key=lambda x: x)
    assert a == [10, 20, 25, 30]
