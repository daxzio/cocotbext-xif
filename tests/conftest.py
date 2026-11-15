"""
Pytest configuration and shared fixtures for cocotb tests.

This file is automatically discovered by pytest and provides shared fixtures
and configuration for all tests in the tests/ directory.
"""
import pytest
import os


@pytest.fixture(scope="session")
def test_base_dir():
    """Return the base test directory."""
    return os.path.dirname(os.path.abspath(__file__))


@pytest.fixture(scope="session")
def simulator():
    """
    Get the simulator from environment variable.
    
    Usage:
        def test_my_test(simulator):
            run(..., simulator=simulator)
    """
    return os.getenv("SIM", "icarus")


@pytest.fixture(autouse=True)
def setup_test_environment():
    """
    Automatically run before each test.
    
    Use this for any global test setup needed.
    """
    # Example: Set default environment variables
    # os.environ.setdefault("COCOTB_RESOLVE_X", "ZEROS")
    yield
    # Cleanup after test (if needed)
    pass


