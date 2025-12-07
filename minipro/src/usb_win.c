/*
 * usb.c - Low level USB functions windows implementation.
 *
 * This file is a part of Minipro.
 *
 * Minipro is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Minipro is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include <setupapi.h>
#include <winusb.h>
#include "usb.h"

#define TL866A_IOCTL_READ  0x222004
#define TL866A_IOCTL_WRITE 0x222000
#define MP_USBTIMEOUT	   5000
#define USB_ENDPOINT_OUT   0x00
#define USB_ENDPOINT_IN	   0x80
#define MP_TL866IIPLUS	   5
#define MP_T56					   6
#define MP_T48					   7
#define MP_TL866A	   2

#define TL866A_GUID                                                    \
	{                                                              \
		0x85980D83, 0x32B9, 0x4BA1,                            \
		{                                                      \
			0x8F, 0xDF, 0x12, 0xA7, 0x11, 0xB9, 0x9C, 0xA2 \
		}                                                      \
	}
#define TL866IIPLUS_GUID                                               \
	{                                                              \
		0xE7E8BA13, 0x2A81, 0x446E,                            \
		{                                                      \
			0xA1, 0x1E, 0x72, 0x39, 0x8F, 0xBD, 0xA8, 0x2F \
		}                                                      \
	}

/* Internaly used functions prototypes */
static int search_devices(uint8_t, char **);
static int usb_write(void *, uint8_t *, size_t, uint8_t);
static int usb_read(void *, uint8_t *, size_t, uint8_t);
static int payload_transfer(void *, uint8_t, uint8_t *, size_t, uint8_t *,
			    size_t);

/* Opaque structure used externally as handle */
typedef struct usb_handle {
	HANDLE DeviceHandle;
	WINUSB_INTERFACE_HANDLE InterfaceHandle;
} usb_handle_t;

/* Open usb device */
void *usb_open(uint8_t verbose)
{
	char *device_path;

	/* Alocate memory for the usb handle structure */
	usb_handle_t *handle = malloc(sizeof(usb_handle_t));
	if (!handle) {
		if (verbose)
			fprintf(stderr, "Out of memory!\n");
		return NULL;
	}

	handle->DeviceHandle = INVALID_HANDLE_VALUE;
	handle->InterfaceHandle = NULL;

	/* First search for TL866A/CS */
	int count = search_devices(MP_TL866A, &device_path);
	if (count) {
		handle->DeviceHandle =
			CreateFileA(device_path, GENERIC_READ | GENERIC_WRITE,
				    FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
				    OPEN_EXISTING, 0, NULL);
		free(device_path);
		if (handle->DeviceHandle == INVALID_HANDLE_VALUE) {
			if (verbose)
				fprintf(stderr, "No programmer found.\n");
			free(handle);
			return NULL;
		}
		return handle;
	}

	/* Then search for TL866II+ */
	count = search_devices(MP_TL866IIPLUS, &device_path);
	if (count) {
		handle->DeviceHandle =
			CreateFileA(device_path, GENERIC_READ | GENERIC_WRITE,
				    FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
				    OPEN_EXISTING, FILE_FLAG_OVERLAPPED, NULL);
		free(device_path);
		if (handle->DeviceHandle == INVALID_HANDLE_VALUE) {
			if (verbose)
				fprintf(stderr, "No programmer found.\n");
			free(handle);
			return NULL;
		}

		if (WinUsb_Initialize(handle->DeviceHandle,
				      &handle->InterfaceHandle)) {
			uint8_t value = 1;
			WinUsb_SetPipePolicy(handle->InterfaceHandle, 0x81,
					     AUTO_FLUSH, 1, &value);
			WinUsb_SetPipePolicy(handle->InterfaceHandle, 0x82,
					     AUTO_FLUSH, 1, &value);
			WinUsb_SetPipePolicy(handle->InterfaceHandle, 0x83,
					     AUTO_FLUSH, 1, &value);
			return handle;
		}
	}

	if (verbose)
		fprintf(stderr, "No programmer found.\n");
	free(handle);
	return NULL;
}

/* Close usb device */
int usb_close(void *handle)
{
	if (((usb_handle_t *)handle)->InterfaceHandle)
		WinUsb_Free(((usb_handle_t *)handle)->InterfaceHandle);
	CloseHandle(((usb_handle_t *)handle)->DeviceHandle);
	free(handle);
	return EXIT_SUCCESS;
}

/* Get number of devices connected */
int minipro_get_devices_count(uint8_t version)
{
	return search_devices(version, NULL);
}

/* synchronously message send */
int msg_send(void *handle, uint8_t *buffer, size_t size)
{
	return usb_write(handle, buffer, size, USB_ENDPOINT_OUT | 0x01);
}

/* synchronously message receive */
int msg_recv(void *handle, uint8_t *buffer, size_t size)
{
	return usb_read(handle, buffer, size, USB_ENDPOINT_IN | 0x01);
}

