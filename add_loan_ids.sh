#!/bin/bash

ls | sed -n 's/\.pdf$//p' | sort -n | paste - "$1" | xargs -L 1 bash -c 'mv "$0"{," $1"}.pdf'
