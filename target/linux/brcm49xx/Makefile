#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=brcm49xx
BOARDNAME:=Broadcom BCM49xx (ARM64)
FEATURES:=squashfs nand usb pci pcie gpio
MAINTAINER:=Hamster Tian <haotia@gmail.com>
CPU_TYPE:=cortex-a53 # B53 actually

KERNEL_PATCHVER:=4.9

define Target/Description
	Build firmware images for Broadcom based BCM49xx routers with ARM64 CPU.
endef

include $(INCLUDE_DIR)/target.mk

KERNELNAME:=zImage dtbs

DEFAULT_PACKAGES += swconfig nvram \
	osafeloader oseama otrx \
	kmod-gpio-button-hotplug \
	kmod-leds-gpio kmod-ledtrig-default-on kmod-ledtrig-timer

$(eval $(call BuildTarget))
