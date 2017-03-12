### Описание проблемы с камерой

Как известно стоковый libcam.halsensor.so от Android 6.0 крашится в сборках Android 7.1.1 из-за различий версий компилятора и clang (возможно address sanitizer). Происходит это при заполнении структуры ACDK_SENSOR_RESOLUTION_INFO_STRUCT, которое осуществляется посредством вызова ioctl. Именно там и происходит повреждение памяти. Два lib'а который лежат в этой папке представляют собой пересобранный libcam.halsensor.so от MT6755 в котором getResolution заменена на "аналог" без вызова ioctl:

**imgsensor_drv.cpp**

	MINT32
	ImgSensorDrv::getResolution(
	    ACDK_SENSOR_RESOLUTION_INFO_STRUCT *pSensorResolution[2]
	)
	{
	    LOG_MSG("[Decker] Modified ImgSensorDrv::getResolution without ioctl call. ");
	    LOG_MSG("[getResolution] ACDK_SENSOR_RESOLUTION_INFO_STRUCT");
	    MINT32 err = SENSOR_NO_ERROR;
	#if 0
	    if (NULL == pSensorResolution) {
	        LOG_ERR("[getResolution] NULL pointer\n");
	        return SENSOR_UNKNOWN_ERROR;
	    }
	
	    ACDK_SENSOR_PRESOLUTION_STRUCT resolution = {{pSensorResolution[0], pSensorResolution[1]}};
	    LOG_WRN("pSensorResolution[0]:%p, [1]:%p\n", pSensorResolution[0], pSensorResolution[1]);
	    err = ioctl(m_fdSensor, KDIMGSENSORIOC_X_GETRESOLUTION2, &resolution);
	
	    LOG_MSG("[Decker] Sensor #0");
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorPreviewWidth = %d;",pSensorResolution[0]->SensorPreviewWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorPreviewHeight = %d;",pSensorResolution[0]->SensorPreviewHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorFullWidth = %d;",pSensorResolution[0]->SensorFullWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorFullHeight = %d;",pSensorResolution[0]->SensorFullHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorVideoWidth = %d;",pSensorResolution[0]->SensorVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorVideoHeight = %d;",pSensorResolution[0]->SensorVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorHighSpeedVideoWidth = %d;",pSensorResolution[0]->SensorHighSpeedVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorHighSpeedVideoHeight = %d;",pSensorResolution[0]->SensorHighSpeedVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorSlimVideoWidth = %d;",pSensorResolution[0]->SensorSlimVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorSlimVideoHeight = %d;",pSensorResolution[0]->SensorSlimVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom1Width = %d;",pSensorResolution[0]->SensorCustom1Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom1Height = %d;",pSensorResolution[0]->SensorCustom1Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom2Width = %d;",pSensorResolution[0]->SensorCustom2Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom2Height = %d;",pSensorResolution[0]->SensorCustom2Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom3Width = %d;",pSensorResolution[0]->SensorCustom3Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom3Height = %d;",pSensorResolution[0]->SensorCustom3Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom4Width = %d;",pSensorResolution[0]->SensorCustom4Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom4Height = %d;",pSensorResolution[0]->SensorCustom4Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom5Width = %d;",pSensorResolution[0]->SensorCustom5Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorCustom5Height = %d;",pSensorResolution[0]->SensorCustom5Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DPreviewWidth = %d;",pSensorResolution[0]->Sensor3DPreviewWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DPreviewHeight = %d;",pSensorResolution[0]->Sensor3DPreviewHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DFullWidth = %d;",pSensorResolution[0]->Sensor3DFullWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DFullHeight = %d;",pSensorResolution[0]->Sensor3DFullHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DVideoWidth = %d;",pSensorResolution[0]->Sensor3DVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DVideoHeight = %d;",pSensorResolution[0]->Sensor3DVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffectivePreviewWidth = %d;",pSensorResolution[0]->SensorEffectivePreviewWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffectivePreviewHeight = %d;",pSensorResolution[0]->SensorEffectivePreviewHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffectiveFullWidth = %d;",pSensorResolution[0]->SensorEffectiveFullWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffectiveFullHeight = %d;",pSensorResolution[0]->SensorEffectiveFullHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffectiveVideoWidth = %d;",pSensorResolution[0]->SensorEffectiveVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffectiveVideoHeight = %d;",pSensorResolution[0]->SensorEffectiveVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffectiveHighSpeedVideoWidth = %d;",pSensorResolution[0]->SensorEffectiveHighSpeedVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffectiveHighSpeedVideoHeight = %d;",pSensorResolution[0]->SensorEffectiveHighSpeedVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffective3DPreviewWidth = %d;",pSensorResolution[0]->SensorEffective3DPreviewWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffective3DPreviewHeight = %d;",pSensorResolution[0]->SensorEffective3DPreviewHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffective3DFullWidth = %d;",pSensorResolution[0]->SensorEffective3DFullWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffective3DFullHeight = %d;",pSensorResolution[0]->SensorEffective3DFullHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffective3DVideoWidth = %d;",pSensorResolution[0]->SensorEffective3DVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorEffective3DVideoHeight = %d;",pSensorResolution[0]->SensorEffective3DVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorPreviewWidthOffset = %d;",pSensorResolution[0]->SensorPreviewWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorPreviewHeightOffset = %d;",pSensorResolution[0]->SensorPreviewHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorFullWidthOffset = %d;",pSensorResolution[0]->SensorFullWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorFullHeightOffset = %d;",pSensorResolution[0]->SensorFullHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorVideoWidthOffset = %d;",pSensorResolution[0]->SensorVideoWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorVideoHeightOffset = %d;",pSensorResolution[0]->SensorVideoHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorHighSpeedVideoWidthOffset = %d;",pSensorResolution[0]->SensorHighSpeedVideoWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].SensorHighSpeedVideoHeightOffset = %d;",pSensorResolution[0]->SensorHighSpeedVideoHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DPreviewWidthOffset = %d;",pSensorResolution[0]->Sensor3DPreviewWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DPreviewHeightOffset = %d;",pSensorResolution[0]->Sensor3DPreviewHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DFullWidthOffset = %d;",pSensorResolution[0]->Sensor3DFullWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DFullHeightOffset = %d;",pSensorResolution[0]->Sensor3DFullHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DVideoWidthOffset = %d;",pSensorResolution[0]->Sensor3DVideoWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[0].Sensor3DVideoHeightOffset = %d;",pSensorResolution[0]->Sensor3DVideoHeightOffset);
	
	    LOG_MSG("[Decker] Sensor #1");
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorPreviewWidth = %d;",pSensorResolution[1]->SensorPreviewWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorPreviewHeight = %d;",pSensorResolution[1]->SensorPreviewHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorFullWidth = %d;",pSensorResolution[1]->SensorFullWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorFullHeight = %d;",pSensorResolution[1]->SensorFullHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorVideoWidth = %d;",pSensorResolution[1]->SensorVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorVideoHeight = %d;",pSensorResolution[1]->SensorVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorHighSpeedVideoWidth = %d;",pSensorResolution[1]->SensorHighSpeedVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorHighSpeedVideoHeight = %d;",pSensorResolution[1]->SensorHighSpeedVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorSlimVideoWidth = %d;",pSensorResolution[1]->SensorSlimVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorSlimVideoHeight = %d;",pSensorResolution[1]->SensorSlimVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom1Width = %d;",pSensorResolution[1]->SensorCustom1Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom1Height = %d;",pSensorResolution[1]->SensorCustom1Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom2Width = %d;",pSensorResolution[1]->SensorCustom2Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom2Height = %d;",pSensorResolution[1]->SensorCustom2Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom3Width = %d;",pSensorResolution[1]->SensorCustom3Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom3Height = %d;",pSensorResolution[1]->SensorCustom3Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom4Width = %d;",pSensorResolution[1]->SensorCustom4Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom4Height = %d;",pSensorResolution[1]->SensorCustom4Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom5Width = %d;",pSensorResolution[1]->SensorCustom5Width);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorCustom5Height = %d;",pSensorResolution[1]->SensorCustom5Height);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DPreviewWidth = %d;",pSensorResolution[1]->Sensor3DPreviewWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DPreviewHeight = %d;",pSensorResolution[1]->Sensor3DPreviewHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DFullWidth = %d;",pSensorResolution[1]->Sensor3DFullWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DFullHeight = %d;",pSensorResolution[1]->Sensor3DFullHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DVideoWidth = %d;",pSensorResolution[1]->Sensor3DVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DVideoHeight = %d;",pSensorResolution[1]->Sensor3DVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffectivePreviewWidth = %d;",pSensorResolution[1]->SensorEffectivePreviewWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffectivePreviewHeight = %d;",pSensorResolution[1]->SensorEffectivePreviewHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffectiveFullWidth = %d;",pSensorResolution[1]->SensorEffectiveFullWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffectiveFullHeight = %d;",pSensorResolution[1]->SensorEffectiveFullHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffectiveVideoWidth = %d;",pSensorResolution[1]->SensorEffectiveVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffectiveVideoHeight = %d;",pSensorResolution[1]->SensorEffectiveVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffectiveHighSpeedVideoWidth = %d;",pSensorResolution[1]->SensorEffectiveHighSpeedVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffectiveHighSpeedVideoHeight = %d;",pSensorResolution[1]->SensorEffectiveHighSpeedVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffective3DPreviewWidth = %d;",pSensorResolution[1]->SensorEffective3DPreviewWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffective3DPreviewHeight = %d;",pSensorResolution[1]->SensorEffective3DPreviewHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffective3DFullWidth = %d;",pSensorResolution[1]->SensorEffective3DFullWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffective3DFullHeight = %d;",pSensorResolution[1]->SensorEffective3DFullHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffective3DVideoWidth = %d;",pSensorResolution[1]->SensorEffective3DVideoWidth);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorEffective3DVideoHeight = %d;",pSensorResolution[1]->SensorEffective3DVideoHeight);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorPreviewWidthOffset = %d;",pSensorResolution[1]->SensorPreviewWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorPreviewHeightOffset = %d;",pSensorResolution[1]->SensorPreviewHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorFullWidthOffset = %d;",pSensorResolution[1]->SensorFullWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorFullHeightOffset = %d;",pSensorResolution[1]->SensorFullHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorVideoWidthOffset = %d;",pSensorResolution[1]->SensorVideoWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorVideoHeightOffset = %d;",pSensorResolution[1]->SensorVideoHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorHighSpeedVideoWidthOffset = %d;",pSensorResolution[1]->SensorHighSpeedVideoWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].SensorHighSpeedVideoHeightOffset = %d;",pSensorResolution[1]->SensorHighSpeedVideoHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DPreviewWidthOffset = %d;",pSensorResolution[1]->Sensor3DPreviewWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DPreviewHeightOffset = %d;",pSensorResolution[1]->Sensor3DPreviewHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DFullWidthOffset = %d;",pSensorResolution[1]->Sensor3DFullWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DFullHeightOffset = %d;",pSensorResolution[1]->Sensor3DFullHeightOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DVideoWidthOffset = %d;",pSensorResolution[1]->Sensor3DVideoWidthOffset);
	    LOG_MSG("[Decker] m_SenosrResInfo[1].Sensor3DVideoHeightOffset = %d;",pSensorResolution[1]->Sensor3DVideoHeightOffset);
	
	
	    if (err < 0) {
	        LOG_ERR("[getResolution] Err-ctrlCode (%s) \n", strerror(errno));
	        return -errno;
	    }
	#else
	m_SenosrResInfo[0].SensorPreviewWidth = 2100;
	m_SenosrResInfo[0].SensorPreviewHeight = 1560;
	m_SenosrResInfo[0].SensorFullWidth = 4208;
	m_SenosrResInfo[0].SensorFullHeight = 3120;
	m_SenosrResInfo[0].SensorVideoWidth = 2100;
	m_SenosrResInfo[0].SensorVideoHeight = 1560;
	m_SenosrResInfo[0].SensorHighSpeedVideoWidth = 1920;
	m_SenosrResInfo[0].SensorHighSpeedVideoHeight = 1080;
	m_SenosrResInfo[0].SensorSlimVideoWidth = 2100;
	m_SenosrResInfo[0].SensorSlimVideoHeight = 1560;
	m_SenosrResInfo[0].SensorCustom1Width = 0;
	m_SenosrResInfo[0].SensorCustom1Height = 0;
	m_SenosrResInfo[0].SensorCustom2Width = 0;
	m_SenosrResInfo[0].SensorCustom2Height = 0;
	m_SenosrResInfo[0].SensorCustom3Width = 0;
	m_SenosrResInfo[0].SensorCustom3Height = 0;
	m_SenosrResInfo[0].SensorCustom4Width = 0;
	m_SenosrResInfo[0].SensorCustom4Height = 0;
	m_SenosrResInfo[0].SensorCustom5Width = 0;
	m_SenosrResInfo[0].SensorCustom5Height = 0;
	m_SenosrResInfo[0].Sensor3DPreviewWidth = 0;
	m_SenosrResInfo[0].Sensor3DPreviewHeight = 0;
	m_SenosrResInfo[0].Sensor3DFullWidth = 0;
	m_SenosrResInfo[0].Sensor3DFullHeight = 0;
	m_SenosrResInfo[0].Sensor3DVideoWidth = 0;
	m_SenosrResInfo[0].Sensor3DVideoHeight = 0;
	m_SenosrResInfo[0].SensorEffectivePreviewWidth = 0;
	m_SenosrResInfo[0].SensorEffectivePreviewHeight = 0;
	m_SenosrResInfo[0].SensorEffectiveFullWidth = 0;
	m_SenosrResInfo[0].SensorEffectiveFullHeight = 0;
	m_SenosrResInfo[0].SensorEffectiveVideoWidth = 0;
	m_SenosrResInfo[0].SensorEffectiveVideoHeight = 0;
	m_SenosrResInfo[0].SensorEffectiveHighSpeedVideoWidth = 0;
	m_SenosrResInfo[0].SensorEffectiveHighSpeedVideoHeight = 0;
	m_SenosrResInfo[0].SensorEffective3DPreviewWidth = 0;
	m_SenosrResInfo[0].SensorEffective3DPreviewHeight = 0;
	m_SenosrResInfo[0].SensorEffective3DFullWidth = 0;
	m_SenosrResInfo[0].SensorEffective3DFullHeight = 0;
	m_SenosrResInfo[0].SensorEffective3DVideoWidth = 0;
	m_SenosrResInfo[0].SensorEffective3DVideoHeight = 0;
	m_SenosrResInfo[0].SensorPreviewWidthOffset = 0;
	m_SenosrResInfo[0].SensorPreviewHeightOffset = 0;
	m_SenosrResInfo[0].SensorFullWidthOffset = 0;
	m_SenosrResInfo[0].SensorFullHeightOffset = 0;
	m_SenosrResInfo[0].SensorVideoWidthOffset = 0;
	m_SenosrResInfo[0].SensorVideoHeightOffset = 0;
	m_SenosrResInfo[0].SensorHighSpeedVideoWidthOffset = 0;
	m_SenosrResInfo[0].SensorHighSpeedVideoHeightOffset = 0;
	m_SenosrResInfo[0].Sensor3DPreviewWidthOffset = 0;
	m_SenosrResInfo[0].Sensor3DPreviewHeightOffset = 0;
	m_SenosrResInfo[0].Sensor3DFullWidthOffset = 0;
	m_SenosrResInfo[0].Sensor3DFullHeightOffset = 0;
	m_SenosrResInfo[0].Sensor3DVideoWidthOffset = 0;
	m_SenosrResInfo[0].Sensor3DVideoHeightOffset = 0;
	
	m_SenosrResInfo[1].SensorPreviewWidth = 1632;
	m_SenosrResInfo[1].SensorPreviewHeight = 1224;
	m_SenosrResInfo[1].SensorFullWidth = 3264;
	m_SenosrResInfo[1].SensorFullHeight = 2448;
	m_SenosrResInfo[1].SensorVideoWidth = 3264;
	m_SenosrResInfo[1].SensorVideoHeight = 2448;
	m_SenosrResInfo[1].SensorHighSpeedVideoWidth = 640;
	m_SenosrResInfo[1].SensorHighSpeedVideoHeight = 480;
	m_SenosrResInfo[1].SensorSlimVideoWidth = 1632;
	m_SenosrResInfo[1].SensorSlimVideoHeight = 1224;
	m_SenosrResInfo[1].SensorCustom1Width = 0;
	m_SenosrResInfo[1].SensorCustom1Height = 0;
	m_SenosrResInfo[1].SensorCustom2Width = 0;
	m_SenosrResInfo[1].SensorCustom2Height = 0;
	m_SenosrResInfo[1].SensorCustom3Width = 0;
	m_SenosrResInfo[1].SensorCustom3Height = 0;
	m_SenosrResInfo[1].SensorCustom4Width = 0;
	m_SenosrResInfo[1].SensorCustom4Height = 0;
	m_SenosrResInfo[1].SensorCustom5Width = 0;
	m_SenosrResInfo[1].SensorCustom5Height = 0;
	m_SenosrResInfo[1].Sensor3DPreviewWidth = 0;
	m_SenosrResInfo[1].Sensor3DPreviewHeight = 0;
	m_SenosrResInfo[1].Sensor3DFullWidth = 0;
	m_SenosrResInfo[1].Sensor3DFullHeight = 0;
	m_SenosrResInfo[1].Sensor3DVideoWidth = 0;
	m_SenosrResInfo[1].Sensor3DVideoHeight = 0;
	m_SenosrResInfo[1].SensorEffectivePreviewWidth = 0;
	m_SenosrResInfo[1].SensorEffectivePreviewHeight = 0;
	m_SenosrResInfo[1].SensorEffectiveFullWidth = 0;
	m_SenosrResInfo[1].SensorEffectiveFullHeight = 0;
	m_SenosrResInfo[1].SensorEffectiveVideoWidth = 0;
	m_SenosrResInfo[1].SensorEffectiveVideoHeight = 0;
	m_SenosrResInfo[1].SensorEffectiveHighSpeedVideoWidth = 0;
	m_SenosrResInfo[1].SensorEffectiveHighSpeedVideoHeight = 0;
	m_SenosrResInfo[1].SensorEffective3DPreviewWidth = 0;
	m_SenosrResInfo[1].SensorEffective3DPreviewHeight = 0;
	m_SenosrResInfo[1].SensorEffective3DFullWidth = 0;
	m_SenosrResInfo[1].SensorEffective3DFullHeight = 0;
	m_SenosrResInfo[1].SensorEffective3DVideoWidth = 0;
	m_SenosrResInfo[1].SensorEffective3DVideoHeight = 0;
	m_SenosrResInfo[1].SensorPreviewWidthOffset = 0;
	m_SenosrResInfo[1].SensorPreviewHeightOffset = 0;
	m_SenosrResInfo[1].SensorFullWidthOffset = 0;
	m_SenosrResInfo[1].SensorFullHeightOffset = 0;
	m_SenosrResInfo[1].SensorVideoWidthOffset = 0;
	m_SenosrResInfo[1].SensorVideoHeightOffset = 0;
	m_SenosrResInfo[1].SensorHighSpeedVideoWidthOffset = 0;
	m_SenosrResInfo[1].SensorHighSpeedVideoHeightOffset = 0;
	m_SenosrResInfo[1].Sensor3DPreviewWidthOffset = 0;
	m_SenosrResInfo[1].Sensor3DPreviewHeightOffset = 0;
	m_SenosrResInfo[1].Sensor3DFullWidthOffset = 0;
	m_SenosrResInfo[1].Sensor3DFullHeightOffset = 0;
	m_SenosrResInfo[1].Sensor3DVideoWidthOffset = 0;
	m_SenosrResInfo[1].Sensor3DVideoHeightOffset = 0;
	#endif
	    return err;
	}//halSensorGetResolution

