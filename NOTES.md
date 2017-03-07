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

	
Но это чревато отсутствием записи с микрофона и еще некоторыми

 вещами ...
 
** p.s.** Корень проблемы кроется в **etc/audio_param** и файлах audio* в etc, в частности:

* audio_device.xml
* audio_em.xml
* audio_policy.conf

На MT6735 таких файлов не было (!) ... а вот на MT6755 уже появились ... и они являются неотъемлемой частью подсистемы Audio.
 
### Проблема с Zygote

На CM13 столкнулся с падением Zygote ... Zygote BOOT FAILURE making display ready и что-то там про null exception. Вообщем проблема не стоила выеденного яйца, чуть выше в логе было:

	03-07 02:21:12.161   853   853 I SystemServer: Consumer IR Service
	03-07 02:21:12.162   853   853 E ConsumerIrService: Can't open consumer IR HW Module, error: -2
	

Все оказалось из-за того что присутствует файл /etc/permissions/android.hardware.consumerir.xml , а IR HW Module'я нет. Достаточно было удалить android.hardware.consumerir.xml , пока не решились проблемы с модулем и прошивка загрузилась.

Да, кстати, добавленный android.hardware.consumerir.xml без модуля может повесить загрузку всей системы в целом, даже без каких либо ошибок в logcat'е (!). Поэтому **если у вас что-то не загружается удалите лишние разрешения из /etc/permissions на всякий случай**.

###Fingerprint

* fingerprint.goodix.so
* fingerprint.mt6755.so

--

* lib_fpc_tac_shared.so
* libgf_algo.so
* libgf_ca.so
* libgf_hal.so
* libgoodixfingerprintd_binder.so
* goodixfingerprintd (/system/bin)
* libMcClient.so
* libMcRegistry.so
* libMcGatekeeper.so


Лог:

	03-07 03:37:27.047   435   435 V fingerprintd: nativeOpenHal()
	03-07 03:37:27.048   435   435 D fpc_fingerprint_hal: fpc_module_open
	03-07 03:37:27.048   435   435 D fpc_fingerprint_hal: gn_fpc_hw_reset
	03-07 03:37:27.048   435   435 E fpc_tac : gn_sysfs_node_write open: /sys/devices/fpc_interrupt/hw_reset failed, No such file or directory
	03-07 03:37:27.069   435   435 D fpc_tac : 'modalias'='of:Nfpc_interruptT<NULL>Cmediat' found on  path '/sys/bus/platform/devices/fpc_interrupt/'
	
Кстати, еще одна особенность, если по каким-то причинам бинарник от Goodix не может запустится, например так:

	/system/bin/goodixfingerprintd: can't execute: Permission denied

То в logcat'е этого к сожалению не видно, т.е. вместо того что сервис пытается запускаться, мы видим:

	03-07 12:18:15.319     1     1 E (6)[1:init]init: Service goodixfpd does not have a SELinux domain defined.
	03-07 12:18:15.319     1     1 I (6)[1:init]init: Starting service 'fingerprintd'...

Поэтому его нужно как минимум объявить в domain.te ...

ro.boot.fpsensor: gdx
persist.sys.fp.goodix 

	[init.svc.goodixfpd]: [running]
	[persist.sys.fp_vendor]: [goodix]
	[ro.gn.fp.tee.support]: [no]
	[ro.gn.gesture.vendor]: [goodix]

--

	03-07 14:14:53.515   431   431 I goodixfingerprintd: Starting goodixfingerprintd
	03-07 14:14:53.515   431   431 I goodixfingerprintd: goodixfingerprintd set_goodix_flag enter.
	03-07 14:14:53.515   431   431 I goodixfingerprintd: goodixfingerprintd check device for compatible other finger print vendor 
	03-07 14:14:53.515   431   431 I goodixfingerprintd: goodixfingerprintd success to open device (/dev/goodix_fp) 

libhardware? persist.sys.fp_vendor совместимость ...



### Remote IR

remote_ctrl -> **/dev/remote_ctrl**

* system/lib64/hw/consumerir.default.so
* system/lib64/libsmartir_v_2_0_1.so (это по идее от приложения Peel, правда где оно там используется понять так и не удалось)
* system/bin/meta_tst (не забыть про запуск в init'ах)
* system/app/Peel/Peel.apk
* system/lib64/hw/remoteir.default.so
* system/lib/hw/remoteir.default.so


