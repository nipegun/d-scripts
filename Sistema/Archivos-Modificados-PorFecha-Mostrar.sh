#!/bin/bash

vRuta='/home'

find "$vRuta" -type f -printf "%T@ %p\n" | sort -nr
