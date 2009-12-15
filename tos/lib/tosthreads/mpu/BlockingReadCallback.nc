interface BlockingReadCallback {
	command error_t read(uint8_t id, uint16_t* val);
}
