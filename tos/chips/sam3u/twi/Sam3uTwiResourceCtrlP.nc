#include "sam3utwihardware.h"
module Sam3uTwiResourceCtrlP{
  provides interface Resource[ uint8_t id ];
  //provides interface ResourceConfigure[uint8_t id ];
  uses interface Resource as TwiResource[ uint8_t id ];
  //uses interface HplSam3uTwi as HplTwi;
  //uses interface Sam3uTwiConfigure[ uint8_t id ];
  uses interface Leds;
}
implementation{

  async command error_t Resource.immediateRequest[ uint8_t id ]() {
    return call TwiResource.immediateRequest[ id ]();
  }

  async command error_t Resource.request[ uint8_t id ]() {
    return call TwiResource.request[ id ]();
  }

  async command uint8_t Resource.isOwner[ uint8_t id ]() {
    return call TwiResource.isOwner[ id ]();
  }

  async command error_t Resource.release[ uint8_t id ]() {
    return call TwiResource.release[ id ]();
  }

  event void TwiResource.granted[ uint8_t id ]() {
    signal Resource.granted[ id ]();
  }

  default async command error_t TwiResource.request[ uint8_t id ]() { return FAIL; }
  default async command error_t TwiResource.immediateRequest[ uint8_t id ]() { return FAIL; }
  default async command error_t TwiResource.release[ uint8_t id ]() {return FAIL;}
  default event void Resource.granted[ uint8_t id ]() {}
}