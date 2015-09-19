#!/usr/bin/env python
# encoding: utf-8

import datetime

def main():
    print 'Início'
    hour = int(raw_input('Hora: '))
    minute = int(raw_input('Minutos: '))
    start = datetime.datetime(year=2015, month=9, day=19, hour=hour, minute=minute)

    print 'Fim'
    hour = int(raw_input('Hora: '))
    minute = int(raw_input('Minutos: '))
    end = datetime.datetime(year=2015, month=9, day=19, hour=hour, minute=minute)
    print end - start

if __name__ == "__main__":
    main()
