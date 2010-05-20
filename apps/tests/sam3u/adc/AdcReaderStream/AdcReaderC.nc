configuration AdcReaderC
{
  provides interface ReadStream<uint16_t>;
}

implementation
{
  components new AdcReadStreamClientC(), AdcReaderP;

  ReadStream = AdcReadStreamClientC;
  AdcReadStreamClientC.AdcConfigure -> AdcReaderP;
}
