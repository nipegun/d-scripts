#!/bin/bash

vIPLocal=$(hostname -I | sudo 's- --g' 2> /dev/null || ip route get 1 | awk '{print $7; exit}')
echo "$vIPLocal"

