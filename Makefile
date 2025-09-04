# Cross-compiler
CC = arm-linux-gnueabi-gcc

# Paths
SRCDIR = native/serialport/src
INCDIR = native/serialport/include
OUTDIR = assets/lib
LIBNAME = libserial_wrapper.so
TARGET = $(OUTDIR)/$(LIBNAME)

# Compiler flags
CFLAGS = -shared -fPIC -O2 -Wall

# Include paths
INCLPATH = -I$(INCDIR)

# Sources
SOURCES = $(SRCDIR)/serialport_wrapper.c

all: $(TARGET)

$(TARGET): $(SOURCES)
	@mkdir -p $(OUTDIR)
	$(CC) $(CFLAGS) $(INCLPATH) $(SOURCES) -o $(TARGET)

clean:
	rm -rf $(TARGET)
