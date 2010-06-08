/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

configuration RadioSelectC {
  provides {
    interface RadioSend;
    interface RadioReceive;
    interface RadioSelect;
    interface RadioState[radio_id_t radioId];
    interface RadioCCA;
    interface RadioPacket;
		
		interface PacketField<uint8_t> as PacketLinkQuality;
		interface PacketField<uint8_t> as PacketTransmitPower;
		interface PacketField<uint8_t> as PacketRSSI;

		interface LocalTime<TRadio> as LocalTimeRadio;
  }
  uses {
		interface PacketTimeStamp<TRadio, uint32_t>;
		interface RF2xxDriverConfig as Config;
  }
}

implementation {

  components RadioSelectP;
  
  RadioSend = RadioSelectP.Send;
  RadioReceive = RadioSelectP.Receive;
  RadioSelect = RadioSelectP;
  RadioState = RadioSelectP;
  RadioCCA = RadioSelectP;

#ifndef USE_RF230_RADIO
#ifndef USE_RF212_RADIO
	#error !!!!!!!!!!!!!!!!!!!!!    no radio defined, aborting     !!!!!!!!!!!!!!!!!!!!!!!
#endif
#endif


#ifdef USE_RF230_RADIO 
  components RF230DriverLayerC;
  RadioPacket = RF230DriverLayerC;
  LocalTimeRadio = RF230DriverLayerC;
  PacketLinkQuality = RF230DriverLayerC.PacketLinkQuality;
  PacketTransmitPower = RF230DriverLayerC.PacketTransmitPower;
  PacketRSSI = RF230DriverLayerC.PacketRSSI;
  Config = RF230DriverLayerC.Config;
  
  PacketTimeStamp = RF230DriverLayerC;
  RadioSelectP.SubSend[RF230_RADIO_ID] -> RF230DriverLayerC;
  RadioSelectP.SubReceive[RF230_RADIO_ID] -> RF230DriverLayerC;
  RadioSelectP.SubCCA[RF230_RADIO_ID] -> RF230DriverLayerC;
  RadioSelectP.SubState[RF230_RADIO_ID] -> RF230DriverLayerC;
#endif

#ifdef USE_RF212_RADIO
  components RF212DriverLayerC;
#ifndef USE_RF230_RADIO
  RadioPacket = RF212DriverLayerC;
  LocalTimeRadio = RF212DriverLayerC;
  PacketLinkQuality = RF212DriverLayerC.PacketLinkQuality;
  PacketTransmitPower = RF212DriverLayerC.PacketTransmitPower;
  PacketRSSI = RF212DriverLayerC.PacketRSSI;
#endif
  Config = RF212DriverLayerC.Config;
  PacketTimeStamp = RF212DriverLayerC;
  RadioSelectP.SubSend[RF212_RADIO_ID] -> RF212DriverLayerC;
  RadioSelectP.SubReceive[RF212_RADIO_ID] -> RF212DriverLayerC;
  RadioSelectP.SubCCA[RF212_RADIO_ID] -> RF212DriverLayerC;
  RadioSelectP.SubState[RF212_RADIO_ID] -> RF212DriverLayerC;
#endif

  components TinyosNetworkLayerC;
#ifndef TFRAMES_ENABLED
  RadioSelectP.RadioPacket -> TinyosNetworkLayerC.Ieee154Packet;
#else
  RadioSelectP.RadioPacket -> TinyosNetworkLayerC.TinyosPacket;
#endif

  components LedsC;
  RadioSelectP.Leds -> LedsC;
}

