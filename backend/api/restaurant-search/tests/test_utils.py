import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import pytest

from utils import haversine_meters


def test_haversine_zero_distance():
    assert haversine_meters(0.0, 0.0, 0.0, 0.0) == 0.0


def test_haversine_known_distance():
    # Distance between (0,0) and (0,1) is ~111.32 km -> ~111320 meters
    dist = haversine_meters(0.0, 0.0, 0.0, 1.0)
    assert 111000 < dist < 112000
