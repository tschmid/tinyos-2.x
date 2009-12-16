#include "AM.h"
#include "message.h"

interface BlockingAMSendCallback {
	command error_t send(am_id_t am_id, am_addr_t addr, message_t* msg, uint8_t len);
}
