configuration AdcReaderC
{
  provides interface ReadNow<uint16_t>;
  provides interface Resource;
}

implementation
{
  components new AdcReadNowClientC(), AdcReaderP;

  ReadNow = AdcReadNowClientC;
  Resource = AdcReadNowClientC;
  AdcReadNowClientC.AdcConfigure -> AdcReaderP;
}
