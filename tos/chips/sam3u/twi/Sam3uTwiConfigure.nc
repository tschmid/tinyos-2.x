#include "sam3utwihardware.h"

interface Sam3uTwiConfigure {
  async command const sam3u_twi_union_config_t* getConfig();
}
