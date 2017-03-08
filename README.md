(c) Decker, http://www.decker.su

# Highscreen Power Five Max

![](https://3.bp.blogspot.com/-beayt9o83QA/WKoDpc1PFoI/AAAAAAAAL-U/8NskvXvUNtI6ONDwmmB8jCojRD_XqGn6wCLcB/s1600/lineage_os_decker_su_478x269.jpg) 

Дерево для сборки LineageOS 14.1 для Highscreen Power Five Max.

Basic   | Spec Sheet
-------:|:-------------------------
Операционная система|Android 6.0.1 Marshmallow
Дисплей |5,5 дюйма, Full HD емкостный, поддержка мультитач (5 одновременных касаний). Разрешение 1920х1080 точек Super AMOLED с защищенным стеклом Corning Gorilla Glass 3 (2.5D). Плотность пикселей: 403 DPI.
Процессор| MediaTek MT6755 (Helio P10) 8 ядер 64 бита Cortex-A53 с частотой 4х1,1ГГц; 4х1,95ГГц, технология CorePilot. 28Нм HPC+ техпроцесс. 2х-ядерный 64-битный графический чип Mali-T860MP2, работающий на частоте 700 МГц с поддержкой OpenGL® ES 1.2, 1.1, 2.0, 3.1, DirectX® 11 FL11_1, RenderScript™
Оперативная память| 4 ГБ LPDDR3 с тактовой частотой 933МГц 7.4GB/s.
Встроенная память |64 ГБ, слот microSD до 128Гб (совместимо с SDHC)
Фронтальная камера| 8 Мп Omnivision OV8856 1/4 дюйма, размер пикселя 1,12 мкм, 4х линзовая оптика.
Основная камера| 13 МП (Sony IMX258) основная: автофокус, двойная светодиодная вспышка, содержит 5 линз из композитного материала.
Коммуникации| Wi-Fi 802.11a/b/g/n/ac (2.4/5 ГГц); Bluetooth 4.0+EDR (A2DP/HID/PB/AP), FM радио.
Сети| модем LTE Cat 6, загрузка данных со скоростью до 300 Мб/с и отдача до 50 Мб/с. Поддержка VoLTE. GSM 850/900/1800/1900, WCDMA: 900/2100, 4G LTE: Band 3/7/8/20, LTE TDD: Band 38/39/40/41,  Поддержка двух SIM-карт (Dual SIM Dual Standby) 1 радиомодуль.
Удельный коэффициент| SAR: 1,40 W/kg (для головы)- ПОДРОБНЕЕ
Датчики |Датчик ускорения (акселерометр), гироскоп, датчик приближения, датчик освещенности, магнитного поля, ориентации (компас), сканер отпечатков пальцев в физической кнопке "Домой", ИК порт для управления бытовой техникой.
Индикатор событий| есть, многоцветный светодиод.
Мультимедиа | 1 мультимедиадинамик, микрофон для шумоподавления. Hi-Fi аудиочип 110 дБ SNR (сигнал/шум) и -95дБ THD + настройки эквалайзера от DTS. 3.5 мм разъем для наушников.
Навигация |GPS, A-GPS, Glonass.
Аккумулятор |5000 мАч литий-полимерный (Технология быстрой зарядки Mediatek Pump Express Plus 5V-2А/7V-1.8A/9V-1.8A/12V-1.3A)
Габариты| 152 x 75,4 x 8,2 мм
Вес|  180 г
Комплектация| Смартфон, блок питания со съёмным кабелем, руководство пользователя, OTG кабель, гарнитура, прозрачный пластиковый чехол, защитная плёнка, гарантийный талон.


В дереве две ветки, lineageos-13.0 временно не поддерживается, основная работа ведется в ветке **master**, которая предназначена для сборки LineageOS 14.1 (Android 7.1.1).

На данный момент в сборке прошивки работает:

* RIL (связь)
* WiFi (в списке сетей присутствует сеть с названием NVRAM WARNING: Err = 0x10, ошибка скорее всего будет исправлена, но пока так)
* Bluetooth
* Камера (включая и **запись видео** с камеры)
* Аппаратные OMX кодеки (правда с временной проблемой с цветовым профилем при проигрывании видео в приложении YouTube)
* Звук (!)
* Вибрация аппаратных кнопок
* Полное **аппаратное шифрование раздела userdata**. Т.е. можно зашифровать данные устройства, установить запрос PIN-кода на загрузку и все это будет работать.
* Запись звука с микрофона и screencast в приложении "Рекордер".
* Светодиод индикации
* Фонарик / вспышка
* Remote IR (инфракрасный пульт управления)
* Датчик шагов
* Полностью рабочий **сканер отпечатков от Goodix** (на то чтобы заставить его работать ушло несколько суток напряженной работы). Кстати, сенсор здесь **Goodix GF518M**, увидеть это можно сделав find / -name "*gf*" и обнаружив следующие файлы /sys/bus/platform/devices/goodix_gf518m и /sys/devices/goodix_gf518m. 
* **FM Radio**
* GPS (огромное спасибо [danielhk](https://github.com/danielhk)  за его код GPS HAL)

Пока не работает:

* GPS 
* Возможно что-то еще ... 

Работы над прошивкой ведутся.

При использовании любых материалов из этого дерева, а также при посте линка на него на других ресурсах **обязательны** две ссылки:

* https://www.decker.su/ - первоисточник (Decker'S Blog)
* http://donate.decker.su/ - поддержка проекта.

Уважайте труд других, на разработку этого дерева было потрачено много бессонных ночей!