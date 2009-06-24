# setup environment

#import DEBUG
#import MESSAGES

TARGET_ARCH = -mcpu=cortex-m3 -mthumb

COMPILE_OPTS = $(WARNINGS) $(TARGET_OPTS) $(MESSAGES) $(F_NO_STRICT_ALIASING) $(INCLUDE_DIRS)
WARNINGS = -Wall -W -Wshadow -Wwrite-strings -Winline
INCLUDE_DIRS = -I . -I inc

# needed to safely build the library (until proven otherwise)
F_NO_STRICT_ALIASING = -fno-strict-aliasing

ifdef DEBUG
 TARGET_OPTS = -O0 -g3
 DEBUG_MACRO = -DDEBUG
else
 TARGET_OPTS = -O2 $(F_INLINE) $(F_INLINE_ONCE) $(F_UNROLL_LOOPS)
 F_INLINE = -finline
 F_INLINE_ONCE = -finline-functions-called-once
 #F_UNROLL_LOOPS = -funroll-loops
endif

CPPFLAGS = $(DEBUG_MACRO)

CC = arm-none-eabi-gcc
CFLAGS = $(COMPILE_OPTS)

AS = $(CC) -x assembler-with-cpp -c $(TARGET_ARCH)
ASFLAGS = $(COMPILE_OPTS)

AR = arm-none-eabi-ar
ARFLAGS = cr


LIB_OUT = libstm32fw.a

LIB_OBJS = $(sort \
 $(patsubst %.c,%.o,$(wildcard src/*.c)) \
 $(patsubst %.s,%.o,$(wildcard src/*.s)))


# all

.PHONY: all
all: $(LIB_OUT)


# lib

$(LIB_OUT): $(LIB_OBJS)
	$(AR) $(ARFLAGS) $@ $(LIB_OBJS)

$(LIB_OBJS): $(wildcard *.h) $(wildcard inc/*.h)


# clean

.PHONY: clean
clean:
	-rm -f $(LIB_OBJS) $(LIB_OUT)
