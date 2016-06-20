include Makefile-platform
include Makefile-ndll

PROJECT=necurl

ifeq ($(PLATFORM), $(filter $(PLATFORM), Windows Windows64))
  ifeq ($(PLATFORM),Windows64)
# https://curl.haxx.se/gknw.net/7.40.0/dist-w64/curl-7.40.0-devel-mingw64.zip
    CURLPATH=dep\libcurl64
  else
# https://curl.haxx.se/gknw.net/7.40.0/dist-w32/curl-7.40.0-devel-mingw32.zip
    CURLPATH=dep\libcurl32
  endif
	CCFLAGS+= -I $(NEKOPATH)\include -I $(CURLPATH)\include
  #LDFLAGS+= -L$(NEKOPATH)
	LDFLAGS+= $(CURLPATH)\bin\libcurl.dll
else
	LDFLAGS+= -lcurl
endif


