# zstring-decode

The `zstring-decode` command converts the data from stdin to a Zig string
literal.

### Example

```sh
$ zig build-exe --color on src/main.zig 2>&1 | zstring-decode
```

```
"LLVM Emit Object... \x1b[20D\x1b[0KLLVM Emit Object... \x1b[20D\x1b[0KLLD Link... \x1b[12D\x1b[0K"
```
