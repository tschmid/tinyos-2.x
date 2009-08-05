configuration MoteClockC
{

    provides {
        interface Init;
    }
}

implementation
{

    components MoteClockP;

    Init = MoteClockP;
}
