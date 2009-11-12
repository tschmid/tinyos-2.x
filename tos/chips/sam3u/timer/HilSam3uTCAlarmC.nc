/* "Copyright (c) 2000-2003 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * HilSam3uTCAlarmC is a generic component that wraps the SAM3U HPL timers and
 * compares into a TinyOS Alarm.
 *
 * @author Thomas Schmid
 * @see  Please refer to TEP 102 for more information about this component and its
 *          intended use.
 */

generic module HilSam3uTCAlarmC(typedef frequency_tag) @safe()
{
  provides 
  {
      interface Init;
      interface Alarm<frequency_tag,uint16_t> as Alarm;
  }
  uses
  {
      interface HplSam3uTCChannel;
      interface HplSam3uTCCompare;
  }
}
implementation
{
  command error_t Init.init()
  {
    call HplSam3uTCCompare.disable();
    return SUCCESS;
  }

  async command void Alarm.start( uint16_t dt )
  {
    call Alarm.startAt( call Alarm.getNow(), dt );
  }

  async command void Alarm.stop()
  {
    call HplSam3uTCCompare.disable();
  }

  async event void HplSam3uTCCompare.fired()
  {
    call HplSam3uTCCompare.disable();
    signal Alarm.fired();
  }

  async command bool Alarm.isRunning()
  {
    return call HplSam3uTCCompare.isEnabled();
  }

  async command void Alarm.startAt( uint16_t t0, uint16_t dt )
  {
    atomic
    {
      uint16_t now = call HplSam3uTCChannel.get();
      uint16_t elapsed = now - t0;
      if( elapsed >= dt )
      {
        call HplSam3uTCCompare.setEventFromNow(2);
      }
      else
      {
        uint16_t remaining = dt - elapsed;
        if( remaining <= 2 )
          call HplSam3uTCCompare.setEventFromNow(2);
        else
          call HplSam3uTCCompare.setEvent( now+remaining );
      }
      call HplSam3uTCCompare.clearPendingEvent();
      call HplSam3uTCCompare.enable();
    }
  }

  async command uint16_t Alarm.getNow()
  {
    return call HplSam3uTCChannel.get();
  }

  async command uint16_t Alarm.getAlarm()
  {
    return call HplSam3uTCCompare.getEvent();
  }

  async event void HplSam3uTCChannel.overflow()
  {
  }
}

