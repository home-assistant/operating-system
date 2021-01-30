CFLAGS := -Wall -g
all: rtk_hciattach
OBJS := hciattach.o hciattach_rtk.o hciattach_h4.o rtb_fwc.o

rtk_hciattach: $(OBJS)
	$(CC) -o rtk_hciattach $(OBJS)

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS)

clean:
	rm -f $(OBJS)  rtk_hciattach

tags: FORCE
	ctags -R
	find ./ -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" > cscope.files
	cscope -bkq -i cscope.files
PHONY += FORCE
FORCE:
