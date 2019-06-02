include Makefile-platform.mk
include Makefile-ndll.mk

PROJECT=necurl

ifeq ($(PLATFORM), $(filter $(PLATFORM), Windows Windows64))

	ifeq ($(PLATFORM),Windows64)
		NEKOPATH=d:\devel\neko-x64
		CURLPATH=dep\libcurl64
	else
		NEKOPATH=d:\devel\neko
		CURLPATH=dep\libcurl32
	endif

	CCFLAGS+= -I $(CURLPATH)\include
	#LDFLAGS+= -L$(NEKOPATH)
	LDFLAGS+= -L$(CURLPATH)\lib -lcurl

else
	LDFLAGS+= -lcurl
endif

platform:
	echo "$(PLATFORM) $(OS) $(PROCESSOR_ARCHITECTURE)"