Параметры m_SenosrResInfo 0 и 1 взяты с работающего девайса. 

Более подробные описания структур:

alps/device/mediatek/common/kernel-headers/ 

**kd_imgsensor_define.h**

	typedef struct {
		MUINT16 SensorPreviewWidth;
		MUINT16 SensorPreviewHeight;
		MUINT16 SensorFullWidth;
		MUINT16 SensorFullHeight;
		MUINT16 SensorVideoWidth;
		MUINT16 SensorVideoHeight;
		MUINT16 SensorHighSpeedVideoWidth;
		MUINT16 SensorHighSpeedVideoHeight;
		MUINT16 SensorSlimVideoWidth;
		MUINT16 SensorSlimVideoHeight;
		MUINT16 SensorCustom1Width;
		MUINT16 SensorCustom1Height;
		MUINT16 SensorCustom2Width;
		MUINT16 SensorCustom2Height;
		MUINT16 SensorCustom3Width;
		MUINT16 SensorCustom3Height;
		MUINT16 SensorCustom4Width;
		MUINT16 SensorCustom4Height;
		MUINT16 SensorCustom5Width;
		MUINT16 SensorCustom5Height;
		MUINT16 Sensor3DPreviewWidth;
		MUINT16 Sensor3DPreviewHeight;
		MUINT16 Sensor3DFullWidth;
		MUINT16 Sensor3DFullHeight;
		MUINT16 Sensor3DVideoWidth;
		MUINT16 Sensor3DVideoHeight;
		MUINT16 SensorEffectivePreviewWidth;
		MUINT16 SensorEffectivePreviewHeight;
		MUINT16 SensorEffectiveFullWidth;
		MUINT16 SensorEffectiveFullHeight;
		MUINT16 SensorEffectiveVideoWidth;
		MUINT16 SensorEffectiveVideoHeight;
		MUINT16 SensorEffectiveHighSpeedVideoWidth;
		MUINT16 SensorEffectiveHighSpeedVideoHeight;
		MUINT16 SensorEffective3DPreviewWidth;
		MUINT16 SensorEffective3DPreviewHeight;
		MUINT16 SensorEffective3DFullWidth;
		MUINT16 SensorEffective3DFullHeight;
		MUINT16 SensorEffective3DVideoWidth;
		MUINT16 SensorEffective3DVideoHeight;
		MUINT16 SensorPreviewWidthOffset;   /* from effective width to output width */
		MUINT16 SensorPreviewHeightOffset;  /* from effective height to output height */
		MUINT16 SensorFullWidthOffset;  /* from effective width to output width */
		MUINT16 SensorFullHeightOffset; /* from effective height to output height */
		MUINT16 SensorVideoWidthOffset; /* from effective width to output width */
		MUINT16 SensorVideoHeightOffset;    /* from effective height to output height */
		MUINT16 SensorHighSpeedVideoWidthOffset;    /* from effective width to output width */
		MUINT16 SensorHighSpeedVideoHeightOffset;   /* from effective height to output height */
		MUINT16 Sensor3DPreviewWidthOffset; /* from effective width to output width */
		MUINT16 Sensor3DPreviewHeightOffset;    /* from effective height to output height */
		MUINT16 Sensor3DFullWidthOffset;    /* from effective width to output width */
		MUINT16 Sensor3DFullHeightOffset;   /* from effective height to output height */
		MUINT16 Sensor3DVideoWidthOffset;   /* from effective width to output width */
		MUINT16 Sensor3DVideoHeightOffset;  /* from effective height to output height */
	} ACDK_SENSOR_RESOLUTION_INFO_STRUCT, *PACDK_SENSOR_RESOLUTION_INFO_STRUCT;
	
	
	typedef struct {
		MUINT16 SensorPreviewResolutionX;
		MUINT16 SensorPreviewResolutionY;
		MUINT16 SensorFullResolutionX;
		MUINT16 SensorFullResolutionY;
		MUINT8 SensorClockFreq; /* MHz */
		MUINT8 SensorCameraPreviewFrameRate;
		MUINT8 SensorVideoFrameRate;
		MUINT8 SensorStillCaptureFrameRate;
		MUINT8 SensorWebCamCaptureFrameRate;
		MUINT8 SensorClockPolarity; /* SENSOR_CLOCK_POLARITY_HIGH/SENSOR_CLOCK_POLARITY_Low */
		MUINT8 SensorClockFallingPolarity;
		MUINT8 SensorClockRisingCount;  /* 0..15 */
		MUINT8 SensorClockFallingCount; /* 0..15 */
		MUINT8 SensorClockDividCount;   /* 0..15 */
		MUINT8 SensorPixelClockCount;   /* 0..15 */
		MUINT8 SensorDataLatchCount;    /* 0..15 */
		MUINT8 SensorHsyncPolarity;
		MUINT8 SensorVsyncPolarity;
		MUINT8 SensorInterruptDelayLines;
		MINT32 SensorResetActiveHigh;
		MUINT32 SensorResetDelayCount;
		ACDK_SENSOR_INTERFACE_TYPE_ENUM SensroInterfaceType;
		ACDK_SENSOR_OUTPUT_DATA_FORMAT_ENUM SensorOutputDataFormat;
		ACDK_SENSOR_MIPI_LANE_NUMBER_ENUM SensorMIPILaneNumber;
		MUINT32 CaptureDelayFrame;
		MUINT32 PreviewDelayFrame;
		MUINT32 VideoDelayFrame;
		MUINT32 HighSpeedVideoDelayFrame;
		MUINT32 SlimVideoDelayFrame;
		MUINT32 YUVAwbDelayFrame;
		MUINT32 YUVEffectDelayFrame;
		MUINT32 Custom1DelayFrame;
		MUINT32 Custom2DelayFrame;
		MUINT32 Custom3DelayFrame;
		MUINT32 Custom4DelayFrame;
		MUINT32 Custom5DelayFrame;
		MUINT16 SensorGrabStartX;
		MUINT16 SensorGrabStartY;
		MUINT16 SensorDrivingCurrent;
		MUINT8 SensorMasterClockSwitch;
		MUINT8 AEShutDelayFrame;    /* The frame of setting shutter default 0 for TG int */
		MUINT8 AESensorGainDelayFrame;  /* The frame of setting sensor gain */
		MUINT8 AEISPGainDelayFrame;
		MUINT8 MIPIDataLowPwr2HighSpeedTermDelayCount;
		MUINT8 MIPIDataLowPwr2HighSpeedSettleDelayCount;
		MUINT8 MIPICLKLowPwr2HighSpeedTermDelayCount;
		MUINT8 SensorWidthSampling;
		MUINT8 SensorHightSampling;
		MUINT8 SensorPacketECCOrder;
		SENSOR_MIPI_TYPE_ENUM MIPIsensorType;
		MUINT8 SensorCaptureOutputJPEG; /* JPEG file or not? */
		MUINT8 SensorModeNum;
		MUINT8 IHDR_Support;
		MUINT16 IHDR_LE_FirstLine;
		MUINT8 ZHDR_Mode;
		SENSOR_SETTLEDELAY_MODE_ENUM SettleDelayMode;
		MUINT8 PDAF_Support;
		MUINT8 DPCM_INFO;
		MUINT8 PerFrameCTL_Support;
		SENSOR_SCAM_DATA_CHANNEL_ENUM SCAM_DataNumber;
		MUINT8 SCAM_DDR_En;
		MUINT8 SCAM_CLK_INV;
		MUINT8 SCAM_DEFAULT_DELAY;
		MUINT8 SCAM_CRC_En;
		MUINT8 SCAM_SOF_src;
		MUINT32 SCAM_Timout_Cali;
		MUINT32 SensorMIPIDeskew;
	} ACDK_SENSOR_INFO_STRUCT, *PACDK_SENSOR_INFO_STRUCT;
	
