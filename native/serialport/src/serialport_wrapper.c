#include "napi_serialport.h"
#include "napi_sysinfo.h"

/** Exponer funciones del SDK tal cual, para Dart FFI */

// SysInfo
NAPI_ERR_CODE wrapper_SysGetInfo(int infoID, char *OutBuf, int *OutBufLen)
{
    return NAPI_SysGetInfo((SYS_INFO_ID)infoID, OutBuf, OutBufLen);
}

// Serial Port
NAPI_ERR_CODE wrapper_PortOpen(int portType, PORT_SETTINGS *settings)
{
    return NAPI_PortOpen((PORT_TYPE)portType, *settings);
}

NAPI_ERR_CODE wrapper_PortFlush(int portType)
{
    return NAPI_PortFlush((PORT_TYPE)portType);
}

NAPI_ERR_CODE wrapper_PortWrite(int portType, unsigned char *buf, int len)
{
    return NAPI_PortWrite((PORT_TYPE)portType, buf, len);
}

NAPI_ERR_CODE wrapper_PortReadLen(int portType, int *outLen)
{
    return NAPI_PortReadLen((PORT_TYPE)portType, outLen);
}

NAPI_ERR_CODE wrapper_PortRead(int portType, unsigned char *buf, int *bufLen, int timeout)
{
    return NAPI_PortRead((PORT_TYPE)portType, buf, bufLen, timeout);
}

NAPI_ERR_CODE wrapper_PortClose(int portType)
{
    return NAPI_PortClose((PORT_TYPE)portType);
}