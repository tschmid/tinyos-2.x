#include <color.h>
#include <lcd.h>

module MoteP
{
  uses {
    interface Boot;
    interface Leds;
    interface ReadNow<uint16_t>;
    interface Resource;
    interface SplitControl as SerialSplitControl;
    interface Packet;
    interface Timer<TMilli>;
    interface Lcd;
    interface Draw;
  }
}

implementation
{
  event void Boot.booted()
  {
    while (call SerialSplitControl.start() != SUCCESS);
    call Lcd.initialize();
  }

  event void Lcd.initializeDone(error_t err)
  {
    if(err != SUCCESS)
      {
      }
    else
      {
        call Draw.fill(COLOR_RED);
        call Lcd.start();
      }
  }

  event void Lcd.startDone(){
    call Timer.startPeriodic(512);
  }


  event void SerialSplitControl.startDone(error_t error)
  {
    if (error != SUCCESS) {
      while (call SerialSplitControl.start() != SUCCESS);
    }
  }
  
  event void SerialSplitControl.stopDone(error_t error) {}
  
  task void sample()
  {
    const char *start = "Start Sampling";
    call Draw.fill(COLOR_BLUE);
    call Draw.drawString(10,50,start,COLOR_RED);
    call Resource.request();
  }

  event void Resource.granted(){
    call ReadNow.read();
  }
  
  async event void ReadNow.readDone(error_t result, uint16_t value)
  {
    const char *fail = "Read done error";
    const char *good = "Read done success";
    if (result != SUCCESS) {
      call Draw.drawString(10,70,fail,COLOR_BLACK);
    }else{
      call Draw.drawString(10,70,good,COLOR_BLACK);
      call Draw.drawInt(100,100,value,1,COLOR_BLACK);
    }
  }
  
  event void Timer.fired() {
    call Leds.led0Toggle();
    call Leds.led2Off();
    post sample();
  }
}