alps/vendor/mediatek/proprietary/hardware/mtkcam/legacy/platform/mt6755/hal/sensor/

**imgsensor_drv.cpp **

	MINT32
	ImgSensorDrv::getResolution(
	    ACDK_SENSOR_RESOLUTION_INFO_STRUCT *pSensorResolution[2]
	)
	{
	    LOG_MSG("[getResolution] ACDK_SENSOR_RESOLUTION_INFO_STRUCT");
	    MINT32 err = SENSOR_NO_ERROR;
	    if (NULL == pSensorResolution) {
	        LOG_ERR("[getResolution] NULL pointer\n");
	        return SENSOR_UNKNOWN_ERROR;
	    }
	
	    ACDK_SENSOR_PRESOLUTION_STRUCT resolution = {{pSensorResolution[0], pSensorResolution[1]}};
	    LOG_WRN("pSensorResolution[0]:%p, [1]:%p\n", pSensorResolution[0], pSensorResolution[1]);
	    err = ioctl(m_fdSensor, KDIMGSENSORIOC_X_GETRESOLUTION2, &resolution);
	
	    if (err < 0) {
	        LOG_ERR("[getResolution] Err-ctrlCode (%s) \n", strerror(errno));
	        return -errno;
	    }
	
	    return err;
	}//halSensorGetResolution
	
