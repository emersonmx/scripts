#! /usr/bin/env python

import os
import sys

if __name__ == "__main__":
    if len(sys.argv) == 3:
        current_dir = os.path.join(os.curdir)
        last_dir = None
        file_exists = False

        running = True
        while running:
            full_path = os.path.abspath(os.path.join(current_dir, sys.argv[2]))
            file_exists = os.path.exists(full_path)
            last_dir = os.path.abspath(current_dir)
            current_dir = os.path.join(current_dir, os.pardir)

            if last_dir == os.path.abspath(current_dir):
                running = False
            else:
                if file_exists:
                    print full_path
                    sys.exit(0)

    else:
        print "Usage: {} <path> <file>".format(sys.argv[0])
        sys.exit(1)
