all: | packages iso

packages: package-kovri package-monero
	mkdir -p repository && rm -rf repository/moneroz.db*
	cd repository && repo-add moneroz.db.tar.xz *pkg.tar.xz

package-monero:
	cd monero-gui-packager && rm -rf pkg src *pkg.tar.xz monero-gui && makepkg && cp *pkg.tar.xz ../repository

package-kovri:
	cd kovri-packager && rm -rf pkg src *pkg.tar.xz cpp-netlib cryptopp kovri kovri-docs && makepkg && cp *pkg.tar.xz ../repository

iso:
	sudo ./buildISO.sh