###Параметры сенсоров из Highscreen Power Five Max:

	Sensor #0
	m_SenosrResInfo[0].SensorPreviewWidth = 2100;
	m_SenosrResInfo[0].SensorPreviewHeight = 1560;
	m_SenosrResInfo[0].SensorFullWidth = 4208;
	m_SenosrResInfo[0].SensorFullHeight = 3120;
	m_SenosrResInfo[0].SensorVideoWidth = 2100;
	m_SenosrResInfo[0].SensorVideoHeight = 1560;
	m_SenosrResInfo[0].SensorHighSpeedVideoWidth = 1920;
	m_SenosrResInfo[0].SensorHighSpeedVideoHeight = 1080;
	m_SenosrResInfo[0].SensorSlimVideoWidth = 2100;
	m_SenosrResInfo[0].SensorSlimVideoHeight = 1560;
	m_SenosrResInfo[0].SensorCustom1Width = 0;
	m_SenosrResInfo[0].SensorCustom1Height = 0;
	m_SenosrResInfo[0].SensorCustom2Width = 0;
	m_SenosrResInfo[0].SensorCustom2Height = 0;
	m_SenosrResInfo[0].SensorCustom3Width = 0;
	m_SenosrResInfo[0].SensorCustom3Height = 0;
	m_SenosrResInfo[0].SensorCustom4Width = 0;
	m_SenosrResInfo[0].SensorCustom4Height = 0;
	m_SenosrResInfo[0].SensorCustom5Width = 0;
	m_SenosrResInfo[0].SensorCustom5Height = 0;
	m_SenosrResInfo[0].Sensor3DPreviewWidth = 0;
	m_SenosrResInfo[0].Sensor3DPreviewHeight = 0;
	m_SenosrResInfo[0].Sensor3DFullWidth = 0;
	m_SenosrResInfo[0].Sensor3DFullHeight = 0;
	m_SenosrResInfo[0].Sensor3DVideoWidth = 0;
	m_SenosrResInfo[0].Sensor3DVideoHeight = 0;
	m_SenosrResInfo[0].SensorEffectivePreviewWidth = 0;
	m_SenosrResInfo[0].SensorEffectivePreviewHeight = 0;
	m_SenosrResInfo[0].SensorEffectiveFullWidth = 0;
	m_SenosrResInfo[0].SensorEffectiveFullHeight = 0;
	m_SenosrResInfo[0].SensorEffectiveVideoWidth = 0;
	m_SenosrResInfo[0].SensorEffectiveVideoHeight = 0;
	m_SenosrResInfo[0].SensorEffectiveHighSpeedVideoWidth = 0;
	m_SenosrResInfo[0].SensorEffectiveHighSpeedVideoHeight = 0;
	m_SenosrResInfo[0].SensorEffective3DPreviewWidth = 0;
	m_SenosrResInfo[0].SensorEffective3DPreviewHeight = 0;
	m_SenosrResInfo[0].SensorEffective3DFullWidth = 0;
	m_SenosrResInfo[0].SensorEffective3DFullHeight = 0;
	m_SenosrResInfo[0].SensorEffective3DVideoWidth = 0;
	m_SenosrResInfo[0].SensorEffective3DVideoHeight = 0;
	m_SenosrResInfo[0].SensorPreviewWidthOffset = 0;
	m_SenosrResInfo[0].SensorPreviewHeightOffset = 0;
	m_SenosrResInfo[0].SensorFullWidthOffset = 0;
	m_SenosrResInfo[0].SensorFullHeightOffset = 0;
	m_SenosrResInfo[0].SensorVideoWidthOffset = 0;
	m_SenosrResInfo[0].SensorVideoHeightOffset = 0;
	m_SenosrResInfo[0].SensorHighSpeedVideoWidthOffset = 0;
	m_SenosrResInfo[0].SensorHighSpeedVideoHeightOffset = 0;
	m_SenosrResInfo[0].Sensor3DPreviewWidthOffset = 0;
	m_SenosrResInfo[0].Sensor3DPreviewHeightOffset = 0;
	m_SenosrResInfo[0].Sensor3DFullWidthOffset = 0;
	m_SenosrResInfo[0].Sensor3DFullHeightOffset = 0;
	m_SenosrResInfo[0].Sensor3DVideoWidthOffset = 0;
	m_SenosrResInfo[0].Sensor3DVideoHeightOffset = 0;
	Sensor #1
	m_SenosrResInfo[1].SensorPreviewWidth = 1632;
	m_SenosrResInfo[1].SensorPreviewHeight = 1224;
	m_SenosrResInfo[1].SensorFullWidth = 3264;
	m_SenosrResInfo[1].SensorFullHeight = 2448;
	m_SenosrResInfo[1].SensorVideoWidth = 3264;
	m_SenosrResInfo[1].SensorVideoHeight = 2448;
	m_SenosrResInfo[1].SensorHighSpeedVideoWidth = 640;
	m_SenosrResInfo[1].SensorHighSpeedVideoHeight = 480;
	m_SenosrResInfo[1].SensorSlimVideoWidth = 1632;
	m_SenosrResInfo[1].SensorSlimVideoHeight = 1224;
	m_SenosrResInfo[1].SensorCustom1Width = 0;
	m_SenosrResInfo[1].SensorCustom1Height = 0;
	m_SenosrResInfo[1].SensorCustom2Width = 0;
	m_SenosrResInfo[1].SensorCustom2Height = 0;
	m_SenosrResInfo[1].SensorCustom3Width = 0;
	m_SenosrResInfo[1].SensorCustom3Height = 0;
	m_SenosrResInfo[1].SensorCustom4Width = 0;
	m_SenosrResInfo[1].SensorCustom4Height = 0;
	m_SenosrResInfo[1].SensorCustom5Width = 0;
	m_SenosrResInfo[1].SensorCustom5Height = 0;
	m_SenosrResInfo[1].Sensor3DPreviewWidth = 0;
	m_SenosrResInfo[1].Sensor3DPreviewHeight = 0;
	m_SenosrResInfo[1].Sensor3DFullWidth = 0;
	m_SenosrResInfo[1].Sensor3DFullHeight = 0;
	m_SenosrResInfo[1].Sensor3DVideoWidth = 0;
	m_SenosrResInfo[1].Sensor3DVideoHeight = 0;
	m_SenosrResInfo[1].SensorEffectivePreviewWidth = 0;
	m_SenosrResInfo[1].SensorEffectivePreviewHeight = 0;
	m_SenosrResInfo[1].SensorEffectiveFullWidth = 0;
	m_SenosrResInfo[1].SensorEffectiveFullHeight = 0;
	m_SenosrResInfo[1].SensorEffectiveVideoWidth = 0;
	m_SenosrResInfo[1].SensorEffectiveVideoHeight = 0;
	m_SenosrResInfo[1].SensorEffectiveHighSpeedVideoWidth = 0;
	m_SenosrResInfo[1].SensorEffectiveHighSpeedVideoHeight = 0;
	m_SenosrResInfo[1].SensorEffective3DPreviewWidth = 0;
	m_SenosrResInfo[1].SensorEffective3DPreviewHeight = 0;
	m_SenosrResInfo[1].SensorEffective3DFullWidth = 0;
	m_SenosrResInfo[1].SensorEffective3DFullHeight = 0;
	m_SenosrResInfo[1].SensorEffective3DVideoWidth = 0;
	m_SenosrResInfo[1].SensorEffective3DVideoHeight = 0;
	m_SenosrResInfo[1].SensorPreviewWidthOffset = 0;
	m_SenosrResInfo[1].SensorPreviewHeightOffset = 0;
	m_SenosrResInfo[1].SensorFullWidthOffset = 0;
	m_SenosrResInfo[1].SensorFullHeightOffset = 0;
	m_SenosrResInfo[1].SensorVideoWidthOffset = 0;
	m_SenosrResInfo[1].SensorVideoHeightOffset = 0;
	m_SenosrResInfo[1].SensorHighSpeedVideoWidthOffset = 0;
	m_SenosrResInfo[1].SensorHighSpeedVideoHeightOffset = 0;
	m_SenosrResInfo[1].Sensor3DPreviewWidthOffset = 0;
	m_SenosrResInfo[1].Sensor3DPreviewHeightOffset = 0;
	m_SenosrResInfo[1].Sensor3DFullWidthOffset = 0;
	m_SenosrResInfo[1].Sensor3DFullHeightOffset = 0;
	m_SenosrResInfo[1].Sensor3DVideoWidthOffset = 0;
	m_SenosrResInfo[1].Sensor3DVideoHeightOffset = 0;
 	
