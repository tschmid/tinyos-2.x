#ifndef RTT_H
#define RTT_H

// Real Time Timer Register definition
typedef struct rtt {
    volatile uint32_t rtmr;	// Real Time Mode Register
    volatile uint32_t rtar;	// Real Time Alarm Register
    volatile uint32_t rtvr;	// Real Time Value Register
    volatile uint32_t rtsr;	// Real Time Status Register
} rtt_t;

#define RTT ((rtt_t *) 0x400E1230) // (RTTC) Base Address

// -------- RTTC_RTMR : (RTTC Offset: 0x0) Real-time Mode Register --------
#define RTTC_RTPRES     (0xFFFF <<  0) // (RTTC) Real-time Timer Prescaler Value
#define RTTC_ALMIEN     (0x1 << 16) // (RTTC) Alarm Interrupt Enable
#define RTTC_RTTINCIEN  (0x1 << 17) // (RTTC) Real Time Timer Increment Interrupt Enable
#define RTTC_RTTRST     (0x1 << 18) // (RTTC) Real Time Timer Restart
// -------- RTTC_RTAR : (RTTC Offset: 0x4) Real-time Alarm Register --------
#define RTTC_ALMV       (0x0 <<  0) // (RTTC) Alarm Value
// -------- RTTC_RTVR : (RTTC Offset: 0x8) Current Real-time Value Register --------
#define RTTC_CRTV       (0x0 <<  0) // (RTTC) Current Real-time Value
// -------- RTTC_RTSR : (RTTC Offset: 0xc) Real-time Status Register --------
#define RTTC_ALMS       (0x1 <<  0) // (RTTC) Real-time Alarm Status
#define RTTC_RTTINC     (0x1 <<  1) // (RTTC) Real-time Timer Increment


#endif // RTT_H
