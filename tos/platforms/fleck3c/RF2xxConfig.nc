interface RF2xxConfig 
{
	command void setPhyMode(uint8_t mode);
	command uint8_t readPhyMode();
	command void setAntenna(uint8_t id);
	command uint8_t getAntenna();
    command void resynchPLL();
}

