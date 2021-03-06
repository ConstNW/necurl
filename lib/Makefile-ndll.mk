####################################################
# Input:
#---------------------------------------------------
# PLATFORM - Windows/Windows64/Linux/Linux64/Mac/Mac64
# PROJECT - project name
####################################################

ifndef SRC_DIR
	SRC_DIR=src
endif

ifndef OBJ_DIR
	OBJ_DIR=obj
endif

CC=gcc
CP=g++

C_FILES := $(wildcard $(SRC_DIR)/*.c)
CPP_FILES := $(wildcard $(SRC_DIR)/*.cpp)
OBJ_FILES := $(addprefix $(OBJ_DIR)/,$(notdir $(CPP_FILES:.cpp=.o))) $(addprefix $(OBJ_DIR)/,$(notdir $(C_FILES:.c=.o)))

OUT=../ndll/$(PLATFORM)/$(PROJECT).ndll

ifndef CCFLAGS
	CCFLAGS=-shared -Wall
else
	CCFLAGS+=-shared -Wall
endif

LDFLAGS=-shared

ifeq ($(PLATFORM), $(filter $(PLATFORM), Windows Windows64))
	CCFLAGS+= -I$(NEKOPATH)\include -D _WINDOWS
	LDFLAGS+= $(NEKOPATH)\neko.dll -static-libgcc -static-libstdc++
else
	ifeq ($(PLATFORM), Linux64)
		CCFLAGS+= -fPIC
	endif
# CCFLAGS+= -ggdb
	CCFLAGS+= -I$(NEKOPATH)/include
	LDFLAGS+= -L$(NEKOPATH) -lneko
endif

all: clean build

build: $(OBJ_FILES) build-dir build-files

build-dir:
	-mkdir -p $(dir $(OUT))

build-files:
ifneq ($(strip $(C_FILES)),)
	$(CC) $(OBJ_FILES) $(LDFLAGS) -o $(OUT)
else
	$(CP) $(OBJ_FILES) $(LDFLAGS) -o $(OUT)
endif

install:
	cp $(OUT) $(NEKOPATH)/$(PROJECT).ndll

test:
	cd ../test; haxe test.hxml; cd bin; neko test.n

cleanbuild: clean

clean:
	-rm -f $(OBJ_FILES)
	-rm -f $(OUT)

$(OBJ_FILES): | $(OBJ_DIR)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CCFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CP) $(CCFLAGS) -c -o $@ $<
