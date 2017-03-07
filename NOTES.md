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

libhardware.so -> hardware/libhardware/hardware.c  -> hw_get_module_by_class - модифицированная процедура.

**libhardware.so**

	 off_3E08        DCD aPersist_sys_fp     ; DATA XREF: hw_get_module_by_class+B6o
	.data.rel.ro.local:00003E08                                         ; .text:off_BC4o
	.data.rel.ro.local:00003E08                                         ; "persist.sys.fp_vendor"
	.data.rel.ro.local:00003E0C                 DCD aRo_hardware        ; "ro.hardware"
	.data.rel.ro.local:00003E10                 DCD aRo_product_boa     ; "ro.product.board"
	.data.rel.ro.local:00003E14                 DCD aRo_board_platf     ; "ro.board.platform"
	.data.rel.ro.local:00003E18                 DCD aRo_arch            ; "ro.arch"
	.data.rel.ro.local:00003E1C                 DCD aRo_btstack         ; "ro.btstack"
	
Процедура:	

	int __fastcall hw_get_module_by_class(const char *a1, int a2, int a3)
	{
	  int v3; // r7@1
	  int v4; // r11@1
	  const char *v5; // r9@1
	  int v6; // r10@5
	  void *v7; // r0@7
	  void *v8; // r8@7
	  int result; // r0@14
	  char *v10; // r0@8
	  void *v11; // r0@18
	  void *v12; // r5@18
	  char s; // [sp+Ch] [bp-402Ch]@1
	  int v14; // [sp+100Ch] [bp-302Ch]@1
	  int v15; // [sp+200Ch] [bp-202Ch]@1
	  int v16; // [sp+300Ch] [bp-102Ch]@1
	  int v17; // [sp+400Ch] [bp-2Ch]@1
	
	  v3 = a3;
	  v4 = a2;
	  v5 = a1;
	  v17 = _stack_chk_guard;
	  memset(&s, 0, 0x1000u);
	  memset(&v14, 0, 0x1000u);
	  memset(&v15, 0, 0x1000u);
	  memset(&v16, 0, 0x1000u);
	  if ( v4 )
	    snprintf((char *)&v15, 0x1000u, "%s.%s", v5, v4);
	  else
	    strlcpy(&v15, v5, 4096);
	  snprintf((char *)&v16, 0x1000u, "ro.hardware.%s", &v15);
	  if ( property_get(&v16, &s, 0) <= 0 || sub_9B4(&v14, &v15, &s) )
	  {
	    v6 = 0;
	    while ( !property_get(off_3E08[v6], &s, 0) || sub_9B4(&v14, &v15, &s) )
	    {
	      ++v6;
	      if ( v6 == 6 )
	      {
	        if ( !sub_9B4(&v14, &v15, "default") )
	          break;
	        result = -2;
	        goto LABEL_24;
	      }
	    }
	  }
	  v7 = dlopen((const char *)&v14, 0);
	  v8 = v7;
	  if ( !v7 )
	  {
	    v10 = dlerror();
	    if ( !v10 )
	      v10 = "unknown";
	    _android_log_print(6, "HAL", "load: module=%s\n%s", &v14, v10);
	    goto LABEL_27;
	  }
	  v11 = dlsym(v7, "HMI");
	  v12 = v11;
	  if ( !v11 )
	  {
	    _android_log_print(6, "HAL", "load: couldn't find symbol %s", "HMI");
	LABEL_26:
	    dlclose(v8);
	LABEL_27:
	    result = -22;
	    v12 = 0;
	    goto LABEL_23;
	  }
	  result = strcmp(v5, *((const char **)v11 + 2));
	  if ( result )
	  {
	    ((void (__fastcall *)(signed int, char *, _DWORD, const char *))_android_log_print)(
	      6,
	      "HAL",
	      "load: id=%s != hmi->id=%s",
	      v5);
	    goto LABEL_26;
	  }
	  *((_DWORD *)v12 + 6) = v8;
	LABEL_23:
	  *(_DWORD *)v3 = v12;
	LABEL_24:
	  if ( v17 != _stack_chk_guard )
	    _stack_chk_fail(result);
	  return result;
	}

https://forum.xda-developers.com/showpost.php?p=70000911&postcount=2248

Вроде удалось завести сканер, но, приложение settings падает (точно такая же ситуация по ссылке выше):

	
	03-07 18:09:43.197  3503  3503 D AndroidRuntime: Shutting down VM
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: FATAL EXCEPTION: main
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: Process: com.android.settings, PID: 3503
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: java.lang.NullPointerException: Attempt to write to field 'int android.app.Fragment.mNextAnim' on a null object reference
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at android.app.BackStackRecord.run(BackStackRecord.java:780)
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at android.app.FragmentManagerImpl.execPendingActions(FragmentManager.java:1578)
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at android.app.FragmentManagerImpl$1.run(FragmentManager.java:483)
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at android.os.Handler.handleCallback(Handler.java:751)
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at android.os.Handler.dispatchMessage(Handler.java:95)
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at android.os.Looper.loop(Looper.java:154)
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at android.app.ActivityThread.main(ActivityThread.java:6126)
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at java.lang.reflect.Method.invoke(Native Method)
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:886)
	03-07 18:09:43.199  3503  3503 E AndroidRuntime: 	at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:776)
	03-07 18:09:43.200   860  2059 I am_crash: [3503,0,com.android.settings,952647237,java.lang.NullPointerException,Attempt to write to field 'int android.app.Fragment.mNextAnim' on a null object reference,BackStackRecord.java,780]

Вообщем вот так у нас:

	03-07 18:10:15.300   860  2846 I ActivityManager: START u0 {cmp=com.android.settings/.fingerprint.FingerprintEnrollEnrolling (has extras)} from uid 1000 on display 0
		03-07 18:10:15.305   860  2846 I wm_task_moved: [9,1,0]
		03-07 18:10:15.306   860  2846 I am_create_activity: [0,69785865,9,com.android.settings/.fingerprint.FingerprintEnrollEnrolling,NULL,NULL,NULL,0]
		03-07 18:10:15.307   860  2846 I wm_task_moved: [9,1,0]
		03-07 18:10:15.309   860  2846 I am_focused_activity: [0,com.android.settings/.fingerprint.FingerprintEnrollEnrolling,startedActivity]
		03-07 18:10:15.309   860  2846 I am_pause_activity: [0,13670308,com.android.settings/.fingerprint.FingerprintEnrollEnrolling]
		

А вот так на стоке:

	03-07 13:52:47.952  1304  1809 I ActivityManager: START u0 {cmp=com.android.settings/.fingerprint.GnFingerprintEnrollEnrolling (has extras)} from uid 1000 from pid 5102 on display 0
	03-07 13:52:47.952  1304  1809 I am_home_stack_moved: [0,0,1,1,sourceStackToFront]
	03-07 13:52:47.953  1304  1809 I wm_task_moved: [40,1,0]
	03-07 13:52:47.954  1304  1809 I am_create_activity: [0,248188251,40,com.android.settings/.fingerprint.GnFingerprintEnrollEnrolling,NULL,NULL,NULL,0]
	

### Remote IR

remote_ctrl -> **/dev/remote_ctrl**

* system/lib64/hw/consumerir.default.so
* system/lib64/libsmartir_v_2_0_1.so (это по идее от приложения Peel, правда где оно там используется понять так и не удалось)
* system/bin/meta_tst (не забыть про запуск в init'ах)
* system/app/Peel/Peel.apk
* system/lib64/hw/remoteir.default.so
* system/lib/hw/remoteir.default.so


