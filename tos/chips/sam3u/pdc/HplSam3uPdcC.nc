configuration HplSam3uPdcC {
  provides interface HplSam3uPdc as UartPdcControl;
  provides interface HplSam3uPdc as Usart0PdcControl;
  provides interface HplSam3uPdc as Usart1PdcControl;
  provides interface HplSam3uPdc as Usart2PdcControl;
  provides interface HplSam3uPdc as Usart3PdcControl;
}

implementation {

  components new HplSam3uPdcP(0x400E0600) as UartPdc;
  components new HplSam3uPdcP(0x40090000) as Usart0Pdc;
  components new HplSam3uPdcP(0x40094000) as Usart1Pdc;
  components new HplSam3uPdcP(0x40098000) as Usart2Pdc;
  components new HplSam3uPdcP(0x4009C000) as Usart3Pdc;
  components LedsC, NoLedsC;

  UartPdcControl = UartPdc;
  Usart0PdcControl = Usart0Pdc;
  Usart1PdcControl = Usart1Pdc;
  Usart2PdcControl = Usart2Pdc;
  Usart3PdcControl = Usart3Pdc;

  UartPdc.Leds -> LedsC;
  Usart0Pdc.Leds -> LedsC;
  Usart1Pdc.Leds -> LedsC;
  Usart2Pdc.Leds -> LedsC;
  Usart3Pdc.Leds -> LedsC;
}