/* Write payload asynchronously */
int write_payload2(void *handle, uint8_t *buffer, size_t length, size_t limit)
{
	uint32_t ep2_length;
	uint32_t ep3_length;

	/* If the payload length is exactly 64 bytes,
	 * send it over the endpoint2 only */
	if (!limit || length <= limit)
		return usb_write(handle, buffer, length,
				 USB_ENDPOINT_OUT | 0x02);

	/* This  is from XgPro */
	uint32_t j = length % 128;
	if (length % 128) {
		uint32_t k = (length - j) / 2;
		if (j > 64) {
			ep2_length = k + 64;
			ep3_length = j + k - 64;
		} else {
			ep2_length = k;
			ep3_length = j + k;
		}
	} else {
		ep3_length = length / 2;
		ep2_length = ep3_length;
	}
	return payload_transfer(handle, USB_ENDPOINT_OUT, buffer, ep2_length,
				buffer + ep2_length, ep3_length);
}

/* Read payload asynchronously */
int read_payload2(void *handle, uint8_t *buffer, size_t length, size_t limit)
{
  /*
   * If the payload length is less than 64 bytes increase the buffer to 64
   * bytes and  read it over the endpoint2 only. Submitting a buffer less than
   * 64 bytes will cause an libusb overflow.
   */
	if (length < 64) {
		uint8_t data[64];
		if (usb_read(handle, data, sizeof(data),
			     USB_ENDPOINT_IN | 0x02))
			return EXIT_FAILURE;
		memcpy(buffer, data, length);
		return EXIT_SUCCESS;
	}

	/* If the payload length is exactly 64 bytes,
	 * read it over the endpoint2 only. */
	if (length <= limit)
		return usb_read(handle, buffer, length, USB_ENDPOINT_IN | 0x02);

	/* More than 64 bytes */
	uint8_t *data = malloc(length);
	if (!data) {
		fprintf(stderr, "\nOut of memory\n");
		return EXIT_FAILURE;
	}

	/* Async read of endpoints 2 and 3 */
	if (payload_transfer(handle, USB_ENDPOINT_IN, data, length / 2,
			     data + length / 2, length / 2)) {
		free(data);
		return EXIT_FAILURE;
	}

	/* Deinterlacing buffers */
	size_t blocks = length / 64;
	for (int i = 0; i < blocks; ++i) {
		uint8_t *ep_buf;
		if (i % 2 == 0) {
			ep_buf = data;
		} else {
			ep_buf = data + length / 2;
		}
		memcpy(buffer + (i * 64), ep_buf + ((i / 2) * 64), 64);
	}
	free(data);
	return EXIT_SUCCESS;
}


/************************************
 * Kitchen functions
 ************************************
 */

