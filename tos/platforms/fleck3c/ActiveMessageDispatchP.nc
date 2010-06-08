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

#include "hardware.h"

module ActiveMessageDispatchP
{
	provides
	{
		interface SplitControl;

		interface AMSend[uint8_t id];
		interface Receive[uint8_t id];
		interface Receive as Snoop[uint8_t id];
		interface Packet;
		interface AMPacket;

		interface PacketAcknowledgements;
		interface LowPowerListening;
#ifdef PACKET_LINK
		interface PacketLink;
#endif

		interface PacketTimeStamp<TMicro, uint32_t> as PacketTimeStampMicro;
		interface PacketTimeStamp<TMilli, uint32_t> as PacketTimeStampMilli;
	}
  uses
  {
		interface SplitControl as SplitControl230;
		interface SplitControl as SplitControl212;
		interface AMSend as AMSend230[uint8_t id];
		interface AMSend as AMSend212[uint8_t id];
		interface Receive as Receive230[uint8_t id];
		interface Receive as Receive212[uint8_t id];
		interface Receive as Snoop230[uint8_t id];
		interface Receive as Snoop212[uint8_t id];
		interface Packet as Packet230;
		interface Packet as Packet212;
		interface AMPacket as AMPacket230;
		interface AMPacket as AMPacket212;
		interface PacketAcknowledgements as PacketAcknowledgements230;
		interface PacketAcknowledgements as PacketAcknowledgements212;
		interface LowPowerListening as LowPowerListening230;
		interface LowPowerListening as LowPowerListening212;
		interface PacketTimeStamp<TMicro, uint32_t> as PacketTimeStampMicro230;
		interface PacketTimeStamp<TMicro, uint32_t> as PacketTimeStampMicro212;
		interface PacketTimeStamp<TMilli, uint32_t> as PacketTimeStampMilli230;
		interface PacketTimeStamp<TMilli, uint32_t> as PacketTimeStampMilli212;
#ifdef PACKET_LINK
		interface PacketLink as PacketLink230;
		interface PacketLink as PacketLink212;
#endif

  }
}

