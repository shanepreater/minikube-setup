import socket


def find_hostname():
    """
    Find the current hostname to show the pod in use.
    :return str: host name of the underlying vm
    """
    return socket.gethostname()

if __name__  == '__main__':
    print(find_hostname())
