#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Image/Prepare
	rm -f $(KDIR)/fs_mark
	echo -ne '\xde\xad\xc0\xde' > $(KDIR)/fs_mark
	$(call prepare_generic_squashfs,$(KDIR)/fs_mark)

	# For UBI we want only one extra block
	rm -f $(KDIR)/ubi_mark
	echo -ne '\xde\xad\xc0\xde' > $(KDIR)/ubi_mark
endef

# TRX with only one (kernel) partition
define Build/trx
	$(STAGING_DIR_HOST)/bin/trx \
		-o $@.new \
		-m 33554432 \
		-f $@
	mv $@.new $@
endef


define Build/trx-nand
	# kernel: always use 4 MiB (-28 B or TRX header) to allow upgrades even
	#	  if it grows up between releases
	# root: UBI with one extra block containing UBI mark to trigger erasing
	#	rest of partition
	$(STAGING_DIR_HOST)/bin/trx \
		-o $@.new \
		-m 33554432 \
		-f $(IMAGE_KERNEL) -a 0x20000 -b 0x400000 \
		-f $@ \
		-A $(KDIR)/ubi_mark -a 0x20000
	mv $@.new $@
endef

DEVICE_VARS += PRODUCTID SIGNATURE NETGEAR_BOARD_ID NETGEAR_REGION TPLINK_BOARD
DEVICE_VARS += BUFFALO_TAG_PLATFORM BUFFALO_TAG_VERSION BUFFALO_TAG_MINOR

IEEE8021X := wpad-mini
B43 := $(IEEE8021X) kmod-b43
BRCMFMAC_4366B1 := $(IEEE8021X) kmod-brcmfmac brcmfmac-firmware-4366b1-pcie
BRCMFMAC_4366C0 := $(IEEE8021X) kmod-brcmfmac
USB2_PACKAGES := kmod-usb-ohci kmod-usb2 kmod-phy-bcm-ns-usb2
USB2_PACKAGES += kmod-usb-ledtrig-usbport
USB3_PACKAGES := $(USB2_PACKAGES) kmod-usb3 kmod-phy-bcm-ns-usb3

define Device/Default
  # .dtb files are prefixed by SoC type, e.g. bcm4708- which is not included in device/image names
  # extract the full dtb name based on the device info
  DEVICE_DTS := $(patsubst %.dtb,%,$(notdir $(wildcard $(if $(IB),$(KDIR),$(DTS_DIR))/*-$(1).dtb)))
  KERNEL := kernel-bin | append-dtb | lzma-d16
  KERNEL_DEPENDS = $$(wildcard $(DTS_DIR)/$$(DEVICE_DTS).dts)
  KERNEL_INITRAMFS_SUFFIX := .trx
  KERNEL_INITRAMFS := kernel-bin | append-dtb | lzma-d16 | trx
  FILESYSTEMS := squashfs
  KERNEL_NAME := zImage
  IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1).$$(2)
  IMAGES := trx
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  IMAGE/trx := append-ubi | trx-nand
endef

define Device/netgear
  IMAGES := chk
  IMAGE/chk := append-ubi | trx-nand | netgear-chk
  NETGEAR_REGION := 1
endef

define Device/netgear-r8000p
  DEVICE_TITLE := Netgear R8000P
  DEVICE_PACKAGES := $(BRCMFMAC_4366C0) $(USB3_PACKAGES)
  #$(Device/netgear) # Default to trx
  NETGEAR_BOARD_ID := DO_NOT_FLASH
endef
TARGET_DEVICES += netgear-r8000p

$(eval $(call BuildImage))
