update-submodules:
	[ -d .git ] && git submodule update --init --recursive || :

packages: update-submodules
	./buildPackages.sh

iso:
	sudo ./buildISO.sh

all: packages iso