packages:
	./buildPackages.sh

iso:
	sudo ./buildISO.sh

all: packages iso