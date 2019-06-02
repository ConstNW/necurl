LIB_NAME=necurl
LIB_FILE=$(LIB_NAME).zip

all: build upload

upload:
	haxelib submit $(LIB_FILE)

build: $(LIB_FILE) clean

$(LIB_FILE): haxelib.json src/*/* ndll/*/*
	-mkdir temp
	cp haxelib.json temp/
	cp -R ndll temp/
	cp -R src temp/
	cd temp; zip -X -r $(LIB_FILE) .; mv $(LIB_FILE) ../

clean:
	-rm -rf temp
