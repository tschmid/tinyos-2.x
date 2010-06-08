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

configuration RF212RF230RadioC
{
	provides 
	{
		interface SplitControl;

#ifndef IEEE154FRAMES_ENABLED
		interface AMSend[am_id_t id];
		interface Receive[am_id_t id];
		interface Receive as Snoop[am_id_t id];
		interface SendNotifier[am_id_t id];

		interface AMPacket;
		interface Packet as PacketForActiveMessage;
#endif

#ifndef TFRAMES_ENABLED
		interface Ieee154Send;
		interface Receive as Ieee154Receive;
		interface SendNotifier as Ieee154Notifier;

		interface Resource as SendResource[uint8_t clint];

		interface Ieee154Packet;
		interface Packet as PacketForIeee154Message;
#endif

		interface PacketAcknowledgements;
		interface LowPowerListening;

#ifdef PACKET_LINK
		interface PacketLink;
#endif

		interface RadioChannel;

		interface PacketField<uint8_t> as PacketLinkQuality;
		interface PacketField<uint8_t> as PacketTransmitPower;
		interface PacketField<uint8_t> as PacketRSSI;

		interface LocalTime<TRadio> as LocalTimeRadio;
		interface PacketTimeStamp<TRadio, uint32_t> as PacketTimeStampRadio;
		interface PacketTimeStamp<TMilli, uint32_t> as PacketTimeStampMilli;
	}
}

