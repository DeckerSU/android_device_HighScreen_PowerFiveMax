$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# These additionals go to /default.prop
ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=0 \
ro.allow.mock.location=1 \
ro.debuggable=1 \
ro.adb.secure=0 \
persist.service.acm.enable=0 \
persist.sys.usb.config=mtp \
ro.mount.fs=EXT4 \
debug.hwui.render_dirty_regions=false \
ro.sf.lcd_density=480 \
persist.radio.multisim.config=dsds \
ro.mtk_lte_support=1 \
ro.telephony.ril_class=MT6735 \
ro.telephony.ril.config=fakeiccid \
ro.telephony.sim.count=2 \
persist.gemini.sim_num=2 \
ril.current.share_modem=2 \
ro.mtk_gps_support=1 \
ro.mtk_agps_app=1 \
persist.debug.xlog.enable=1 \
persist.sys.display.clearMotion=0 

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product-if-exists, vendor/HighScreen/PowerFiveMax/PowerFiveMax-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/HighScreen/PowerFiveMax/overlay
PRODUCT_PACKAGE_OVERLAYS += device/HighScreen/PowerFiveMax/overlay # enable this to be able overlay a default wallpaper

LOCAL_PATH := device/HighScreen/PowerFiveMax
ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := $(LOCAL_PATH)/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_PACKAGES += \
    libxlog

# Lights
#PRODUCT_PACKAGES += \
#    lights.mt6755

# Audio
#PRODUCT_PACKAGES += \
#    audio.primary.mt6755 \
#    audio_policy.default \
#    audio.a2dp.default \
#    audio.usb.default \
#    audio.r_submix.default

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media_codecs.xml:system/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/configs/media_codecs_performance.xml:system/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/audio/audio_policy.conf:system/etc/audio_policy.conf \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:system/etc/media_codecs_google_video_le.xml \
    $(LOCAL_PATH)/configs/media_codecs_mediatek_audio.xml:system/etc/media_codecs_mediatek_audio.xml \
    $(LOCAL_PATH)/configs/media_codecs_mediatek_video.xml:system/etc/media_codecs_mediatek_video.xml

# Wifi
PRODUCT_PACKAGES += \
    libwpa_client \
    hostapd \
    dhcpcd.conf \
    wpa_supplicant \
    wpa_supplicant.conf
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/hostapd/hostapd_default.conf:system/etc/hostapd/hostapd_default.conf \
    $(LOCAL_PATH)/configs/hostapd/hostapd.accept:system/etc/hostapd/hostapd.accept \
    $(LOCAL_PATH)/configs/hostapd/hostapd.deny:system/etc/hostapd/hostapd.deny

# Bluetooth
# Disable it, because it uses libbluetoothdrv.so, scheme to access from MT6580,
# that not exists in mt6755.

#PRODUCT_PACKAGES += \
#    libbt-vendor

# RIL
#PRODUCT_PACKAGES += \
#    gsm0710muxd \
#    gsm0710muxdmd2 \
#    mtkrild \
#    mtkrildmd2 \
#    mtk-ril \
#    mtk-rilmd2

# Telecomm
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/ecc_list.xml:system/etc/ecc_list.xml \
    $(LOCAL_PATH)/configs/spn-conf.xml:system/etc/spn-conf.xml

# GPS
PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/configs/agps_profiles_conf2.xml:system/etc/agps_profiles_conf2.xml

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/mtk-kpd.kl:system/usr/keylayout/mtk-kpd.kl
#   $(LOCAL_PATH)/configs/mtk-tpd.kl:system/usr/keylayout/mtk-tpd.kl

# Thermal
PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/configs/thermal.conf:system/etc/.tp/thermal.conf \
     $(LOCAL_PATH)/configs/thermal.off.conf:system/etc/.tp/thermal.off.conf \
     $(LOCAL_PATH)/configs/.ht120.mtc:system/etc/.tp/.ht120.mtc \
     #$(LOCAL_PATH)/configs/thermalstress.cfg:system/etc/.tp/thermalstress.cfg

# Ramdisk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/root/fstab.mt6755:root/fstab.mt6755 \
    $(LOCAL_PATH)/rootdir/root/init.mt6755.rc:root/init.mt6755.rc \
    $(LOCAL_PATH)/rootdir/root/init.modem.rc:root/init.modem.rc \
    $(LOCAL_PATH)/rootdir/root/init.recovery.mt6755.rc:root/init.recovery.mt6755.rc \
    $(LOCAL_PATH)/rootdir/root/init.mt6755.usb.rc:root/init.mt6755.usb.rc \
    $(LOCAL_PATH)/rootdir/root/twrp.fstab:recovery/root/etc/twrp.fstab \
    $(LOCAL_PATH)/rootdir/root/ueventd.mt6755.rc:root/ueventd.mt6755.rc \
    $(LOCAL_PATH)/rootdir/root/init.project.rc:root/init.project.rc \
    $(LOCAL_PATH)/rootdir/root/init.trustonic.rc:root/init.trustonic.rc \
    $(LOCAL_KERNEL):kernel
     
# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    $(LOCAL_PATH)/rootdir/system/etc/permissions/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    $(LOCAL_PATH)/rootdir/system/etc/permissions/android.hardware.microphone.xml:system/etc/permissions/android.hardware.microphone.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml 

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.consumerir.xml:system/etc/permissions/android.hardware.consumerir.xml \
    frameworks/native/data/etc/android.hardware.faketouch.xml:system/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# USB
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

# NFC (disabled in this build)
#PRODUCT_PACKAGES += \
#    com.android.nfc_extras \
#    nfcstackp \
#    libmtknfc_dynamic_load_jni \
#    libnfc_mt6605_jni \
#    Nfc \
#    Tag

#PRODUCT_COPY_FILES += \
#    packages/apps/Nfc/migrate_nfc.txt:system/etc/updatecmds/migrate_nfc.txt \
#    frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
#    frameworks/native/data/etc/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
#    frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml

# Torch
PRODUCT_PACKAGES += \
    Torch

# FM Radio
PRODUCT_PACKAGES += \
    FMRadio \
    libfmjni \
    libfmcust \
    libmtkplayer

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/fmr/mt6627_fm_cust.cfg:system/etc/fmr/mt6627_fm_cust.cfg

# libmtkplayer description in vendor (!)

# Smart Cover
#PRODUCT_PACKAGES += \
#    SmartCover

# Camera
PRODUCT_PACKAGES += \
    Snap

# mrdump related
PRODUCT_PACKAGES += \
    libmrdump \
    mrdump_tool

# 3rd-party apps
PRODUCT_PACKAGES += \
	Telegram+3.16.1


#Hack for prebuilt kernel
$(shell mkdir -p $(OUT)/obj/KERNEL_OBJ/usr)
$(shell touch $(OUT)/obj/KERNEL_OBJ/usr/export_includes)

##
$(call inherit-product, build/target/product/full.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_PowerFiveMax
PRODUCT_DEVICE := PowerFiveMax
PRODUCT_LOCALES := en_US en_GB ru_RU

TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 720

$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)
# must enable for 2 Gb RAM - phone-xhdpi-2048-dalvik-heap.mk
#$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

## Statistics
PRODUCT_PROPERTY_OVERRIDES += \
  ro.romstats.name=LineageOS \
  ro.romstats.version=13.0_64_bit \
  ro.romstats.tframe=7 
PRODUCT_PACKAGES += \
	RomStats

## CM14 mtk symbols
PRODUCT_PACKAGES += \
    libmtk_symbols

## GPS
PRODUCT_PACKAGES += \
    gps.mt6755 \
    YGPS

## Allow IPv6 tethering (https://github.com/LineageOS/android_device_bq_paella/commit/b74a6486b83503116f5954d06cd1bcd6671b4fc0)
#PRODUCT_PACKAGES += \
#     ebtables \
#     ethertypes

## CM Apps
PRODUCT_PACKAGES += \
	CMFileManager

