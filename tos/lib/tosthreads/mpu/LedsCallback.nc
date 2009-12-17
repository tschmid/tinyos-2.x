interface LedsCallback
{
	async command uint32_t leds(uint32_t leds_function, uint32_t leds_param);
}
