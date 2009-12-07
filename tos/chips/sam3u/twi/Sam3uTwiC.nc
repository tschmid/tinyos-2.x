#include "sam3utwihardware.h"

configuration Sam3uTwiC{
  provides interface Resource;
  provides interface ResourceRequested;
  provides interface I2CPacket<TI2CBasicAddr> as TwiBasicAddr0;
  provides interface I2CPacket<TI2CBasicAddr> as TwiBasicAddr1;
  provides interface ResourceConfigure as Configure0[ uint8_t id ];
  provides interface ResourceConfigure as Configure1[ uint8_t id ];
  uses interface Sam3uTwiConfigure as TwiConfig0;
  uses interface Sam3uTwiConfigure as TwiConfig1;
}
implementation{

  enum {
    CLIENT_ID = unique( SAM3U_TWI_BUS ),
  };

  components Sam3uTwiResourceCtrlC as ResourceCtrl;
  components HplSam3uTwiResourceCtrlC;
  Resource = ResourceCtrl.Resource[ CLIENT_ID ];
  ResourceRequested = HplSam3uTwiResourceCtrlC;
  ResourceCtrl.TwiResource[ CLIENT_ID ] -> HplSam3uTwiResourceCtrlC;
  //ResourceCtrl.ResourceConfigure[ CLIENT_ID ] <- HplSam3uTwiResourceCtrlC.ResourceConfigure;

  components new Sam3uTwiP(0) as TwiP0;
  components new Sam3uTwiP(1) as TwiP1;
  TwiBasicAddr0 = TwiP0.TwiBasicAddr;
  TwiBasicAddr1 = TwiP1.TwiBasicAddr;
  TwiConfig0 = TwiP0.Sam3uTwiConfigure[ CLIENT_ID ];
  TwiConfig1 = TwiP1.Sam3uTwiConfigure[ CLIENT_ID ];

  Configure0 = TwiP0.ResourceConfigure;
  Configure1 = TwiP1.ResourceConfigure;

  TwiP0.ResourceConfigure[ CLIENT_ID ] <- HplSam3uTwiResourceCtrlC.ResourceConfigure;
  TwiP1.ResourceConfigure[ CLIENT_ID ] <- HplSam3uTwiResourceCtrlC.ResourceConfigure;

  //components new HplSam3uTwiC() as HplTwi0;
  //components new HplSam3uTwiC() as HplTwi1;
  components HplSam3uTwiC as HplTwiC;
  TwiP0.TwiInterrupt -> HplTwiC.HplSam3uTwiInterrupt;
  TwiP1.TwiInterrupt -> HplTwiC.HplSam3uTwiInterrupt;
  TwiP0.HplTwi -> HplTwiC;
  TwiP1.HplTwi -> HplTwiC;

  components LedsC;
  TwiP0.Leds -> LedsC;
  TwiP1.Leds -> LedsC;
}
