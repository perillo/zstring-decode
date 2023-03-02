// Copyright 2023 Manlio Perillo. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//! This command converts the data from stdin to a Zig string literal.

const std = @import("std");
const fs = std.fs;
const heap = std.heap;
const io = std.io;
const mem = std.mem;
const process = std.process;

const Allocator = std.mem.Allocator;

const max_stdin_size = 10 * 1024 * 1024;
const stdin = io.getStdIn().reader();
const stdout = io.getStdOut().writer();

pub fn decode(out: anytype, bytes: []const u8) !void {
    try out.writeByte('"');
    for (bytes, 0..) |b, i| {
        try switch (b) {
            // Control  characters.
            '\x00'...'\x08' => out.print("\\x0{x}", .{b}),
            '\t' => out.writeAll("\\t"),
            '\n' => out.writeAll("\\n"),
            '\x0B'...'\x0C' => out.print("\\x0{x}", .{b}),
            '\r' => out.writeAll("\\r"),
            '\x0E'...'\x0F' => out.print("\\x0{x}", .{b}),
            '\x10'...'\x1F' => out.print("\\x{x}", .{b}),

            // Printable characters.
            '\x20'...'\x21' => out.writeByte(b),
            '\"' => out.writeAll("\\\""),
            '\x23'...'\x5B' => out.writeByte(b),
            '\\' => if (i + 1 < bytes.len)
                switch (i + 1) {
                    '\t', '\n', '\r', '"' => out.writeByte(b),
                    else => out.writeAll("\\\\"),
                }
            else
                out.writeAll("\\\\"),
            '\x5D'...'\x7E' => out.writeByte(b),

            // DEL character.
            '\x7F' => out.print("\\x{x}", .{b}),

            // 8 bit characters.
            '\x80'...'\xFF' => out.print("\\x{x}", .{b}),
        };
    }
    try out.writeByte('"');
}

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const bytes = try stdin.readAllAlloc(allocator, max_stdin_size);
    try decode(stdout, bytes);
    try stdout.writeByte('\n');
}

test {
    _ = @import("test.zig");
}
