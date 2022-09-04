TARGET_EXEC:=zelda3
ROM:=tables/zelda3.sfc
SRCS:=$(wildcard *.c snes/*.c)
OBJS:=$(SRCS:%.c=%.o)
GEN:=$(shell grep -hor tables/generated.*.h --include \*.c .)
PYTHON:=/usr/bin/env python3
CFLAGS:=${CFLAGS} -O2 $(shell sdl2-config --cflags)
LDFLAGS:=${LDFLAGS} -lm $(shell sdl2-config --libs)

.PHONY: all clean clean_obj clean_gen

all: $(TARGET_EXEC)
$(TARGET_EXEC): tables/generated_dialogue.h $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)
$(GEN): tables/dialogue.txt
	cd tables; $(PYTHON) compile_resources.py ../$(ROM)
tables/dialogue.txt:
	cd tables; $(PYTHON) extract_resources.py ../$(ROM)

clean: clean_obj clean_gen
clean_obj:
	$(RM) $(OBJS) $(TARGET_EXEC)
clean_gen:
	$(RM) $(GEN)