implementation
{

#define RF230_RADIO 1
#define RF212_RADIO 2
  message_metadata_t* getMeta(message_t* msg) {
  	return ((void*)msg) + sizeof(message_t) - sizeof(rf2xx_metadata_t) ;
  }

  uint8_t getLinkIdentifier(message_t *msg){
    return getMeta(msg)->link_identifier;
  }

/*----------------- diversity -----------------*/
uint8_t radioType(message_t *msg){

}

/*----------------- SplitControl -----------------*/
  command error_t SplitControl.start(){
    return call SplitControl230.start();
  }
  
  default event void SplitControl.startDone(error_t error){}
  event void SplitControl230.startDone(error_t error){
    if (error != SUCCESS)
      signal SplitControl.startDone(error);
    else
      call SplitControl212.start();
  }

  event void SplitControl212.startDone(error_t error){
    signal SplitControl.startDone(error);
  }

  command error_t SplitControl.stop(){
    return call SplitControl230.stop();
  }
  
  default event void SplitControl.stopDone(error_t error){}
  event void SplitControl230.stopDone(error_t error){
    if (error != SUCCESS)
      signal SplitControl.stopDone(error);
    else
      call SplitControl212.stop();
  }

  event void SplitControl212.stopDone(error_t error){
    signal SplitControl.stopDone(error);
  }
/*----------------- PacketAcknowledgements -----------------*/
  async command error_t PacketAcknowledgements.requestAck( message_t* msg ){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketAcknowledgements230.requestAck(msg);
    else
      return call PacketAcknowledgements212.requestAck(msg);
  }
  async command error_t PacketAcknowledgements.noAck( message_t* msg ){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketAcknowledgements230.noAck(msg);
    else
      return call PacketAcknowledgements212.noAck(msg);
  }
  async command bool PacketAcknowledgements.wasAcked(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketAcknowledgements230.wasAcked(msg);
    else
      return call PacketAcknowledgements212.wasAcked(msg);
  }
/*----------------- LowPowerListening -----------------*/
  command void LowPowerListening.setLocalWakeupInterval(uint16_t intervalMs){
    call LowPowerListening230.setLocalWakeupInterval(intervalMs);
    call LowPowerListening212.setLocalWakeupInterval(intervalMs);
  }
  command uint16_t LowPowerListening.getLocalWakeupInterval(){
    return call LowPowerListening230.getLocalWakeupInterval();
  }
  command void LowPowerListening.setRemoteWakeupInterval(message_t *msg, uint16_t intervalMs){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      call LowPowerListening230.setRemoteWakeupInterval(msg, intervalMs);
    else
      call LowPowerListening212.setRemoteWakeupInterval(msg, intervalMs);
  }
  command uint16_t LowPowerListening.getRemoteWakeupInterval(message_t *msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call LowPowerListening230.getRemoteWakeupInterval(msg);
    else
      return call LowPowerListening212.getRemoteWakeupInterval(msg);
  }
/*----------------- Packet -----------------*/
  command void Packet.clear(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      call Packet230.clear(msg);
    else
      call Packet212.clear(msg);
  }
  command uint8_t Packet.payloadLength(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call Packet230.payloadLength(msg);
    else
      return call Packet212.payloadLength(msg);
  }
  command void Packet.setPayloadLength(message_t* msg, uint8_t len){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      call Packet230.setPayloadLength(msg,len);
    else
      call Packet212.setPayloadLength(msg,len);
  }
  command uint8_t Packet.maxPayloadLength(){
      return call Packet230.maxPayloadLength();
  }
  command void* Packet.getPayload(message_t* msg, uint8_t len){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call Packet230.getPayload(msg,len);
    else
      return call Packet212.getPayload(msg,len);
  }
/*----------------- AMPacket -----------------*/
  command am_addr_t AMPacket.address(){
    return call AMPacket230.address();
  }
  command am_addr_t AMPacket.destination(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMPacket230.destination(msg);
    else
      return call AMPacket212.destination(msg);
  }
  command am_addr_t AMPacket.source(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMPacket230.source(msg);
    else
      return call AMPacket212.source(msg);
  }
  command void AMPacket.setDestination(message_t* msg, am_addr_t addr){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMPacket230.setDestination(msg,addr);
    else
      return call AMPacket212.setDestination(msg,addr);
  }
  command void AMPacket.setSource(message_t* msg, am_addr_t addr){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMPacket230.setSource(msg,addr);
    else
      return call AMPacket212.setSource(msg,addr);
  }
  command bool AMPacket.isForMe(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMPacket230.isForMe(msg);
    else
      return call AMPacket212.isForMe(msg);
  }
  command am_id_t AMPacket.type(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMPacket230.type(msg);
    else
      return call AMPacket212.type(msg);
  }
  command void AMPacket.setType(message_t* msg, am_id_t t){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMPacket230.setType(msg,t);
    else
      return call AMPacket212.setType(msg,t);
  }
  command am_group_t AMPacket.group(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMPacket230.group(msg);
    else
      return call AMPacket212.group(msg);
  }
  command void AMPacket.setGroup(message_t* msg, am_group_t grp){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMPacket230.setGroup(msg,grp);
    else
      return call AMPacket212.setGroup(msg,grp);
  }
  command am_group_t AMPacket.localGroup(){
      return call AMPacket230.localGroup();
  }
/*----------------- PacketTimeStampMicro -----------------*/
  async command bool PacketTimeStampMicro.isValid(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketTimeStampMicro230.isValid(msg);
    else
      return call PacketTimeStampMicro212.isValid(msg);
  }
  async command uint32_t PacketTimeStampMicro.timestamp(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketTimeStampMicro230.timestamp(msg);
    else
      return call PacketTimeStampMicro212.timestamp(msg);
  }
  async command void PacketTimeStampMicro.clear(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketTimeStampMicro230.clear(msg);
    else
      return call PacketTimeStampMicro212.clear(msg);
  }
  async command void PacketTimeStampMicro.set(message_t* msg, uint32_t value){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketTimeStampMicro230.set(msg,value);
    else
      return call PacketTimeStampMicro212.set(msg,value);
  }
/*----------------- PacketTimeStampMilli -----------------*/
  async command bool PacketTimeStampMilli.isValid(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketTimeStampMilli230.isValid(msg);
    else
      return call PacketTimeStampMilli212.isValid(msg);
  }
  async command uint32_t PacketTimeStampMilli.timestamp(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketTimeStampMilli230.timestamp(msg);
    else
      return call PacketTimeStampMilli212.timestamp(msg);
  }
  async command void PacketTimeStampMilli.clear(message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketTimeStampMilli230.clear(msg);
    else
      return call PacketTimeStampMilli212.clear(msg);
  }
  async command void PacketTimeStampMilli.set(message_t* msg, uint32_t value){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketTimeStampMilli230.set(msg,value);
    else
      return call PacketTimeStampMilli212.set(msg,value);
  }
/*----------------- AMSend -----------------*/
  command error_t AMSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMSend230.send[id](addr,msg,len);
    else
      return call AMSend212.send[id](addr,msg,len);
  }
  command error_t AMSend.cancel[am_id_t id](message_t* msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMSend230.cancel[id](msg);
    else
      return call AMSend212.cancel[id](msg);
  }
  default event void AMSend.sendDone[am_id_t id](message_t* msg, error_t error){}
  event void AMSend230.sendDone[am_id_t id](message_t* msg, error_t error){
    signal AMSend.sendDone[id](msg, error);
  }
  event void AMSend212.sendDone[am_id_t id](message_t* msg, error_t error){
    signal AMSend.sendDone[id](msg, error);
  }
  command uint8_t AMSend.maxPayloadLength[am_id_t id](){
      return call AMSend230.maxPayloadLength[id]();
  }
  command void* AMSend.getPayload[am_id_t id](message_t* msg, uint8_t len){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call AMSend230.getPayload[id](msg,len);
    else
      return call AMSend212.getPayload[id](msg,len);
  }
