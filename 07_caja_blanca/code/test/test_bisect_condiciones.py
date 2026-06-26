"""Pruebas de Combinación de Condiciones para bisect.py.

Branch Condition Combination Testing / Multiple Condition Coverage.
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from bisect import bisect_left, bisect_right, insort_left, insort_right

import pytest

# =========================================================
# BISECT_RIGHT - Combinación de Condiciones
# =========================================================


def test_cc_right_lo_negativo():
    """CC-01: lo < 0 es VERDADERO → lanza ValueError"""
    with pytest.raises(ValueError, match="lo must be non-negative"):
        bisect_right([1, 2, 3], 2, lo=-1)


def test_cc_right_lo_positivo():
    """CC-02: lo < 0 es FALSO → continúa ejecución"""
    assert bisect_right([1, 2, 3], 2, lo=0) == 2


def test_cc_right_hi_none_verdadero():
    """CC-03: hi is None es VERDADERO → establece hi = len(a)"""
    assert bisect_right([10, 20, 30], 25) == 2


def test_cc_right_hi_none_falso():
    """CC-04: hi is None es FALSO → mantiene hi dado (acota la búsqueda)"""
    assert bisect_right([10, 20, 30], 40, hi=2) == 2


def test_cc_right_key_none_verdadero():
    """CC-05: key is None es VERDADERO → ejecuta bucle sin key"""
    assert bisect_right([1, 3, 5, 7], 4) == 2


def test_cc_right_key_none_falso():
    """CC-06: key is None es FALSO → ejecuta bucle con key"""
    assert bisect_right(["a", "c", "e"], "d", key=lambda x: x) == 2


def test_cc_right_while_true():
    """CC-07: while lo < hi es VERDADERO → entra al bucle"""
    assert bisect_right([1, 2, 3, 4, 5], 3) == 3


def test_cc_right_while_false():
    """CC-08: while lo < hi es FALSO → no entra al bucle"""
    assert bisect_right([1, 2, 3], 2, lo=2, hi=2) == 2


def test_cc_right_x_less_than_mid():
    """CC-09: x < a[mid] es VERDADERO → establece hi = mid"""
    assert bisect_right([1, 2, 3], 1) == 1


def test_cc_right_x_not_less_than_mid():
    """CC-10: x < a[mid] es FALSO → establece lo = mid + 1"""
    assert bisect_right([1, 2, 3], 3) == 3


# =========================================================
# BISECT_LEFT - Combinación de Condiciones
# =========================================================


def test_cc_left_lo_negativo():
    """CC-11: lo < 0 es VERDADERO → lanza ValueError"""
    with pytest.raises(ValueError, match="lo must be non-negative"):
        bisect_left([1, 2, 3], 2, lo=-1)


def test_cc_left_lo_positivo():
    """CC-12: lo < 0 es FALSO → continúa ejecución"""
    assert bisect_left([1, 2, 3], 2, lo=0) == 1


def test_cc_left_hi_none_verdadero():
    """CC-13: hi is None es VERDADERO → establece hi = len(a)"""
    assert bisect_left([10, 20, 30], 20) == 1


def test_cc_left_hi_none_falso():
    """CC-14: hi is None es FALSO → mantiene hi dado (acota la búsqueda)"""
    assert bisect_left([10, 20, 30], 40, hi=2) == 2


def test_cc_left_key_none_verdadero():
    """CC-15: key is None es VERDADERO → ejecuta bucle sin key"""
    assert bisect_left([1, 3, 5, 7], 4) == 2


def test_cc_left_key_none_falso():
    """CC-16: key is None es FALSO → ejecuta bucle con key"""
    assert bisect_left(["a", "c", "e"], "d", key=lambda x: x) == 2


def test_cc_left_while_true():
    """CC-17: while lo < hi es VERDADERO → entra al bucle"""
    assert bisect_left([1, 2, 3, 4, 5], 3) == 2


def test_cc_left_while_false():
    """CC-18: while lo < hi es FALSO → no entra al bucle"""
    assert bisect_left([1, 2, 3], 2, lo=2, hi=2) == 2


def test_cc_left_a_mid_less_than_x():
    """CC-19: a[mid] < x es VERDADERO → establece lo = mid + 1"""
    assert bisect_left([1, 2, 3], 3) == 2


def test_cc_left_a_mid_not_less_than_x():
    """CC-20: a[mid] < x es FALSO → establece hi = mid"""
    assert bisect_left([1, 2, 3], 1) == 0


# =========================================================
# INSORT - Combinación de Condiciones
# =========================================================


def test_insort_right_key_none():
    """insort_right con key=None → ejecuta rama izquierda e inserta en duplicados"""
    a = [10, 20, 20, 30]
    insort_right(a, 20)
    assert a == [10, 20, 20, 20, 30]


def test_insort_right_key_func():
    """insort_right con key_func → ejecuta rama derecha con transformación"""
    a = ["a", "c", "e"]
    insort_right(a, "d", key=lambda x: ord(x))
    assert a == ["a", "c", "d", "e"]


def test_insort_left_key_none():
    """insort_left con key=None → ejecuta rama izquierda e inserta antes de duplicados"""
    a = [10, 20, 20, 30]
    insort_left(a, 20)
    assert a == [10, 20, 20, 20, 30]


def test_insort_left_key_func():
    """insort_left con key_func → ejecuta rama derecha con transformación"""
    a = ["a", "c", "e"]
    insort_left(a, "d", key=lambda x: ord(x))
    assert a == ["a", "c", "d", "e"]