# Fingerprint
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml
PRODUCT_PACKAGES += \
    fingerprintd 

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_param/AudioParamOptions.xml:system/etc/audio_param/AudioParamOptions.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackACF_AudioParam.xml:system/etc/audio_param/PlaybackACF_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackACF_ParamUnitDesc.xml:system/etc/audio_param/PlaybackACF_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackDRC_AudioParam.xml:system/etc/audio_param/PlaybackDRC_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackDRC_ParamUnitDesc.xml:system/etc/audio_param/PlaybackDRC_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackHCF_AudioParam.xml:system/etc/audio_param/PlaybackHCF_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackHCF_ParamUnitDesc.xml:system/etc/audio_param/PlaybackHCF_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackVolAna_AudioParam.xml:system/etc/audio_param/PlaybackVolAna_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackVolAna_ParamUnitDesc.xml:system/etc/audio_param/PlaybackVolAna_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackVolDigi_AudioParam.xml:system/etc/audio_param/PlaybackVolDigi_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackVolDigi_ParamUnitDesc.xml:system/etc/audio_param/PlaybackVolDigi_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackVolUI_AudioParam.xml:system/etc/audio_param/PlaybackVolUI_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/PlaybackVolUI_ParamUnitDesc.xml:system/etc/audio_param/PlaybackVolUI_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/Playback_AudioParam.xml:system/etc/audio_param/Playback_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/Playback_ParamTreeView.xml:system/etc/audio_param/Playback_ParamTreeView.xml \
    $(LOCAL_PATH)/audio/audio_param/Playback_ParamUnitDesc.xml:system/etc/audio_param/Playback_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordDMNR_AudioParam.xml:system/etc/audio_param/RecordDMNR_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordDMNR_ParamUnitDesc.xml:system/etc/audio_param/RecordDMNR_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordFIR_AudioParam.xml:system/etc/audio_param/RecordFIR_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordFIR_ParamUnitDesc.xml:system/etc/audio_param/RecordFIR_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordUI_AudioParam.xml:system/etc/audio_param/RecordUI_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordUI_ParamUnitDesc.xml:system/etc/audio_param/RecordUI_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordVolUI_AudioParam.xml:system/etc/audio_param/RecordVolUI_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordVolUI_ParamUnitDesc.xml:system/etc/audio_param/RecordVolUI_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordVol_AudioParam.xml:system/etc/audio_param/RecordVol_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/RecordVol_ParamUnitDesc.xml:system/etc/audio_param/RecordVol_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/Record_AudioParam.xml:system/etc/audio_param/Record_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/Record_ParamTreeView.xml:system/etc/audio_param/Record_ParamTreeView.xml \
    $(LOCAL_PATH)/audio/audio_param/Record_ParamUnitDesc.xml:system/etc/audio_param/Record_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechDMNR_AudioParam.xml:system/etc/audio_param/SpeechDMNR_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechDMNR_ParamUnitDesc.xml:system/etc/audio_param/SpeechDMNR_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechGeneral_AudioParam.xml:system/etc/audio_param/SpeechGeneral_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechGeneral_ParamUnitDesc.xml:system/etc/audio_param/SpeechGeneral_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechMagiClarity_AudioParam.xml:system/etc/audio_param/SpeechMagiClarity_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechMagiClarity_ParamUnitDesc.xml:system/etc/audio_param/SpeechMagiClarity_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechUI_AudioParam.xml:system/etc/audio_param/SpeechUI_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechUI_ParamUnitDesc.xml:system/etc/audio_param/SpeechUI_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechVolUI_AudioParam.xml:system/etc/audio_param/SpeechVolUI_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechVolUI_ParamUnitDesc.xml:system/etc/audio_param/SpeechVolUI_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechVol_AudioParam.xml:system/etc/audio_param/SpeechVol_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/SpeechVol_ParamUnitDesc.xml:system/etc/audio_param/SpeechVol_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/Speech_AudioParam.xml:system/etc/audio_param/Speech_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/Speech_ParamTreeView.xml:system/etc/audio_param/Speech_ParamTreeView.xml \
    $(LOCAL_PATH)/audio/audio_param/Speech_ParamUnitDesc.xml:system/etc/audio_param/Speech_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPDMNR_AudioParam.xml:system/etc/audio_param/VoIPDMNR_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPDMNR_ParamUnitDesc.xml:system/etc/audio_param/VoIPDMNR_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPGeneral_AudioParam.xml:system/etc/audio_param/VoIPGeneral_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPGeneral_ParamUnitDesc.xml:system/etc/audio_param/VoIPGeneral_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPUI_AudioParam.xml:system/etc/audio_param/VoIPUI_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPUI_ParamUnitDesc.xml:system/etc/audio_param/VoIPUI_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPVolUI_AudioParam.xml:system/etc/audio_param/VoIPVolUI_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPVolUI_ParamUnitDesc.xml:system/etc/audio_param/VoIPVolUI_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPVol_AudioParam.xml:system/etc/audio_param/VoIPVol_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIPVol_ParamUnitDesc.xml:system/etc/audio_param/VoIPVol_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIP_AudioParam.xml:system/etc/audio_param/VoIP_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIP_ParamTreeView.xml:system/etc/audio_param/VoIP_ParamTreeView.xml \
    $(LOCAL_PATH)/audio/audio_param/VoIP_ParamUnitDesc.xml:system/etc/audio_param/VoIP_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/VolumeGainMap_AudioParam.xml:system/etc/audio_param/VolumeGainMap_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/VolumeGainMap_ParamUnitDesc.xml:system/etc/audio_param/VolumeGainMap_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_param/Volume_AudioParam.xml:system/etc/audio_param/Volume_AudioParam.xml \
    $(LOCAL_PATH)/audio/audio_param/Volume_ParamUnitDesc.xml:system/etc/audio_param/Volume_ParamUnitDesc.xml \
    $(LOCAL_PATH)/audio/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/audio/audio_device.xml:system/etc/audio_device.xml \
    $(LOCAL_PATH)/audio/audio_em.xml:system/etc/audio_em.xml
