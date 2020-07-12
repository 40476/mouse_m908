# paths for the installation
PREFIX = /usr
BIN_DIR = $(PREFIX)/bin
DOC_DIR = $(PREFIX)/share/doc
MAN_DIR = $(PREFIX)/share/man/man1

# compiler options
CC = g++
CC_OPTIONS := -Wall -Wextra -O2 `pkg-config --cflags libusb-1.0`
LIBS != pkg-config --libs libusb-1.0

# version string
VERSION_STRING = "\"2.1\""

# compile
build: m908 data_rd.o load_config.o mouse_m908.o
	$(CC) *.o -o mouse_m908 $(LIBS) $(CC_OPTIONS)

# copy all files to their correct location
install:
	cp ./mouse_m908 $(BIN_DIR)/mouse_m908 && \
	cp ./mouse_m908.rules /etc/udev/rules.d && \
	mkdir $(DOC_DIR)/mouse_m908 | true && \
	cp ./example.ini $(DOC_DIR)/mouse_m908/ && \
	cp ./example.macro $(DOC_DIR)/mouse_m908/ && \
	cp ./README.md $(DOC_DIR)/mouse_m908/ && \
	cp ./keymap.md $(DOC_DIR)/mouse_m908/ && \
	cp ./mouse_m908.1 $(MAN_DIR)/

install-bsd:
	cp ./mouse_m908 $(BIN_DIR)/mouse_m908 && \
	mkdir $(DOC_DIR)/mouse_m908 | true && \
	cp ./example.ini $(DOC_DIR)/mouse_m908/ && \
	cp ./example.macro $(DOC_DIR)/mouse_m908/ && \
	cp ./README.md $(DOC_DIR)/mouse_m908/ && \
	cp ./keymap.md $(DOC_DIR)/mouse_m908/ && \
	cp ./mouse_m908.1 $(MAN_DIR)/

# remove binary
clean:
	rm mouse_m908 *.o
	rm -r Haiku/bin Haiku/documentation Haiku/mouse_m908.hpkg | true

# remove all installed files
uninstall:
	rm -f $(BIN_DIR)/mouse_m908 && \
	rm -f /etc/udev/rules.d/mouse_m908.rules && \
	rm -rf $(DOC_DIR)/mouse_m908 && \
	rm -f $(MAN_DIR)/mouse_m908.1

# this is an alias to install for backwards compatibility
upgrade: install

# this builds a .hpkg package on Haiku
hpkg:
	mkdir Haiku/bin
	mkdir -p Haiku/documentation/man/man1
	mkdir -p Haiku/documentation/packages/mouse_m908
	cp mouse_m908 Haiku/bin
	cp mouse_m908.1 Haiku/documentation/man/man1
	cp example.ini Haiku/documentation/packages/mouse_m908
	cp example.macro Haiku/documentation/packages/mouse_m908
	cp README.md Haiku/documentation/packages/mouse_m908
	cp keymap.md Haiku/documentation/packages/mouse_m908
	cd Haiku; \
	package create -b mouse_m908.hpkg; \
	package add mouse_m908.hpkg bin documentation

# targets for different mice
m908: constructor_m908.o data_m908.o getters_m908.o helpers_m908.o setters_m908.o writers_m908.o readers_m908.o

# individual files
mouse_m908.o:
	$(CC) -c mouse_m908.cpp $(CC_OPTIONS) -D VERSION_STRING=$(VERSION_STRING)

load_config.o:
	$(CC) -c include/load_config.cpp $(CC_OPTIONS)

data_rd.o:
	$(CC) -c include/data.cpp $(CC_OPTIONS)

constructor_m908.o:
	$(CC) -c include/m908/constructor.cpp $(CC_OPTIONS) -o constructor_m908.o

data_m908.o:
	$(CC) -c include/m908/data.cpp $(CC_OPTIONS) -o data_m908.o

getters_m908.o:
	$(CC) -c include/m908/getters.cpp $(CC_OPTIONS) -o getters_m908.o

helpers_m908.o:
	$(CC) -c include/m908/helpers.cpp $(CC_OPTIONS) -o helpers_m908.o

setters_m908.o:
	$(CC) -c include/m908/setters.cpp $(CC_OPTIONS) -o setters_m908.o

writers_m908.o:
	$(CC) -c include/m908/writers.cpp $(CC_OPTIONS) -o writers_m908.o

readers_m908.o:
	$(CC) -c include/m908/readers.cpp $(CC_OPTIONS) -o readers_m908.o
