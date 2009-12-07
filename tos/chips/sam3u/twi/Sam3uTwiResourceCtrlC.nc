configuration Sam3uTwiResourceCtrlC {
  provides interface Resource[ uint8_t id ];
  //provides interface ResourceConfigure[uint8_t id ];
  uses interface Resource as TwiResource[ uint8_t id ];
}
implementation {
  components Sam3uTwiResourceCtrlP as TwiP;
  components LedsC, NoLedsC;
  Resource = TwiP.Resource;
  //ResourceConfigure = TwiP.ResourceConfigure;
  TwiResource = TwiP.TwiResource;
  TwiP.Leds -> NoLedsC;
  //components HplSam3uTwiC;
  //TwiP.HplTwi -> HplSam3uTwiC;
  //TwiP.Sam3uTwiConfigure

}
