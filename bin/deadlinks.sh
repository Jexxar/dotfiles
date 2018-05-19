#!/usr/bin/env bash
# Find dead symbolic links.

find . -type l -print | perl -nle '-e || print'
