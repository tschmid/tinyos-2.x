interface BlockingStdControlCallback {
	command error_t start(uint8_t id);
	command error_t stop(uint8_t id);
}
