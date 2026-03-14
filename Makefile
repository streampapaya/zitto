.PHONY: all build run version

all: run

run: build
	zig-out/bin/zitto.exe

build:
	zig build --global-cache-dir .zig-global-cache && $(MAKE) version

version:
	python -c "from pathlib import Path; import re; p = Path('src/app/app_version.zig'); s = p.read_text(); m = re.search(r'\"(\\d+)\\.(\\d+)\\.(\\d+)\"', s); assert m, 'version string not found'; major, minor, patch = map(int, m.groups()); p.write_text(re.sub(r'\"\\d+\\.\\d+\\.\\d+\"', f'\"{major}.{minor}.{patch + 1}\"', s, count=1))"
