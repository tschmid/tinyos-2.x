#include "sa3uadc12bhardware.h"

module AdcReaderP
{
  provides interface AdcConfigure<const sam3u_adc12_channel_config_t*>;
}

implementation {
  const sam3u_adc12_channel_config_t config = {
  channel: 0,
  diff: 0,
  prescal: 2,
  lowres: 0,
  shtim: 15,
  ibctl: 1,
  sleep: 0,
  startup: 104,
  trgen: 0,
  trgsel: 0
  };

  async command const sam3u_adc12_channel_config_t* AdcConfigure.getConfiguration() {
    return &config;
  }
}