/* Transferr payload asynchronously */
static int payload_transfer(void *handle, uint8_t direction,
			    uint8_t *ep2_buffer, size_t ep2_length,
			    uint8_t *ep3_buffer, size_t ep3_length)
{
	DWORD ret1, ret2;
	OVERLAPPED overlapped1, overlapped2;
	HANDLE hEvent1, hEvent2;

	/* Create events */
	hEvent1 = CreateEvent(NULL, TRUE, FALSE, NULL);
	if (!hEvent1) {
		fprintf(stderr, "\nIO Error: Async transfer failed.\n");
		return EXIT_FAILURE;
	}

	hEvent2 = CreateEvent(NULL, TRUE, FALSE, NULL);
	if (!hEvent2) {
		fprintf(stderr, "\nIO Error: Async transfer failed.\n");
		CloseHandle(hEvent1);
		return EXIT_FAILURE;
	}

	/* Asign events to each overlapped sructure */
	ResetEvent(hEvent1);
	ResetEvent(hEvent2);
	overlapped1.hEvent = hEvent1;
	overlapped2.hEvent = hEvent2;

	/* Endpoint 2 transfer */
	if (direction == USB_ENDPOINT_IN)
		WinUsb_ReadPipe(((usb_handle_t *)handle)->InterfaceHandle,
				direction | 0x02, ep2_buffer, ep2_length, NULL,
				&overlapped1);
	else
		WinUsb_WritePipe(((usb_handle_t *)handle)->InterfaceHandle,
				 direction | 0x02, ep2_buffer, ep2_length, NULL,
				 &overlapped1);

	/* Endpoint 3 transfer */
	if (direction == USB_ENDPOINT_IN)
		WinUsb_ReadPipe(((usb_handle_t *)handle)->InterfaceHandle,
				direction | 0x03, ep3_buffer, ep3_length, NULL,
				&overlapped2);
	else
		WinUsb_WritePipe(((usb_handle_t *)handle)->InterfaceHandle,
				 direction | 0x03, ep3_buffer, ep3_length, NULL,
				 &overlapped2);

	/* Wait for transfer completion */
	ret1 = WaitForSingleObject(hEvent1, MP_USBTIMEOUT);
	ret2 = WaitForSingleObject(hEvent2, MP_USBTIMEOUT);

	/* Close event handles */
	CloseHandle(hEvent1);
	CloseHandle(hEvent2);

	if (ret1 || ret2) {
		fprintf(stderr, "\nIO Error: Async transfer failed.\n");
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

/* USB write function. */
static int usb_write(void *handle, uint8_t *buffer, size_t size,
		     uint8_t endpoint)
{
	DWORD bytes_written;
	uint8_t temp[256]; /* Temp array needed by driver */
	BOOL ret;

	/* Check the device handle first */
	if (((usb_handle_t *)handle)->DeviceHandle == INVALID_HANDLE_VALUE)
		return 0;

	/* If winusb handle is set then use winusb(TL866II+) */
	if (((usb_handle_t *)handle)->InterfaceHandle) {
		ret = WinUsb_WritePipe(
			((usb_handle_t *)handle)->InterfaceHandle, endpoint,
			buffer, size, &bytes_written, NULL);
		if (!ret)
			fprintf(stderr, "\nIO Error: USB write failed.\n");
		return (ret ? EXIT_SUCCESS : EXIT_FAILURE);
	}

	/* otherwise just use the old deviceiocontrol(TL866A)
	 * For TL866A/CS the endpoint argument is not used. */
	ret = DeviceIoControl(((usb_handle_t *)handle)->DeviceHandle,
			      TL866A_IOCTL_WRITE, buffer, size, temp, 256,
			      &bytes_written, NULL);
	if (!ret)
		fprintf(stderr, "\nIO Error: USB write failed.\n");
	return (ret ? EXIT_SUCCESS : EXIT_FAILURE);
}

/* USB read function. */
static int usb_read(void *handle, uint8_t *buffer, size_t size,
		    uint8_t endpoint)
{
	DWORD bytes_read;
	uint32_t tmp = 0;
	BOOL ret;

	/* Check the device handle first */
	if (((usb_handle_t *)handle)->DeviceHandle == INVALID_HANDLE_VALUE)
		return 0;

	/* If winusb handle is set then use winusb(TL866II+) */
	if (((usb_handle_t *)handle)->InterfaceHandle) {
		ret = WinUsb_ReadPipe(((usb_handle_t *)handle)->InterfaceHandle,
				      endpoint, buffer, size, &bytes_read,
				      NULL);
		if (!ret)
			fprintf(stderr, "\nIO Error: USB read failed.\n");
		return (ret ? EXIT_SUCCESS : EXIT_FAILURE);
	}

	/* Otherwise just use the old deviceiocontrol api(TL866A)
	 * For TL866A/CS the endpoint argument is not used. */
	ret = DeviceIoControl(((usb_handle_t *)handle)->DeviceHandle,
			      TL866A_IOCTL_READ, &tmp, sizeof(tmp), buffer,
			      size, &bytes_read, NULL);
	if (!ret)
		fprintf(stderr, "\nIO Error: USB read failed.\n");
	return (ret ? EXIT_SUCCESS : EXIT_FAILURE);
}

/* This function will scan for connected devices.
 *  If the device_path is not null then this function will
 *  return here the path of the first device found.
 *  Don't forget to call free(device_path) to free the allocated memory.
 */
static int search_devices(uint8_t version, char **device_path)
{
	uint32_t idx = 0;
	uint32_t devices = 0;

	GUID guid;

	switch (version) {
	case MP_TL866IIPLUS:
	case MP_T48:
	case MP_T56:
		guid = (GUID)TL866IIPLUS_GUID;
		break;
		
	default:
		guid = (GUID)TL866A_GUID;
		break;
	}

	HDEVINFO handle = SetupDiGetClassDevs(
		&guid, NULL, NULL, DIGCF_PRESENT | DIGCF_DEVICEINTERFACE);

	if (!handle) {
		fprintf(stderr, "SetupDi failed!\n");
		return 0;
	}

	while (1) {
		SP_DEVINFO_DATA deviceinfodata;
		deviceinfodata.cbSize = sizeof(SP_DEVINFO_DATA);

		if (!SetupDiEnumDeviceInfo(handle, idx, &deviceinfodata))
			break;
		SP_DEVICE_INTERFACE_DATA deviceinterfacedata;
		deviceinterfacedata.cbSize = sizeof(SP_DEVICE_INTERFACE_DATA);

		if (SetupDiEnumDeviceInterfaces(handle, NULL, &guid, idx,
						&deviceinterfacedata)) {
			idx++;
			DWORD size = 0;

			SetupDiGetDeviceInterfaceDetail(handle,
							&deviceinterfacedata,
							NULL, 0, &size, NULL);
			PSP_DEVICE_INTERFACE_DETAIL_DATA
				deviceinterfacedetaildata =
					(PSP_DEVICE_INTERFACE_DETAIL_DATA)(malloc(
						size * sizeof(TCHAR)));
			deviceinterfacedetaildata->cbSize =
				sizeof(SP_INTERFACE_DEVICE_DETAIL_DATA);
			DWORD datasize = size;

			if (SetupDiGetDeviceInterfaceDetail(
				    handle, &deviceinterfacedata,
				    deviceinterfacedetaildata, datasize, &size,
				    NULL)) {
				if (!devices && device_path) {
					*device_path =
						strdup(deviceinterfacedetaildata
							       ->DevicePath);
				}
				devices++;
			}
			free(deviceinterfacedetaildata);
		}
	}
	return devices;
}
