#Highscreen Power Five Max

##Заметки

**За счет чего происходит шифрование userdata?**

Всего необходимо три компонента:

* libMcClient.so (по любому пути доступному в PATH или по которому загружаются либы, в recovery это может быть /sbin, в Android - /system/lib или /system/lib64)
* bin/mcDriverDaemon
* keystore.mt6755.so в /lib{,64}/hw

Далее в init'ах должно быть что-то вроде:

	on init
	    insmod /sec.ko
	    mknod /dev/sec c 182 0
	    chmod 0660 /dev/sec
	
	on fs
	#    write /proc/bootprof "start mobicore (on fs)"    
	#    chmod 0600 /dev/mobicore
	#    chown system system /dev/mobicore
	#    chmod 0666 /dev/mobicore-user
	#    chown system system /dev/mobicore-user
	#    # MobiCore Daemon Paths
	#    export MC_AUTH_TOKEN_PATH /efs
	#    start mobicore
	#    write /proc/bootprof "start mobicore end (on fs)"
	
	    write /proc/bootprof "start mobicore (on fs)"
	    mkdir /data/app/mcRegistry 0775 system system
	    mkdir /data/app/mcRegistry/TbStorage 0775 system system
	    chmod 0600 /dev/mobicore
	    chown system system /dev/mobicore
	    chmod 0666 /dev/mobicore-user
	    chown system system /dev/mobicore-user
	    chmod 0666 /dev/t-base-tui
	    chown system system /dev/t-base-tui
	    # MobiCore Daemon Paths
	#Gionee Huahy 20160519 GNDCR12466  begin
	    #export MC_AUTH_TOKEN_PATH /efs
	    export MC_AUTH_TOKEN_PATH /data/misc/gionee
	#Gionee Huahy 20160519 GNDCR12466 end
	    start mobicore
	    write /proc/bootprof "start mobicore end (on fs)"
	
	# Start Daemon (Registry directories should already be present)
	#service mobicore /system/bin/mcDriverDaemon -r /system/app/mcRegistry/020f0000000000000000000000000000.drbin -r /system/app/mcRegistry/05120000000000000000000000000000.drbin -r /system/app/mcRegistry/070b0000000000000000000000000000.drbin
	#        user system
	#        group system
	#        class core
	#        oneshot
	#	 disabled
	#        seclabel u:r:recovery:s0
	
	service mobicore /system/bin/mcDriverDaemon -r /system/app/mcRegistry/020f0000000000000000000000000000.drbin -r /system/app/mcRegistry/05120000000000000000000000000000.drbin -r /system/app/mcRegistry/070b0000000000000000000000000000.drbin -r /system/app/mcRegistry/020b0000000000000000000000000000.drbin -r /system/app/mcRegistry/030b0000000000000000000000000000.drbin -r /system/app/mcRegistry/5a7b770d08d14b8fb00f53de4173145a.drbin  -r /system/app/mcRegistry/05070000000000000000000000000000.drbin -r /system/app/mcRegistry/04020000000000000000000000000000.drbin
	    user system
	    group system
	    class core
	    oneshot
	    disabled
	    seclabel u:r:recovery:s0
	
	on property:ro.crypto.state=encrypted
	    start mobicore
	    
	    
Да, ну и конечно в /system/app/mcRegistry должны лежать соответствующие трастлеты со стока.

Для тех кому интересно на примере другого девайса можно почитать вот это - [Add support for encryption](https://github.com/chenxiaolong/DualBootPatcher/issues/126) .
	