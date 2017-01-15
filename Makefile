obj-m += i2c-piix4.o

all:
		make -C /lib/modules/$(KVER)/build M=$(PWD) modules

clean:
		make -C /lib/modules/$(KVER)/build M=$(PWD) clean
