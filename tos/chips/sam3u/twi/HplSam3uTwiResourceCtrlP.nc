configuration HplSam3uTwiResourceCtrlP {
  provides interface Resource[uint8_t id];
  provides interface ResourceRequested[uint8_t id];
  uses interface ResourceConfigure[uint8_t id];
}

implementation {

  components new FcfsArbiterC( SAM3U_HPLTWI_RESOURCE ) as Arbiter;
  Resource = Arbiter;
  ResourceConfigure = Arbiter;
  ResourceRequested = Arbiter;
}
