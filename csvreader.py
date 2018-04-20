#!/usr/bin/env python
# -*- coding: utf-8 -*-

import csv
import json
import sys

def main():
    if len(sys.argv) < 2:
        print('Usage: {} <csv-file> [columns]'.format(sys.argv[0]))
        sys.exit()

    columns = sys.argv[2:]
    print(columns)
    with open(sys.argv[1], newline='', encoding='latin1') as csvfile:
        dialect = csv.Sniffer().sniff(csvfile.read(1024))
        csvfile.seek(0)
        reader = csv.DictReader(csvfile, dialect=dialect)
        for row in reader:
            if columns:
                print(','.join([ row[k] for k in columns ]))
            else:
                print(','.join(row.values()))

if __name__ == '__main__':
    main()
