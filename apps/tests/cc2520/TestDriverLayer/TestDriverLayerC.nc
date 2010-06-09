/*
 * Copyright (c) 2010, University of Michigan
 * All rights reserved.
 *
 * Author: Thomas Schmid
 */

configuration TestDriverLayerC
{
}

implementation
{
	components MainC, TestDriverLayerM, LedsC;
	components DiagMsgC, SerialActiveMessageC;
	components new TimerMilliC();

	TestDriverLayerM.Boot -> MainC;
	TestDriverLayerM.Leds -> LedsC;
	TestDriverLayerM.DiagMsg -> DiagMsgC;
	TestDriverLayerM.SplitControl -> SerialActiveMessageC;
	TestDriverLayerM.Timer -> TimerMilliC;

    components CC2520DriverLayerC, CC2520ActiveMessageC;

	TestDriverLayerM.RadioState -> CC2520DriverLayerC;
	TestDriverLayerM.AMSend -> CC2520ActiveMessageC;


}
