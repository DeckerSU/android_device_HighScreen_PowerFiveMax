### audio.primary.mt6755.so 

	03-06 05:07:54.439   523   523 F DEBUG   :     #00 pc 00078824  /system/lib/hw/audio.primary.mt6755.so (_ZN7android22AudioMTKGainController17SetHeadPhoneLGainEi+112)
	03-06 05:07:54.440   523   523 F DEBUG   :     #01 pc 00078514  /system/lib/hw/audio.primary.mt6755.so (_ZN7android22AudioMTKGainController14SetSpeakerGainEi+60)
	03-06 05:07:54.440   523   523 F DEBUG   :     #02 pc 0007aa08  /system/lib/hw/audio.primary.mt6755.so (_ZN7android22AudioMTKGainController15setNormalVolumeEiii12audio_mode_t+488)
	03-06 05:07:54.440   523   523 F DEBUG   :     #03 pc 0007ab10  /system/lib/hw/audio.primary.mt6755.so (_ZN7android22AudioMTKGainController15setMasterVolumeEf12audio_mode_tj+156)
	03-06 05:07:54.440   523   523 F DEBUG   :     #04 pc 00064dfc  /system/lib/hw/audio.primary.mt6755.so (_ZN7android22AudioALSAStreamManager15setMasterVolumeEf+228)
	03-06 05:07:54.440   523   523 F DEBUG   :     #05 pc 00024949  /system/lib/libaudioflinger.so
	03-06 05:07:54.440   523   523 F DEBUG   :     #06 pc 00028007  /system/lib/libaudioflinger.so
	03-06 05:07:54.440   523   523 F DEBUG   :     #07 pc 0000bae3  /system/lib/libaudiopolicyservice.so
	03-06 05:07:54.440   523   523 F DEBUG   :     #08 pc 00024385  /system/lib/libaudiopolicymanagerdefault.so (_ZN7android18AudioPolicyManagerC1EPNS_26AudioPolicyClientInterfaceE+692)
	03-06 05:07:54.440   523   523 F DEBUG   :     #09 pc 0000082f  /system/lib/libaudiopolicymanager.so (createAudioPolicyManager+14)
	03-06 05:07:54.440   523   523 F DEBUG   :     #10 pc 0000603f  /system/lib/libaudiopolicyservice.so
	03-06 05:07:54.440   523   523 F DEBUG   :     #11 pc 00001d8f  /system/bin/audioserver
	03-06 05:07:54.440   523   523 F DEBUG   :     #12 pc 0000182b  /system/bin/audioserver
	03-06 05:07:54.440   523   523 F DEBUG   :     #13 pc 00016c5d  /system/lib/libc.so (__libc_init+48)
	03-06 05:07:54.440   523   523 F DEBUG   :     #14 pc 0000156c  /system/bin/audioserver

_ZN7android22AudioMTKGainController17SetHeadPhoneLGainEi - android::AudioMTKGainController::SetHeadPhoneLGain(int)

Проблема в 32-bit'ной audio.primary.mt6755.so ... ее либо надо собрать из исходников, либо просто удалить (но тогда не будет звука )))

Как вариант можно сделать stub для этих функций:

	// void _ZN7android22AudioMTKGainController17SetHeadPhoneLGainEi(uint32_t DegradedBGain) {}
	// void _ZN7android22AudioMTKGainController17SetHeadPhoneRGainEi(uint32_t DegradedBGain) {}
	// void _ZN7android22AudioMTKGainController14SetSpeakerGainEi(uint32_t DegradedBGain) {}
	// void _ZN7android22AudioMTKGainController12ApplyMicGainE13GAIN_MIC_MODE11GAIN_DEVICE12audio_mode_t(uint32_t MicType, int mode) {}

	
Но это чревато отсутствием записи с микрофона и еще некоторыми вещами ...