implementation
{
	components RF212RF230RadioP as RadioP, RadioAlarmC, RadioSelectC;

#ifdef RADIO_DEBUG
	components AssertC;
#endif

	RadioP.Ieee154PacketLayer -> Ieee154PacketLayerC;
	RadioP.RadioAlarm -> RadioAlarmC.RadioAlarm[unique("RadioAlarm")];
	RadioP.PacketTimeStamp -> TimeStampingLayerC;
	RadioP.RadioSelect -> RadioSelectC;

// -------- Active Message

#ifndef IEEE154FRAMES_ENABLED
	components ActiveMessageLayerC;
	ActiveMessageLayerC.Config -> RadioP;
	ActiveMessageLayerC.SubSend -> AutoResourceAcquireLayerC;
	ActiveMessageLayerC.SubReceive -> TinyosNetworkLayerC.TinyosReceive;
	ActiveMessageLayerC.SubPacket -> TinyosNetworkLayerC.TinyosPacket;

	AMSend = ActiveMessageLayerC;
	Receive = ActiveMessageLayerC.Receive;
	Snoop = ActiveMessageLayerC.Snoop;
	SendNotifier = ActiveMessageLayerC;
	AMPacket = ActiveMessageLayerC;
	PacketForActiveMessage = ActiveMessageLayerC;
#endif

// -------- Automatic RadioSend Resource

#ifndef IEEE154FRAMES_ENABLED
#ifndef TFRAMES_ENABLED
	components new AutoResourceAcquireLayerC();
	AutoResourceAcquireLayerC.Resource -> SendResourceC.Resource[unique(RADIO_SEND_RESOURCE)];
#else
	components new DummyLayerC() as AutoResourceAcquireLayerC;
#endif
	AutoResourceAcquireLayerC.SubSend -> TinyosNetworkLayerC.TinyosSend;
#endif

// -------- RadioSend Resource

#ifndef TFRAMES_ENABLED
	components new SimpleFcfsArbiterC(RADIO_SEND_RESOURCE) as SendResourceC;
	SendResource = SendResourceC;

// -------- Ieee154 Message

	components Ieee154MessageLayerC;
	Ieee154MessageLayerC.Ieee154PacketLayer -> Ieee154PacketLayerC;
	Ieee154MessageLayerC.Ieee154Packet -> Ieee154PacketLayerC;
	Ieee154MessageLayerC.SubSend -> TinyosNetworkLayerC.Ieee154Send;
	Ieee154MessageLayerC.SubReceive -> TinyosNetworkLayerC.Ieee154Receive;
	Ieee154MessageLayerC.RadioPacket -> TinyosNetworkLayerC.Ieee154Packet;

	Ieee154Send = Ieee154MessageLayerC;
	Ieee154Receive = Ieee154MessageLayerC;
	Ieee154Notifier = Ieee154MessageLayerC;
	Ieee154Packet = Ieee154PacketLayerC;
	PacketForIeee154Message = Ieee154MessageLayerC;
#endif

// -------- Tinyos Network

	components TinyosNetworkLayerC;

	TinyosNetworkLayerC.SubSend -> UniqueLayerC;
	TinyosNetworkLayerC.SubReceive -> LowPowerListeningLayerC;
	TinyosNetworkLayerC.SubPacket -> Ieee154PacketLayerC;

// -------- IEEE 802.15.4 Packet

	components Ieee154PacketLayerC;
	Ieee154PacketLayerC.SubPacket -> LowPowerListeningLayerC;

// -------- UniqueLayer Send part (wired twice)

	components UniqueLayerC;
	UniqueLayerC.Config -> RadioP;
	UniqueLayerC.SubSend -> LowPowerListeningLayerC;

// -------- Low Power Listening 

#ifdef LOW_POWER_LISTENING
	#warning "*** USING LOW POWER LISTENING LAYER"
	components LowPowerListeningLayerC;
	LowPowerListeningLayerC.Config -> RadioP;
	LowPowerListeningLayerC.PacketAcknowledgements -> SoftwareAckLayerC;
#else	
	components LowPowerListeningDummyC as LowPowerListeningLayerC;
#endif
	LowPowerListeningLayerC.SubControl -> MessageBufferLayerC;
	LowPowerListeningLayerC.SubSend -> PacketLinkLayerC;
	LowPowerListeningLayerC.SubReceive -> MessageBufferLayerC;
	LowPowerListeningLayerC.SubPacket -> PacketLinkLayerC;
	SplitControl = LowPowerListeningLayerC;
	LowPowerListening = LowPowerListeningLayerC;

// -------- Packet Link

#ifdef PACKET_LINK
	components PacketLinkLayerC;
	PacketLink = PacketLinkLayerC;
	PacketLinkLayerC.PacketAcknowledgements -> SoftwareAckLayerC;
#else
	components new DummyLayerC() as PacketLinkLayerC;
#endif
	PacketLinkLayerC.SubSend -> MessageBufferLayerC;
	PacketLinkLayerC.SubPacket -> TimeStampingLayerC;

// -------- MessageBuffer

	components MessageBufferLayerC;
	MessageBufferLayerC.RadioSend -> TrafficMonitorLayerC;
	MessageBufferLayerC.RadioReceive -> UniqueLayerC;
	MessageBufferLayerC.RadioState -> TrafficMonitorLayerC;
	MessageBufferLayerC.RadioSelect -> RadioSelectC;
	RadioChannel = MessageBufferLayerC;

// -------- UniqueLayer receive part (wired twice)

	UniqueLayerC.SubReceive -> TrafficMonitorLayerC;

// -------- Traffic Monitor

#ifdef TRAFFIC_MONITOR
	components TrafficMonitorLayerC;
#else
	components new DummyLayerC() as TrafficMonitorLayerC;
#endif
	TrafficMonitorLayerC.Config -> RadioP;
	TrafficMonitorLayerC -> CollisionAvoidanceLayerC.RadioSend;
	TrafficMonitorLayerC -> CollisionAvoidanceLayerC.RadioReceive;
	TrafficMonitorLayerC.SubState -> RadioSelectC;

// -------- CollisionAvoidance

#ifdef SLOTTED_MAC
	components SlottedCollisionLayerC as CollisionAvoidanceLayerC;
#else
	components RandomCollisionLayerC as CollisionAvoidanceLayerC;
#endif
	CollisionAvoidanceLayerC.Config -> RadioP;
	CollisionAvoidanceLayerC.SubSend -> SoftwareAckLayerC;
	CollisionAvoidanceLayerC.SubReceive -> SoftwareAckLayerC;

// -------- SoftwareAcknowledgement

	components SoftwareAckLayerC;
	SoftwareAckLayerC.Config -> RadioP;
	SoftwareAckLayerC.SubSend -> CsmaLayerC;
	SoftwareAckLayerC.SubReceive -> RadioSelectC;
	PacketAcknowledgements = SoftwareAckLayerC;

// -------- Carrier Sense

	components new DummyLayerC() as CsmaLayerC;
	CsmaLayerC.Config -> RadioP;
	CsmaLayerC -> RadioSelectC.RadioSend;
	CsmaLayerC -> RadioSelectC.RadioCCA;

// -------- TimeStamping

	components TimeStampingLayerC;
	TimeStampingLayerC.LocalTimeRadio -> RadioSelectC;
	TimeStampingLayerC.SubPacket -> MetadataFlagsLayerC;
	PacketTimeStampRadio = TimeStampingLayerC;
	PacketTimeStampMilli = TimeStampingLayerC;

// -------- MetadataFlags

	components MetadataFlagsLayerC;
	MetadataFlagsLayerC.SubPacket -> RadioSelectC;

// -------- RF230 Driver

	RadioSelectC.PacketTimeStamp -> TimeStampingLayerC;
	PacketTransmitPower = RadioSelectC.PacketTransmitPower;
	PacketLinkQuality = RadioSelectC.PacketLinkQuality;
	PacketRSSI = RadioSelectC.PacketRSSI;
	LocalTimeRadio = RadioSelectC;
	RadioSelectC.Config -> RadioP;
	
	

}
