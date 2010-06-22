/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Miklos Maroti
 */

#include <RadioConfig.h>
#include <RF231DriverLayer.h>

configuration RF231DriverLayerC
{
	provides
	{
		interface RadioState;
		interface RadioSend;
		interface RadioReceive;
		interface RadioCCA;
		interface RadioPacket;

		interface PacketField<uint8_t> as PacketTransmitPower;
		interface PacketField<uint8_t> as PacketRSSI;
		interface PacketField<uint8_t> as PacketTimeSyncOffset;
		interface PacketField<uint8_t> as PacketLinkQuality;

		interface LocalTime<TRadio> as LocalTimeRadio;
	}

	uses
	{
		interface RF231DriverConfig as Config;
		interface PacketTimeStamp<TRadio, uint32_t>;
	}
}

implementation
{
	components RF231DriverLayerP, HplRF231C, BusyWaitMicroC, TaskletC, MainC, RadioAlarmC;

	RadioState = RF231DriverLayerP;
	RadioSend = RF231DriverLayerP;
	RadioReceive = RF231DriverLayerP;
	RadioCCA = RF231DriverLayerP;
	RadioPacket = RF231DriverLayerP;

	LocalTimeRadio = HplRF231C;

	Config = RF231DriverLayerP;

	PacketTransmitPower = RF231DriverLayerP.PacketTransmitPower;
	components new MetadataFlagC() as TransmitPowerFlagC;
	RF231DriverLayerP.TransmitPowerFlag -> TransmitPowerFlagC;

	PacketRSSI = RF231DriverLayerP.PacketRSSI;
	components new MetadataFlagC() as RSSIFlagC;
	RF231DriverLayerP.RSSIFlag -> RSSIFlagC;

	PacketTimeSyncOffset = RF231DriverLayerP.PacketTimeSyncOffset;
	components new MetadataFlagC() as TimeSyncFlagC;
	RF231DriverLayerP.TimeSyncFlag -> TimeSyncFlagC;

	PacketLinkQuality = RF231DriverLayerP.PacketLinkQuality;
	PacketTimeStamp = RF231DriverLayerP.PacketTimeStamp;

	RF231DriverLayerP.LocalTime -> HplRF231C;

	RF231DriverLayerP.RadioAlarm -> RadioAlarmC.RadioAlarm[unique("RadioAlarm")];
	RadioAlarmC.Alarm -> HplRF231C.Alarm;

	RF231DriverLayerP.SELN -> HplRF231C.SELN;
	RF231DriverLayerP.SpiResource -> HplRF231C.SpiResource;
	RF231DriverLayerP.FastSpiByte -> HplRF231C;

	RF231DriverLayerP.SLP_TR -> HplRF231C.SLP_TR;
	RF231DriverLayerP.RSTN -> HplRF231C.RSTN;

	RF231DriverLayerP.IRQ -> HplRF231C.IRQ;
	RF231DriverLayerP.Tasklet -> TaskletC;
	RF231DriverLayerP.BusyWait -> BusyWaitMicroC;

#ifdef RADIO_DEBUG
	components DiagMsgC;
	RF231DriverLayerP.DiagMsg -> DiagMsgC;
#endif

	MainC.SoftwareInit -> RF231DriverLayerP.SoftwareInit;

	components RealMainP;
	RealMainP.PlatformInit -> RF231DriverLayerP.PlatformInit;
}
