#
# Copyright (C) 2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/aosp_camellia.mk \
    $(LOCAL_DIR)/lineage_camellia.mk \
    $(LOCAL_DIR)/arrow_camellia.mk \
    $(LOCAL_DIR)/derp_camellia.mk \

COMMON_LUNCH_CHOICES := \
    lineage_camellia-user \
    lineage_camellia-userdebug \
    lineage_camellia-eng \
    arrow_camellia-user \
    arrow_camellia-userdebug \
    arrow_camellia-eng \
    derp_camellia-user \
    derp_camellia-userdebug \
    derp_camellia-eng \
