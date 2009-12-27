#!/usr/bin/perl -w

# ./sam3u-wanja-tests.pl
# ./sam3u-wanja-tests.pl compileonly

use Term::ANSIColor;

my $arg;
if (defined($ARGV[0])) {
	$arg = $ARGV[0];
} else {
	$arg = "";
}

my @apps = (
	{"name" => "apps/tosthreads/apps/Blink", "variant" => "normal", "make" => "make sam3u_ek debugopt threads", "expected" => "LED 1 flashes, LED 2-3 with half the frequency"},
	{"name" => "apps/tosthreads/apps/Blink", "variant" => "protected", "make" => "make sam3u_ek debugopt threads mpu", "expected" => "LED 1 flashes, LED 2-3 with half the frequency"},
	{"name" => "apps/tosthreads/apps/Blink_Preemptive", "variant" => "normal", "make" => "make sam3u_ek debugopt threads", "expected" => "LEDs all light up, then they all go out, repeatedly (out of sync, but that's OK)"},
	{"name" => "apps/tosthreads/apps/Blink_Preemptive", "variant" => "protected", "make" => "make sam3u_ek debugopt threads mpu", "expected" => "LEDs all light up, then they all go out, repeatedly (out of sync, but that's OK)"},
	{"name" => "apps/tosthreads/apps/TestJoin", "variant" => "normal", "make" => "make sam3u_ek debugopt threads", "expected" => "LEDs 1-3 blink, then LEDs 2-3 blink, then LED 3 blinks, repeat"},
	{"name" => "apps/tosthreads/apps/TestJoin", "variant" => "protected", "make" => "make sam3u_ek debugopt threads mpu", "expected" => "LEDs 1-3 blink, then LEDs 2-3 blink, then LED 3 blinks, repeat"},
	{"name" => "apps/tosthreads/apps/TestRestoreTcb", "variant" => "normal", "make" => "make sam3u_ek debugopt threads", "expected" => "LEDs 1-3 all light up"},
	{"name" => "apps/tosthreads/apps/TestRestoreTcb", "variant" => "protected", "make" => "make sam3u_ek debugopt threads mpu", "expected" => "LEDs 1-3 all light up"},
	{"name" => "apps/mpu/TestMpuProtection", "variant" => "normal", "make" => "make sam3u_ek debugopt threads", "expected" => "LED 0 lights up, then LED 1 (green) lights up (meaning successful write to other thread's data)"},
	{"name" => "apps/mpu/TestMpuProtection", "variant" => "protected", "make" => "make sam3u_ek debugopt threads mpu", "expected" => "LED 0 lights up, then LED 2 (red) lights up (meaning the MPU trapped)"},
	{"name" => "apps/mpu/TestMpuProtectionSyscall", "variant" => "normal", "make" => "make sam3u_ek debugopt threads", "expected" => "LED 0 is blinking (meaning it is sending UART packets)"},
	{"name" => "apps/mpu/TestMpuProtectionSyscall", "variant" => "protected", "make" => "make sam3u_ek debugopt threads mpu", "expected" => "LED 0 is blinking (meaning it is sending UART packets)"},
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

	if ($arg ne 'compileonly') {
		print color 'red'; print("(Test $num of $total) Flashing $name, variant $variant.\n"); print color 'reset';
		system("cd \$TOSROOT/$name && sam3u-flash.sh");
		print color 'red'; print("Hit the NRSTB button on the board.\n"); print color 'reset';
		print color 'red'; print("Expected behavior: $expected.\n"); print color 'reset';
	}

	print color 'red'; print("Press Return to continue, CTRL-C to abort.\n"); print color 'reset';
	$input = <STDIN>;
}
