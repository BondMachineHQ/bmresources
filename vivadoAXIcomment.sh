#!/bin/bash

bmModule=`cat aux/outregs.txt`;
IFS=$'\n'; arrIN=($bmModule); unset IFS;
for i in "${arrIN[@]}"; do
	newStr=`echo $i | sed 's/\W//g'`
	size=${#newStr}
	if [[ "$size" == '0' ]]; then
		continue
	fi
	sed -i -e "s/\($newStr\W*<=.*\)/\/\/ \1/" ./ip_repo/bondmachineip_1.0/hdl/bondmachineip_v1_0_S00_AXI.v
	sed -i -e "s/\($newStr\[.*\]\W*<=.*\)/\/\/ \1/" ./ip_repo/bondmachineip_1.0/hdl/bondmachineip_v1_0_S00_AXI.v
done
