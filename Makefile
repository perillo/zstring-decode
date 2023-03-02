# Copyright 2021 Manlio Perillo. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# A Makefile template for Zig projects.

# Variable definitions.
export zig := zig
export prefix := ~/.local

# Standard rules.
.POSIX:

# Default rule.
.PHONY: build
build:
	${zig} build -p build $(cmd)

# Custom rules.
.PHONY: clean
clean:
	rm -rf build/* zig-cache/ zig-out/

.PHONY: fmt
fmt:
	$(zig) fmt --ast-check build.zig src/*.zig

.PHONY: push
push:
	git push --follow-tags -u origin master

.PHONY: install
install:
	${zig} build install -p ${prefix}

.PHONY: uninstall
uninstall:
	${zig} build uninstall -p ${prefix}
