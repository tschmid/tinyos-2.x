configuration MoteClockC
{

    provides {
        interface Init;
    }
}

implementation
{

    components MoteClockP, HplSam3uClockC;

    Init = MoteClockP;
    MoteClockP.HplSam3uClock -> HplSam3uClockC;
}
