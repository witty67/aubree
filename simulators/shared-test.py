#!/usr/bin/env python

import ctypes

def main():
    my_test_lib = ctypes.cdll.LoadLibrary('/app/simulators/libexample.so')
    

    print "Factorial = %d" % my_test_lib.fact(5)

if __name__ == '__main__':
    main()

