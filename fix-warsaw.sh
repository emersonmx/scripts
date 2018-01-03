#!/bin/bash

rm -f /usr/local/lib/warsaw/ld-linux-x86-64.so.2
rm -f /usr/local/lib/warsaw/libc.so.6
rm -f /usr/local/lib/warsaw/libpthread.so.0
rm -f /usr/local/lib/warsaw/libdl.so.2
ln -s /usr/lib/ld-linux-x86-64.so.2 /usr/local/lib/warsaw/ld-linux-x86-64.so.2
ln -s /usr/lib/libc.so.6 /usr/local/lib/warsaw/libc.so.6
ln -s /usr/lib/libpthread.so.0 /usr/local/lib/warsaw/libpthread.so.0
ln -s /usr/lib/libdl.so.2 /usr/local/lib/warsaw/libdl.so.2
