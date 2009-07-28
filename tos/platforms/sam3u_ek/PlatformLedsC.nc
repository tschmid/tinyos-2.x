configuration PlatformLedsC
{
	provides
	{
		interface GeneralIO as Led0;
		interface GeneralIO as Led1;
		interface GeneralIO as Led2;
	}
	uses
	{
		interface Init;
	}
}
implementation
{
	components HplSam3uGeneralIOC as IO;
	components PlatformP;

	Init = PlatformP.LedsInit;

	Led0 = IO.PioB0; // Pin B0 = Green LED 1, active low
	Led1 = IO.PioB1; // Pin B1 = Green LED 2, active low
	Led2 = IO.PioB2; // Pin B2 = Red LED, active high
}
