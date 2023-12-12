#!/bin/bash
Progname="6320"

while true
do
  timestamp=$(date +%T)
  mem=$(pslist -m -nobanner $Progname | grep $Progname)
  echo $timestamp,$mem
  sleep 10
done
