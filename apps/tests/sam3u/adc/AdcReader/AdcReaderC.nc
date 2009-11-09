configuration AdcReaderC
{
  provides interface Read<uint16_t>;
}

implementation
{
  components new AdcReadClientC(), AdcReaderP;

  Read = AdcReadClientC;
  AdcReadClientC.AdcConfigure -> AdcReaderP;
}
