.PHONY: build run

all: run

run: build
	zig-out/bin/zditto.exe

build:
	zig build --global-cache-dir .zig-global-cache
