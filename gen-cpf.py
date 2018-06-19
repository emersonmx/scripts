#!/usr/bin/env python
# -*- coding: utf-8 -*-

from faker import Factory

def main():
    gen = Factory.create('pt_BR')
    print(gen.cpf())

if __name__ == '__main__':
    main()