/*----------------- Receive -----------------*/
  default event message_t* Receive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len){}
  event message_t* Receive230.receive[am_id_t id](message_t* msg, void* payload, uint8_t len){
    return signal Receive.receive[id](msg, payload, len);
  }
  event message_t* Receive212.receive[am_id_t id](message_t* msg, void* payload, uint8_t len){
    return signal Receive.receive[id](msg, payload, len);
  }
/*----------------- Snoop -----------------*/
  default event message_t* Snoop.receive[am_id_t id](message_t* msg, void* payload, uint8_t len){}
  event message_t* Snoop230.receive[am_id_t id](message_t* msg, void* payload, uint8_t len){
    return signal Snoop.receive[id](msg, payload, len);
  }
  event message_t* Snoop212.receive[am_id_t id](message_t* msg, void* payload, uint8_t len){
    return signal Snoop.receive[id](msg, payload, len);
  }
#ifdef PACKET_LINK
/*----------------- PacketLink -----------------*/
  command void PacketLink.setRetries(message_t *msg, uint16_t maxRetries){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketLink230.getPayload(msg,maxRetries);
    else
      return call PacketLink212.getPayload(msg,maxRetries);
  }
  command void PacketLink.setRetryDelay(message_t *msg, uint16_t retryDelay){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketLink230.setRetryDelay(msg,retryDelay);
    else
      return call PacketLink212.setRetryDelay(msg,retryDelay);
  }
  command uint16_t PacketLink.getRetries(message_t *msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketLink230.getRetries(msg);
    else
      return call PacketLink212.getRetries(msg);
  }
  command uint16_t PacketLink.getRetryDelay(message_t *msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketLink230.getRetryDelay(msg);
    else
      return call PacketLink212.getRetryDelay(msg);
  }
  command bool PacketLink.wasDelivered(message_t *msg){
    if (getLinkIdentifier(msg) == RF230_RADIO)
      return call PacketLink230.wasDelivered(msg);
    else
      return call PacketLink212.wasDelivered(msg);
  }
#endif

}
