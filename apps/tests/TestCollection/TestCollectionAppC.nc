/**
 * TestCollectionAppC exercises collection.
 *
 * 
 * @author Kyle Jamieson
 * @version $Id$
 * @see Net2-WG
 */

configuration TestCollectionAppC {}
implementation {
  components TestCollectionC, MainC, LedsC;

  TestCollectionC.Boot -> MainC;
  TestCollectionC.Leds -> LedsC;

  components new CollectionSenderC(0xDE);

  components new TimerMilliC();
  TestCollectionC.Timer -> TimerMilliC;
}
