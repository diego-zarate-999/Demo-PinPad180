#ifndef SERIAL_WRAPPER_H
#define SERIAL_WRAPPER_H

#include "napi_serialport.h"
#include "napi_sysinfo.h"

#ifdef __cplusplus
extern "C"
{
#endif

    // SysInfo
    NAPI_ERR_CODE wrapper_SysGetInfo(int infoID, char *OutBuf, int *OutBufLen);

    // Serial Port
    NAPI_ERR_CODE wrapper_PortOpen(int portType, PORT_SETTINGS *settings);
    NAPI_ERR_CODE wrapper_PortFlush(int portType);
    NAPI_ERR_CODE wrapper_PortWrite(int portType, unsigned char *buf, int len);
    NAPI_ERR_CODE wrapper_PortReadLen(int portType, int *outLen);
    NAPI_ERR_CODE wrapper_PortRead(int portType, unsigned char *buf, int *bufLen, int timeout);
    NAPI_ERR_CODE wrapper_PortClose(int portType);

#ifdef __cplusplus
}
#endif

#endif
