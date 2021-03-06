# OpenNI Android makefile.
# libOpenNI.so
#

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS) 

# set path to source
MY_PREFIX := $(LOCAL_PATH)/../../../../Source/OpenNI/

# list all source files
MY_SRC_FILES := \
	$(MY_PREFIX)*.cpp \
	$(MY_PREFIX)Linux-x86/*.cpp \
	$(MY_PREFIX)../External/TinyXml/*.cpp

# expand the wildcards
MY_SRC_FILE_EXPANDED := $(wildcard $(MY_SRC_FILES))

# make those paths relative to here
LOCAL_SRC_FILES := $(MY_SRC_FILE_EXPANDED:$(LOCAL_PATH)/%=%)

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../../../../Include/ \
	$(LOCAL_PATH)/../../../../Source/ \
	$(LOCAL_PATH)/../../../../Source/External/TinyXml/ \
	$(LOCAL_PATH)/../External/libusb-1.0.8/libusb \

LOCAL_CFLAGS:= -fvisibility=hidden -DXN_EXPORTS

LOCAL_LDFLAGS += -Wl,--export-dynamic --dynamic-linker 

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../../../Include
LOCAL_SHARED_LIBRARIES := libusb 

LOCAL_PREBUILT_LIBS := libc 

LOCAL_MODULE:= OpenNI

include $(BUILD_SHARED_LIBRARY)

# external Android build trees that import OpenNI must also have libusb, at least so they can build libOpenNI.so locally.
# this line is unwanted, though, when building locally from OpenNI's Android tree
ifdef NDK_MODULE_PATH
$(if $(call set_is_member,$(__ndk_modules),usb),\
	$(call __ndk_info,Don't use NDK_MODULE_PATH when building OpenNI locally. Ignoring.)\
	,\
	$(call import-module,External/libusb*) \
	)
endif
