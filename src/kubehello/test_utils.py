from .utils import find_hostname


def test_find_hostname():
    """
    Check that the find_hosts returns a host
    """
    host = find_hostname()
    print(host)
    assert host is not None
