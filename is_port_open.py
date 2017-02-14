# Taken from https://gist.github.com/betrcode/0248f0fda894013382d7
import socket
import sys


def is_open(ip, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(5)
    try:
        s.connect((ip, int(port)))
        s.shutdown(2)
        return True
    except Exception as e:
        print(e)
        return False


if __name__ == '__main__':
    print(is_open('172.29.21.98', sys.argv[1]))
