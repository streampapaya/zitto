.PHONY: all build run version

all: run

run: build
	zig-out/bin/zitto.exe

build:
	zig build --global-cache-dir .zig-global-cache && $(MAKE) version
