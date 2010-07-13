/*
 * "Copyright (c) 2004-2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2004-2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 *
 * The Active Message layer on the opal platform. This is a naming wrapper
 * around the multiple radio abstractions on the opal paltform.
 *
 * @author Philip Levis
 * @author Kevin Klues (adapted to opal)
 */
#include "Timer.h"

configuration MultiRadioActiveMessageC {
  provides {
    // Default Radio Interface
    interface SplitControl as DefaultSplitControl;

    interface AMSend as DefaultAMSend[am_id_t id];
    interface Receive as DefaultReceive[am_id_t id];
    interface Receive as DefaultSnoop[am_id_t id];

    interface Packet as DefaultPacket;
    interface AMPacket as DefaultAMPacket;
    interface PacketAcknowledgements as DefaultPacketAcknowledgements;
    interface PacketTimeStamp<TRadio, uint32_t> as DefaultPacketTimeStampRadio;
    interface PacketTimeStamp<TMilli, uint32_t> as DefaultPacketTimeStampMilli;

    // Radio 0 Interface
    interface SplitControl as Radio0SplitControl;

    interface AMSend as Radio0AMSend[am_id_t id];
    interface Receive as Radio0Receive[am_id_t id];
    interface Receive as Radio0Snoop[am_id_t id];

    interface Packet as Radio0Packet;
    interface AMPacket as Radio0AMPacket;
    interface PacketAcknowledgements as Radio0PacketAcknowledgements;
    interface PacketTimeStamp<TRadio, uint32_t> as Radio0PacketTimeStampRadio;
    interface PacketTimeStamp<TMilli, uint32_t> as Radio0PacketTimeStampMilli;
    
    // Radio 1 Interface
    interface SplitControl as Radio1SplitControl;

    interface AMSend as Radio1AMSend[am_id_t id];
    interface Receive as Radio1Receive[am_id_t id];
    interface Receive as Radio1Snoop[am_id_t id];

    interface Packet as Radio1Packet;
    interface AMPacket as Radio1AMPacket;
    interface PacketAcknowledgements as Radio1PacketAcknowledgements;
    interface PacketTimeStamp<TRadio, uint32_t> as Radio1PacketTimeStampRadio;
    interface PacketTimeStamp<TMilli, uint32_t> as Radio1PacketTimeStampMilli;
  }
}
implementation {
  // The radios on this platform
  components RF212ActiveMessageC as Radio0AM;
  components RF231ActiveMessageC as Radio1AM;
  
  // Default Radio
  DefaultSplitControl = Radio0AM.SplitControl;
 
  DefaultAMSend       = Radio0AM.AMSend;
  DefaultReceive      = Radio0AM.Receive;
  DefaultSnoop        = Radio0AM.Snoop;
  DefaultPacket       = Radio0AM.Packet;
  DefaultAMPacket     = Radio0AM.AMPacket;
  DefaultPacketAcknowledgements = Radio0AM.PacketAcknowledgements;

  DefaultPacketTimeStampRadio = Radio0AM.PacketTimeStampRadio;
  DefaultPacketTimeStampMilli = Radio0AM.PacketTimeStampMilli;

  // Radio 0
  Radio0SplitControl = Radio0AM.SplitControl;
 
  Radio0AMSend       = Radio0AM.AMSend;
  Radio0Receive      = Radio0AM.Receive;
  Radio0Snoop        = Radio0AM.Snoop;
  Radio0Packet       = Radio0AM.Packet;
  Radio0AMPacket     = Radio0AM.AMPacket;
  Radio0PacketAcknowledgements = Radio0AM.PacketAcknowledgements;

  Radio0PacketTimeStampRadio = Radio0AM.PacketTimeStampRadio;
  Radio0PacketTimeStampMilli = Radio0AM.PacketTimeStampMilli;
  
  // Radio 1
  Radio1SplitControl = Radio1AM.SplitControl;
 
  Radio1AMSend       = Radio1AM.AMSend;
  Radio1Receive      = Radio1AM.Receive;
  Radio1Snoop        = Radio1AM.Snoop;
  Radio1Packet       = Radio1AM.Packet;
  Radio1AMPacket     = Radio1AM.AMPacket;
  Radio1PacketAcknowledgements = Radio1AM.PacketAcknowledgements;

  Radio1PacketTimeStampRadio = Radio1AM.PacketTimeStampRadio;
  Radio1PacketTimeStampMilli = Radio1AM.PacketTimeStampMilli;
}

