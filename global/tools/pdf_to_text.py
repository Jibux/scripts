#!/usr/bin/python3


import pdftotext
import sys


def usage():
    print(f'{sys.argv[0]} path_to_pdf')

def exit_usage():
    usage()
    exit(1)

len(sys.argv) == 1 and exit_usage()
doc = sys.argv[1]

with open(doc, "rb") as f:
    pdf = pdftotext.PDF(f)

for page_idx, page in enumerate(pdf):
    page_split = page.splitlines()
    print('############################ PAGE {} ############################'.format(page_idx + 1))
    for line_idx, line in enumerate(page_split):
        print('{}: {}'.format(line_idx + 1, line))
