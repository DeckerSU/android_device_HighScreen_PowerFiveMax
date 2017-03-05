## Specify phone tech before including full_phone

# Release name
PRODUCT_RELEASE_NAME := PowerFiveMax

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/HighScreen/PowerFiveMax/device_PowerFiveMax.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := PowerFiveMax
PRODUCT_NAME := lineage_PowerFiveMax
PRODUCT_BRAND := HighScreen
PRODUCT_MODEL := PowerFiveMax
PRODUCT_MANUFACTURER := HighScreen
