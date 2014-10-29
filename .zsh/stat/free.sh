#!/bin/bash

if which free >/dev/null 2>&1; then
  free
else
  vm_stat
fi
