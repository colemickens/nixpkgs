#! @bash@/bin/sh -e

target=/boot # Target directory

while getopts "t:c:d:g:" opt; do
    case "$opt" in
        d) target="$OPTARG" ;;
        *) ;;
    esac
done

copyForced() {
    local src="$1"
    local dst="$2"
    cp $src $dst.tmp
    mv $dst.tmp $dst
}

# Call the extlinux builder
"@systemdBootBuilder@" "$@"

# Add the firmware files
rpi4uefidir=@rpi4uefi@
copyForced $rpi4uefidir/start4.elf $target/start4.elf
copyForced $rpi4uefidir/fixup4.dat $target/fixup4.dat
copyForced $rpi4uefidir/RPI_EFI.fd $target/RPI_EFI.fd
copyForced $rpi4uefidir/config.txt $target/config.txt
copyForced $rpi4uefidir/bcm2711-rpi-4-b.dtb $target/bcm2711-rpi-4-b.dtb
copyForced $rpi4uefidir/bcm2711-rpi-400.dtb $target/bcm2711-rpi-400.dtb
copyForced $rpi4uefidir/bcm2711-rpi-cm4.dtb $target/bcm2711-rpi-cm4.dtb


# Add the uboot file
#copyForced @uboot@/u-boot.bin $target/u-boot-rpi.bin

# Add the config.txt
#copyForced @configTxt@ $target/config.txt
