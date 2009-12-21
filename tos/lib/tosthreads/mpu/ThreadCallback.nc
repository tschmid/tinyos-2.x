interface ThreadCallback
{
	command error_t sleep(uint8_t id, uint32_t milli);
	command error_t join(uint8_t id);
	command error_t start(uint8_t id, void* arg);
}
