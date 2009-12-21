#!/usr/bin/perl -w

use Term::ANSIColor;

my @apps = (
	{"name" => "apps/tosthreads/apps/Blink", "variant" => "normal", "make" => "make sam3u_ek debug threads", "expected" => "LEDs count up modulo 8"},
	{"name" => "apps/tosthreads/apps/Blink", "variant" => "protected", "make" => "make sam3u_ek debug threads mpu", "expected" => "LEDs count up modulo 8"},
	{"name" => "apps/tosthreads/apps/Blink_Preemptive", "variant" => "normal", "make" => "make sam3u_ek debug threads", "expected" => "LEDs all light up, then they all go out, repeatedly (out of sync, but that's OK)"},
	{"name" => "apps/tosthreads/apps/Blink_Preemptive", "variant" => "protected", "make" => "make sam3u_ek debug threads mpu", "expected" => "LEDs all light up, then they all go out, repeatedly (out of sync, but that's OK)"},
	{"name" => "apps/tosthreads/apps/TestJoin", "variant" => "normal", "make" => "make sam3u_ek debug threads", "expected" => "LEDs 1-3 blink, then LEDs 2-3 blink, then LED 3 blinks, repeat"},
	{"name" => "apps/tosthreads/apps/TestJoin", "variant" => "protected", "make" => "make sam3u_ek debug threads mpu", "expected" => "LEDs 1-3 blink, then LEDs 2-3 blink, then LED 3 blinks, repeat"},
	{"name" => "apps/tests/TestRestoreTcb", "variant" => "normal", "make" => "make sam3u_ek debug threads", "expected" => "LEDs 1-3 all light up"},
	{"name" => "apps/tests/TestRestoreTcb", "variant" => "protected", "make" => "make sam3u_ek debug threads mpu", "expected" => "LEDs 1-3 all light up"},
	{"name" => "apps/tests/TestMpuProtection", "variant" => "normal", "make" => "make sam3u_ek debug threads", "expected" => "LED 0 lights up, then LED 1 (green) lights up (meaning successful write to other thread's data)"},
	{"name" => "apps/tests/TestMpuProtection", "variant" => "protected", "make" => "make sam3u_ek debug threads mpu", "expected" => "LED 0 lights up, then LED 2 (red) lights up (meaning the MPU trapped)"},
	{"name" => "apps/tests/TestMpuProtectionSyscall", "variant" => "normal", "make" => "make sam3u_ek debug threads", "expected" => "LED 0 is blinking (meaning it is sending UART packets)"},
	{"name" => "apps/tests/TestMpuProtectionSyscall", "variant" => "protected", "make" => "make sam3u_ek debug threads mpu", "expected" => "LED 0 is blinking (meaning it is sending UART packets)"},
);

my $num = 0;
my $total = scalar(@apps);

foreach my $app (@apps)
{
	my $name = $$app{"name"};
	my $variant = $$app{"variant"};
	my $make = $$app{"make"};
	my $expected = $$app{"expected"};
	my $input;

	$num++;

	print color 'red'; print("(Test $num of $total) Compiling $name, variant $variant.\n"); print color 'reset';
	system("cd \$TOSROOT/$name && $make");
	#print color 'red'; print("Press Return to continue, CTRL-C to abort.\n"); print color 'reset';
	#$input = <STDIN>;

	print color 'red'; print("(Test $num of $total) Flashing $name, variant $variant.\n"); print color 'reset';
	system("cd \$TOSROOT/$name && sam3u-flash.sh");
	print color 'red'; print("Hit the NRSTB button on the board.\n"); print color 'reset';
	print color 'red'; print("Expected behavior: $expected.\n"); print color 'reset';
	print color 'red'; print("Press Return to continue, CTRL-C to abort.\n"); print color 'reset';
	$input = <STDIN>;
}
