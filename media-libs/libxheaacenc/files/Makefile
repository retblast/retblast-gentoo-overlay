CC ?= gcc
AR ?= ar

CFLAGS += -fPIC -Wall -Wno-unused-function -Wno-unused-variable -Wno-unused-but-set-variable

INCLUDES := \
  -IxHEAACEnc/include \
  -Iaacfastenc/include \
  -IapplauseDetectionlib/include \
  -IiisArithEncLib/include \
  -IiisAudioPrerollLib/include \
  -IiisBitFrame/include \
  -IiisDRCGainEncLib/include \
  -IiisDRCGainGenLib/include \
  -IiisEncoderConfig/include \
  -IiisEncoderConfigCTable/include \
  -IiisLevelerLib/include \
  -IiisLinkedList/include \
  -IiisLoudnessLib/include \
  -IiisLPDComLib/include \
  -IiisLPDEncLib/include \
  -IiisParamList/include \
  -IiisSigMap/include \
  -IiisSwitchingDecision/include \
  -IiisxHEAACEncLib/include \
  -Ilimiterlib/include \
  -Imathlib/include \
  -ImathIib/include \
  -Imp4ASC/IIS_MP4ASC_Interface \
  -Imp4ASC/include \
  -Imp4General \
  -Imp4bitbuf/include \
  -Imp4bitmux/src/aac \
  -Imp4loaswrite/include \
  -Imp4timebuf/include \
  -Iqmflib/include \
  -Ireadonlybitbuf/include \
  -Iresamplelib/include \
  -IsbrEnclib/include \
  -IspaceEnclib/include \
  -IstatClassLib_C/include \
  -Iutillib/include \
  -Iutillib/include/IISutillib \
  -Iwriteonlybitbuf/include

SRC_DIRS := \
  aacfastenc/src \
  applauseDetectionlib/src \
  iisArithEncLib/src \
  iisAudioPrerollLib/src \
  iisBitFrame/src \
  iisDRCGainEncLib/src \
  iisDRCGainGenLib/src \
  iisEncoderConfig/src \
  iisEncoderConfigCTable/src \
  iisLevelerLib/src \
  iisLinkedList/src \
  iisLoudnessLib/src \
  iisLPDComLib/src \
  iisLPDEncLib/src \
  iisParamList/src \
  iisSigMap/src \
  iisSwitchingDecision/src \
  iisxHEAACEncLib/src \
  limiterlib/src \
  mathlib/src \
  mp4ASC/IIS_MP4ASC_Interface \
  mp4ASC/src \
  mp4bitbuf/src \
  mp4bitmux/src/aac \
  mp4loaswrite/src \
  mp4timebuf/src \
  qmflib/src \
  readonlybitbuf/src \
  resamplelib/src \
  resamplelib/src/polyphase \
  sbrEnclib/src \
  spaceEnclib/src \
  statClassLib_C/src \
  utillib/src \
  writeonlybitbuf/src \
  xHEAACEnc/src

SRCS := $(foreach d,$(SRC_DIRS),$(wildcard $(d)/*.c))
OBJS := $(SRCS:.c=.o)

TARGET := libFraunhoferXHEAACEnc.a

.PHONY: all clean
all: $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(TARGET): $(OBJS)
	$(AR) rcs $@ $(OBJS)

clean:
	rm -f $(OBJS) $(TARGET)
