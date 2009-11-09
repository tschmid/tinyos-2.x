//#define SAMPLE_BUFFER_SIZE 3000
#define SAMPLE_BUFFER_SIZE 1542
#define NUM_SAMPLES_PER_PACKET (TOSH_DATA_LENGTH / sizeof(uint16_t))

module MoteP
{
  uses {
    interface Boot;
    interface Leds;
    //interface ReadStream<uint16_t>;
    interface Read<uint16_t>;
    interface SplitControl as SerialSplitControl;
    interface AMSend;
    interface Packet;
    //interface Notify<button_state_t> as UserButtonNotify;
    interface Timer<TMilli> as UserButtonTimer;
    //    interface LogRead;
    //    interface LogWrite;
    //interface Counter<T32khz,uint32_t>;
  }
}

implementation
{
  uint16_t buf[SAMPLE_BUFFER_SIZE];
  uint16_t bufReadPtr;
  
  message_t sendPkt;
  uint16_t* sendPktPayload;
  uint32_t startCounter, avg;
  
  event void Boot.booted()
  {
    uint32_t i;
    for (i = 0; i < SAMPLE_BUFFER_SIZE; i++) {
      buf[i] = 0xFFFF;
    }
    //call UserButtonNotify.enable();
    //sendPktPayload = call AMSend.getPayload(&sendPkt, TOSH_DATA_LENGTH);
    while (call SerialSplitControl.start() != SUCCESS);
  }

  event void SerialSplitControl.startDone(error_t error)
  {
    if (error != SUCCESS) {
      while (call SerialSplitControl.start() != SUCCESS);
    }else{
      call UserButtonTimer.startPeriodic(512);
    }
  }
  
  event void SerialSplitControl.stopDone(error_t error) {}
  
  // ===== Sample ===== //
  
  task void sample()
  {
    call Leds.led0Toggle();
    //call ReadStream.postBuffer(buf, SAMPLE_BUFFER_SIZE);
    //call ReadStream.read(68);
    call Read.read();
    //startCounter = call Counter.get();
  }
  
  event void Read.readDone(error_t result, uint16_t value)
  {
    error_t error;
    if (result != SUCCESS) {
      //
    }else{
      sendPktPayload = call AMSend.getPayload(&sendPkt, 2);
      *sendPktPayload = value;
      error = call AMSend.send(0xFFFF, &sendPkt, 2);
      //printf("Temp\n");
      if(error == SUCCESS)
	call Leds.led1Toggle();
    }
  }
  
  //event void ReadStream.bufferDone(error_t result, uint16_t* buffer, uint16_t count) {}
  
  task void write()
  {
    if (bufReadPtr < SAMPLE_BUFFER_SIZE) {
      //      while (call LogWrite.append(&(buf[bufReadPtr]), sizeof(uint16_t)) != SUCCESS);
      bufReadPtr++;
    } else {
      //call Leds.led0Off();
    }
  }
  /*  
  event void LogWrite.eraseDone(error_t error)
  {
    if (error == SUCCESS) {
      bufReadPtr = 0;
      post write();
    } else {
      while (call LogWrite.erase() != SUCCESS);
    }      
  }
  
  event void LogWrite.appendDone(void* buffer, storage_len_t len, bool recordsLost, error_t error)
  {
    if (error != SUCCESS) {
      while (call LogWrite.append(buffer, sizeof(uint16_t)) != SUCCESS);
    } else {
      post write();
    }
  }
  
  event void LogWrite.syncDone(error_t error) {}
  */
  // ===== Send ===== //
  
  uint8_t pktSize;
  /*
  task void send()
  {
    if (call LogRead.currentOffset() < call LogWrite.currentOffset()) {
      while (call LogRead.read(sendPktPayload, TOSH_DATA_LENGTH) != SUCCESS);
    } else {
      call Leds.led1Off();
    }
  }
  */

  event void AMSend.sendDone(message_t* msg, error_t error)
  {
    if (error != SUCCESS) {
      while (call AMSend.send(0xFFFF, &sendPkt, call Packet.payloadLength(msg)) != SUCCESS);
    } else {
      //post send();
    }
  }
  
  //async event void Counter.overflow() {}
  /*
  event void LogRead.readDone(void* buffer, storage_len_t len, error_t error)
  {
    if (error == SUCCESS && len > 0) {
      while (call AMSend.send(0xFF, &sendPkt, len) != SUCCESS);
    } else {
      post send();
    }
  }
  
  event void LogRead.seekDone(error_t error)
  {
    if (error == SUCCESS) {
      post send();
    } else {
      while (call LogRead.seek(SEEK_BEGINNING) != SUCCESS);
    }
  }
  */
  // ===== User Button Stuff ===== //
  
  enum {
    UB_OFF,
    UB_SAMPLE,
    UB_SEND,
  };
  
  uint8_t userButtonMode = UB_OFF;
  
  event void UserButtonTimer.fired() {
    //call Leds.led0Toggle();
    //call Leds.led2Off();
    post sample();
  }
  /*
  event void UserButtonNotify.notify(button_state_t state)
  {
    if (state == BUTTON_PRESSED) {
      userButtonMode = UB_SEND;
      call UserButtonTimer.startOneShot((uint32_t)1024 * 3);
    } else if (state == BUTTON_RELEASED) {
      call Leds.led2Off();
      call UserButtonTimer.stop();
      
      if (userButtonMode == UB_SAMPLE) {
        call Leds.led0On();
        post sample();
        startCounter = call Counter.get();
      } else if (userButtonMode == UB_SEND) {
        call Leds.led1On();
        while (call LogRead.seek(SEEK_BEGINNING) != SUCCESS);
        //((uint32_t*)((void*)sendPktPayload))[0] = avg;
        //while (call AMSend.send(0xFF, &sendPkt, 4) != SUCCESS);
      }
      
      userButtonMode = UB_OFF;
    }
  }
  */
}
