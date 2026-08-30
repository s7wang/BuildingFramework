obj-m += hello.o


KDIR := ../../../kernel_headers/5.4.0-150/linux-headers-5.4.0-150-generic


all:
	make -C $(KDIR) M=$(PWD) modules


clean:
	make -C $(KDIR) M=$(PWD) clean
