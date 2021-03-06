all: | packages iso

packages: package-kovri package-monero
	rm -rf repository/moneroz.db*
	cd repository && repo-add moneroz.db.tar.xz *pkg.tar.xz

package-monero:
	mkdir -p repository
	cd monero-all-packager && rm -rf pkg src *pkg.tar.xz monero-gui && makepkg && cp *pkg.tar.xz ../repository

package-kovri:
	mkdir -p repository
	cd kovri-packager && rm -rf pkg src *pkg.tar.xz cpp-netlib cryptopp kovri kovri-docs && makepkg && cp *pkg.tar.xz ../repository

iso:
	sudo ./buildISO.sh
