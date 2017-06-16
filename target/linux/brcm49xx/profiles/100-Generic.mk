#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/Generic
  NAME:=Broadcom SoC, BCM49xx WiFi (brcmfmac, default)
  PACKAGES:=kmod-brcmfmac
endef

define Profile/Generic/Description
	Package set compatible with hardware any Broadcom BCM49xx
	SoC with a ARM64 CPU like the BCM4906, BCM4908
endef

$(eval $(call Profile,Generic))

