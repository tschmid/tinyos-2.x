#include "sam3utwihardware.h"

configuration HplSam3uTwiResourceCtrlC {
  provides interface Resource;
  provides interface ResourceRequested;
  uses interface ResourceConfigure;
}
implementation{

  enum {
    CLIENT_ID = unique( SAM3U_HPLTWI_RESOURCE ),
  };

  components HplSam3uTwiResourceCtrlP as TwiP;
  
  Resource = TwiP.Resource[ CLIENT_ID ];
  ResourceRequested = TwiP.ResourceRequested[ CLIENT_ID ];
  ResourceConfigure = TwiP.ResourceConfigure[ CLIENT_ID ];
}