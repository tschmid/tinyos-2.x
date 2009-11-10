target remote :3333
mon halt
load
mon soft_reset_halt

define mpu
	echo MPU status reg:\n
	x 0xe000ed28
	echo (MPU: 7: mmarvalid, 4: mstkerr, 3: munstkerr, 1: daccviol, 0: iaccviol)\n
	echo (BF: 7: bfarvalid, 4: stkerr, 3: unstkerr, 2: impreciserr, 1: preciserr, 0: ibuserr)\n
	echo MPU address reg:\n
	x 0xe000ed34
	echo BF address reg:\n
	x 0xe000ed38
	echo Stack pointer:\n
	print $sp
	echo Stack:\n
	x/30w $sp
	echo (if iaccviol, then the 9th word is the offending instruction (3rd row, 1st column).)\n
end
