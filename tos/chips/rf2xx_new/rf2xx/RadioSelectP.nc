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

/**
 * Select which radio to use for a given message, and parameterize
 * the Send and Receive interfaces below this point by radio id
 *
 * @author David Moss
 */

module RadioSelectP {
  provides {
    interface RadioSelect;
    interface RadioSend as Send;
    interface RadioReceive as Receive;
    interface RadioState[radio_id_t radioId];
    interface RadioCCA;
  }

  uses {
    interface RadioSend as SubSend[radio_id_t radioId];
    interface RadioReceive as SubReceive[radio_id_t radioId];
    interface RadioState as SubState[radio_id_t radioId];
    interface RadioCCA as SubCCA[radio_id_t radioId];
    interface RadioPacket;
	interface Leds;
  }
}

implementation {
  enum {
    NO_RADIO = 0xFF,
  };
  norace uint8_t default_radio = NO_RADIO;

  //norace uint8_t currentRadio = RF212_RADIO_ID;
  norace uint8_t currentRadio = NO_RADIO;
  
  command void RadioSelect.lock(message_t *msg)
  {
    atomic currentRadio = call RadioSelect.getRadio(msg);
  }
  
  command void RadioSelect.release(){
    atomic currentRadio = NO_RADIO;
  }
  
  message_metadata_t* getMeta(message_t* msg) {
	return ((void*)msg) + sizeof(message_t) - call RadioPacket.metadataLength(msg) - 1;
  }

  command void RadioSelect.setDefaultRadio(uint8_t id) {
	default_radio = id;
  }

  command uint8_t RadioSelect.getDefaultRadio() {
	return default_radio;
  }

  inline bool radioEnabled(radio_id_t id) {
	return (default_radio == NO_RADIO || default_radio == id);
  }
  /***************** RadioSelect Commands ****************/
  /**
   * Select the radio to be used to send this message
   * We don't prevent invalid radios from being selected here; instead,
   * invalid radios are filtered out when they are attempted to be used.
   * 
   * @param msg The message to configure that will be sent in the future
   * @param radioId The radio ID to use when sending this message.
   *    See hardware.h for definitions, the ID is either
   *    RF212_RADIO_ID or RF230_RADIO_ID.
   * @return SUCCESS if the radio ID was set. EINVAL if you have selected
   *    an invalid radio
   */
  async command error_t RadioSelect.selectRadio(message_t *msg, radio_id_t radioId) {
    if(radioId >= uniqueCount(UQ_R534_RADIO)
        || !radioEnabled(radioId)){
            getMeta(msg)->radio = default_radio;
            return FAIL;
        }

    getMeta(msg)->radio = radioId;
    
    return SUCCESS;
  }

  /**
   * Get the radio ID this message will use to transmit when it is sent
   * @param msg The message to extract the radio ID from
   * @return The ID of the radio selected for this message
   */
  async command radio_id_t RadioSelect.getRadio(message_t *msg) {
    return getMeta(msg)->radio;
  }
  
  
  /***************** Send Commands ****************/
  /**
   * By this point, the length should already be set in the message itself.
   *
   * The RadioSelect.selectRadio() command sets the radio id in the message,
   * and that command filters out invalid radio id's.
   *
   * @param msg the message to send
   * @param len IGNORED
   * @return SUCCESS if we're going to try to send the message.
   *     FAIL if you need to reevaluate your code
   */
  task void sendDone() {
	signal Send.sendDone(FAIL);
  }

  tasklet_async command error_t Send.send(message_t* msg){
    radio_id_t id;
    if (default_radio != NO_RADIO)
        call RadioSelect.selectRadio(msg, default_radio);
    id = call RadioSelect.getRadio(msg);
    if(id >= uniqueCount(UQ_R534_RADIO)){
      return EOFF;
    }

    return call SubSend.send[id](msg);
  }

  default tasklet_async command error_t SubSend.send[ radio_id_t id ](message_t* msg){
    return FAIL;
  }

  /***************** SubSend Events ****************/
	tasklet_async event void SubSend.sendDone[radio_id_t id](error_t error){
    signal Send.sendDone(error);
  }

	tasklet_async event void SubSend.ready[radio_id_t id](){
    signal Send.ready();
  }
	
  /***************** SubReceive Events ****************/
  tasklet_async event bool SubReceive.header[radio_id_t id](message_t* msg){
    if (!radioEnabled(id))
            return FALSE;
    call RadioSelect.selectRadio(msg, id);
    return signal Receive.header(msg);
  }

  tasklet_async event message_t* SubReceive.receive[radio_id_t id](message_t* msg){
    if (!radioEnabled(id))
            return msg;
    call RadioSelect.selectRadio(msg, id);
    return signal Receive.receive(msg);
  }

  /***************** RadioState ****************/
	tasklet_async command uint8_t RadioState.getChannel[radio_id_t radioId]()
	{
		return call SubState.getChannel[radioId]();
	}

	tasklet_async command error_t RadioState.setChannel[radio_id_t radioId](uint8_t c)
	{
		return call SubState.setChannel[radioId](c);
	}
	default tasklet_async command error_t SubState.setChannel[radio_id_t radioId](uint8_t c)
	{
		return FAIL;
	}
	
	tasklet_async command error_t RadioState.turnOff[radio_id_t radioId]()
	{
		return call SubState.turnOff[radioId]();
	}
	default tasklet_async command error_t SubState.turnOff[radio_id_t radioId]()
	{
		return FAIL;
	}

	tasklet_async command error_t RadioState.standby[radio_id_t radioId]()
	{
		return call SubState.standby[radioId]();
	}

	tasklet_async command error_t RadioState.turnOn[radio_id_t radioId]()
	{
	    return call SubState.turnOn[radioId]();
	}
	
	tasklet_async event void SubState.done[radio_id_t id]()
  {
    
    signal RadioState.done[id]();
  }

  default tasklet_async command error_t SubState.turnOn[ radio_id_t id ](){
    return FAIL;
  }

  /***************** RadioCCA ****************/
	tasklet_async command error_t RadioCCA.request()
	{
		return call SubCCA.request[currentRadio]();
	}

  default tasklet_async event void RadioCCA.done(error_t error) { }

	tasklet_async event void SubCCA.done[radio_id_t id](error_t error)
  {
    signal RadioCCA.done(error);
  }
  
}

