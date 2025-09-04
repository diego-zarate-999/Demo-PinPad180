/*******************************************************************************
 * Copyright (C) 2019 Newland Payment Technology Co., Ltd All Rights Reserved
 ******************************************************************************/
#ifndef NAPI_SYSINFO_H
#define NAPI_SYSINFO_H

#ifdef __cplusplus
extern "C" {
#endif

#include "napi.h"

/** @addtogroup SysInfo
* @{
*/
typedef enum {
    ECR_MODE_NORMAL,
    ECR_MODE_SERVICE,
    ECR_MODE_END
}ECR_MODE;

/**
 *@brief Update boot logo
 *@details The logo only supports BMP images, and bit Depth: 16 or 24.\n
           The Size is [SP630/830]: 320 x 240 [SP930]:320 x 480 
 *@param[in] BMPFile    BMP file path
 *@return
 *@li \ref NAPI_OK "NAPI_OK"                        Success
 *@li \ref NAPI_ERR_OPEN_DEV "NAPI_ERR_OPEN_DEV"    Failed to open  checksum file
 *@li \ref NAPI_ERR_PARA "NAPI_ERR_PARA"            Invalid parameter
 *@li \ref NAPI_ERR_IOCTL "NAPI_ERR_IOCTL"          Failed to call driver function
 *@li \ref NAPI_ERR_OVERFLOW "NAPI_ERR_OVERFLOW"    Maximum number of errors
 *@li \ref NAPI_ERR_MALLOC "NAPI_ERR_MALLOC"        Out of memory
 *@li \ref NAPI_ALREADY_DONE "NAPI_ALREADY_DONE"    New logo`s checksum is the same to the checksum stored in flash partition.
 *@li \ref NAPI_ERR "NAPI_ERR"                      Fail
 */
 __EXPORTED_SYMBOL__
NAPI_ERR_CODE NAPI_SysUpdateBootLogo(char* BMPFile);


/**************************************** Deprecated ********************************************/

typedef enum {
    MODEL,       /**<Model*/
    SN,          /**<USN.*/
    OS_VERSION,  /**<OS version*/
    HW           /**<All hardware info*/
}SYS_INFO_ID;


/**
 *@brief  Get All hardware info of SP630/SP830/SP930\n
  HW[0]: Wireless module\n
    0xFF: No wireless module\n
    0x02: MC39\n
    0x03: SIM300\n
    0x06: M72\n
    0x07: BGS2\n
    0x08: G610\n
    Most significant byte 0x80 indicate CDMA module\n
    0x81: DTGS800\n
    0x82: DTM228c\n
  HW[1]: RF module\n
    0xFF: No RF module\n
    0x01: RC531\n
    0x02: PN512\n
  HW[2]: Magnetic card module\n
    0xFF: No magnetic card module\n
    0x01: Mesh\n
    0x02: Giga\n
  HW[3]: Barcode scanner module\n
    0xFF: No barcode scanner module\n
    0x01: EM1300\n
    0x02: EM3000\n
    0x03: SE955\n
  HW[4]: External PinPad support\n
    0xFF: NO\n
    0x01: YES\n
  HW[5]: Number of serial ports\n
    0xFF: No serial port\n
    0x01: 1\n
    0x02: 2\n
  HW[6]: USB support\n
    0xFF: NO\n
    0x01: YES\n
  HW[7]: Modem module\n
    0xFF: NO\n
    0x01: YES\n
  HW[8]: WiFi module\n
    0xFF: No wifi module\n
    0x01: "USI WM-G-MR-09"\n
  HW[9]: Ethernet support\n
    0xFF: NO\n
    0x01: dm9000\n
    0x02: bcm589x core\n
  HW[10]: Printer module\n
    0xFF: No printer module\n
    0x01~0x7F: Thermal printer\n
    0x82~0xFF: Dot matrix printer\n
  HW[11]: Touch screen support\n
    0xFF: NO\n
    0x01: ts_2046\n
    0x02: 589x_ts\n
  HW[12]: RF LED support\n
    0xFF: NO\n
    0x01: YES\n
  HW[13]: Bluetooth module\n
    0xFF: NO\n
    0x01: YES\n
  HW[14]: NFC module\n
    0xFF: NO\n
    0x01: YES\n
  HW[15]: Reserved\n
    0xFF: NO\n
    0x01: THK88\n
*/

/**
 *@deprecated replaced by \ref NAPI_SysGetProperty "NAPI_SysGetProperty"
 *@brief Send or Receive data
 *@param[in] InfoID     Infomation ID   (\ref SYS_INFO_ID "SYS_INFO_ID")
 *@param[in] OutBufLen  Length of buffer
 *@param[out] OutBuf    Buffer to save data returned (the recommended length  of buf  is 64)
 *@param[out] OutBufLen The length of OutBuf,  if the real length of sys info is more than OutBufLen , OutBuf will just get OutBufLen data.
                        Otherwise real length data will copy to the Outbuf,and real length will copy to  OutBufLen.
 *@return
  On success, it returns \ref NAPI_OK "NAPI_OK"; on error, it returns \ref NAPI_ERR_CODE "NAPI_ERR_CODE".
*/
__EXPORTED_SYMBOL__
NAPI_ERR_CODE NAPI_SysGetInfo(SYS_INFO_ID InfoID, char *OutBuf, int *OutBufLen);
/**
 *@deprecated No need to be called on the new firmware version
 *@brief Enable or disable system status bar(Only for Qt application)
 *@param[in] Enable Enable system status bar if Enable is true; otherwise disable system status bar
 *@return
  On success, it returns \ref NAPI_OK "NAPI_OK"; on error, it returns \ref NAPI_ERR_CODE "NAPI_ERR_CODE".
*/
 __EXPORTED_SYMBOL__
NAPI_ERR_CODE NAPI_QSysSetStatusbar(bool Enable);

/** @} */ // end of SysInfo

#ifdef __cplusplus
}
#endif

#endif

/* End of this file*/
