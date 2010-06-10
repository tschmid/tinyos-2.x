/*
 * Copyright (c) 2010, University of Michigan
 * All rights reserved.
 *
 * Author: Thomas Schmid
 */

#include <Tasklet.h>

module TestDriverLayerM
{
	uses
	{
		interface Leds;
		interface Boot;
		interface DiagMsg;
		interface SplitControl;
		interface Timer<TMilli> as Timer;

		interface RadioState;
		interface AMSend[am_id_t id];
	}
}

implementation
{
	task void serialPowerUp()
	{
		if( call SplitControl.start() != SUCCESS )
			post serialPowerUp();
	}

	event void SplitControl.startDone(error_t error)
	{
		if( error != SUCCESS )
			post serialPowerUp();
		else
        {
			call RadioState.turnOn();
			call Timer.startPeriodic(1000);
        }
	}

	event void SplitControl.stopDone(error_t error)
	{
	}

	event void Boot.booted()
	{
		call Leds.led0On();
		post serialPowerUp();
	}

	message_t testMsg;

	void testStateTransitions(uint8_t seqNo)
	{
		seqNo &= 15;

		if( seqNo == 1 )
			call RadioState.standby();
		else if( seqNo == 2 )
			call RadioState.turnOff();
		else if( seqNo == 3 )
			call RadioState.standby();
		else if( seqNo == 4 )
			call RadioState.turnOn();
		else if( seqNo == 5 )
			call RadioState.turnOff();
		else if( seqNo == 6 )
			call RadioState.turnOn();
		else if( seqNo == 7 )
		{
			*(uint16_t*)(call AMSend.getPayload[111](
                    &testMsg,
			        call AMSend.maxPayloadLength[111]())) = seqNo;
			call AMSend.send[111](0xFFFF, &testMsg, 2);
		}
	}

	void testTransmission(uint8_t seqNo)
	{
		uint8_t seqMod = seqNo & 15;

		if( seqMod == 1 )
			call RadioState.turnOn();
		else if( 2 <= seqMod && seqMod <= 14 )
		{
			*(uint16_t*)(call AMSend.getPayload[111](
                    &testMsg,
                    call AMSend.maxPayloadLength[111]())) = seqNo;
			call AMSend.send[111](0xFFFF, &testMsg, 2);
		}
		else if( seqMod == 15 )
			call RadioState.turnOff();
	}

	tasklet_async event void RadioState.done()
	{
	}

	event void AMSend.sendDone[am_id_t id](message_t* msg, error_t error)
	{
	}

	norace uint8_t payload[3];
	norace uint8_t receiveLength;
	norace uint8_t receiveData[10];
	norace error_t receiveError;

	task void reportReceive()
	{
		if( call DiagMsg.record() )
		{
			call DiagMsg.hex8s(receiveData, receiveLength);
			call DiagMsg.uint8(receiveError);
			call DiagMsg.send();
		}
	}

	uint8_t seqNo;
	event void Timer.fired()
	{
        call Leds.led1Toggle();
		++seqNo;
		if( call DiagMsg.record() )
		{
			call DiagMsg.str("fire");
            call DiagMsg.uint8(seqNo);
			call DiagMsg.send();
		}
		//testStateTransitions(seqNo);
		//testTransmission(seqNo);
	}
}
