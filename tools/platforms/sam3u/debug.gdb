target remote :3333
mon halt
load
mon soft_reset_halt

define st
	echo MPU / bus fault / usage fault status reg:\n
	x 0xe000ed28
	echo (MPU: 7: mmarvalid, 4: mstkerr, 3: munstkerr, 1: daccviol, 0: iaccviol)\n
	echo (BF: 7: bfarvalid, 4: stkerr, 3: unstkerr, 2: impreciserr, 1: preciserr, 0: ibuserr)\n
	echo MPU address reg:\n
	x 0xe000ed34
	echo BF address reg:\n
	x 0xe000ed38
	echo Hard fault status reg:\n
	x 0xe000ed2c
	echo (HF: 31: debugevt, 30: forced, 1: vecttbl)\n
	echo IRQ status reg:\n
	x 0xe000ed04
	echo (21-12: vectpending, 11: rettobase, 9-0: vectactive)\n
	echo Control reg:\n
	mon reg control
	echo (0: privileged, 1: user)\n
	echo Primask reg:\n
	mon reg primask
	echo (0: normal, 1: IRQs disabled except NMI, hard fault)\n
	echo Fault mask reg:\n
	mon reg faultmask
	echo (0: normal, 1: IRQs disabled except NMI)\n
	echo Basepri reg:\n
	mon reg basepri
	echo (0: normal, 9 bits: IRQs disabled w/ prio << value)\n
	echo Stack pointer:\n
	print $sp
	echo Stack:\n
	x/30w $sp
	echo (If iaccviol, then the 9th word is the offending instruction (3rd row, 1st column).)\n
	echo (If iaccviol (w/o optimization), then the 15th word is the offending instruction (4th row, 3rd column).)\n
	echo (In exception handler: 1st word: r0, 2nd: r1, 3rd: r2, 4th: r3, 5th: r12, 6th: lr, 7th: pc, 8th: psr (CM3TR, p. 5-11)\n
end

define th
	echo Current thread:\n
	p *TinyThreadSchedulerP$current_thread
	echo Yielding thread:\n
	p *TinyThreadSchedulerP$yielding_thread
end

define clock
	mon at91sam3 info
end

define res
	mon soft_reset_halt
end

define user
	help user-defined
end
