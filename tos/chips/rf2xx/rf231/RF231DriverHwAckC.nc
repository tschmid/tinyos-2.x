/*
* Copyright (c) 2009, University of Szeged
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*
* - Redistributions of source code must retain the above copyright
* notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above
* copyright notice, this list of conditions and the following
* disclaimer in the documentation and/or other materials provided
* with the distribution.
* - Neither the name of University of Szeged nor the names of its
* contributors may be used to endorse or promote products derived
* from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
* COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*
* Author: Miklos Maroti
*/

#include <RadioConfig.h>
#include <RF231DriverLayer.h>

configuration RF231DriverHwAckC
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

		interface PacketAcknowledgements;
	}

	uses
	{
		interface RF231DriverConfig as Config;
		interface PacketTimeStamp<TRadio, uint32_t>;
		interface Ieee154PacketLayer;
	}
}

implementation
{
	components RF231DriverHwAckP, HplRF231C, BusyWaitMicroC, TaskletC, MainC, RadioAlarmC;

	RadioState = RF231DriverHwAckP;
	RadioSend = RF231DriverHwAckP;
	RadioReceive = RF231DriverHwAckP;
	RadioCCA = RF231DriverHwAckP;
	RadioPacket = RF231DriverHwAckP;

	LocalTimeRadio = HplRF231C;

	Config = RF231DriverHwAckP;

	PacketTransmitPower = RF231DriverHwAckP.PacketTransmitPower;
	components new MetadataFlagC() as TransmitPowerFlagC;
	RF231DriverHwAckP.TransmitPowerFlag -> TransmitPowerFlagC;

	PacketRSSI = RF231DriverHwAckP.PacketRSSI;
	components new MetadataFlagC() as RSSIFlagC;
	RF231DriverHwAckP.RSSIFlag -> RSSIFlagC;

	PacketTimeSyncOffset = RF231DriverHwAckP.PacketTimeSyncOffset;
	components new MetadataFlagC() as TimeSyncFlagC;
	RF231DriverHwAckP.TimeSyncFlag -> TimeSyncFlagC;

	PacketLinkQuality = RF231DriverHwAckP.PacketLinkQuality;
	PacketTimeStamp = RF231DriverHwAckP.PacketTimeStamp;

	RF231DriverHwAckP.LocalTime -> HplRF231C;

	RF231DriverHwAckP.RadioAlarm -> RadioAlarmC.RadioAlarm[unique("RadioAlarm")];
	RadioAlarmC.Alarm -> HplRF231C.Alarm;

	RF231DriverHwAckP.SELN -> HplRF231C.SELN;
	RF231DriverHwAckP.SpiResource -> HplRF231C.SpiResource;
	RF231DriverHwAckP.FastSpiByte -> HplRF231C;

	RF231DriverHwAckP.SLP_TR -> HplRF231C.SLP_TR;
	RF231DriverHwAckP.RSTN -> HplRF231C.RSTN;

	RF231DriverHwAckP.IRQ -> HplRF231C.IRQ;
	RF231DriverHwAckP.Tasklet -> TaskletC;
	RF231DriverHwAckP.BusyWait -> BusyWaitMicroC;

#ifdef RADIO_DEBUG
	components DiagMsgC;
	RF231DriverHwAckP.DiagMsg -> DiagMsgC;
#endif

	MainC.SoftwareInit -> RF231DriverHwAckP.SoftwareInit;

	components RealMainP;
	RealMainP.PlatformInit -> RF231DriverHwAckP.PlatformInit;

	components new MetadataFlagC(), ActiveMessageAddressC;
	RF231DriverHwAckP.AckReceivedFlag -> MetadataFlagC;
	RF231DriverHwAckP.ActiveMessageAddress -> ActiveMessageAddressC;
	PacketAcknowledgements = RF231DriverHwAckP;
	Ieee154PacketLayer = RF231DriverHwAckP;
}
