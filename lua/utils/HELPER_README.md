📦 Installation instructions
📚 Full function breakdown by **category**
🧾 Parameters, returns, and short descriptions
    

# 🛠 helper.lua

A Python-inspired utility module for Lua, designed for use in Neovim or general-purpose scripting. It includes helper functions for working with lists, dictionaries, files, logging, requests, system commands, encoding, and more.

* * *

## 📦 Installation

1.  Place `helper.lua` inside your Neovim config directory:

`~/.config/nvim/lua/utils/helper.lua`

2.  Require it in your scripts:

```lua
local helper = require("utils.helper")
```

(Optional) Reload module on demand during development:

```lua
package.loaded["utils.helper"] = nil
local helper = require("utils.helper")
```

## 📚 API Reference

### 📋 List Functions (`helper.list`)

#### `append(table, value)`

Appends a value to the end of a list-like table.

#### `drop_index(table, index)`

Removes the value at the given 1-based index.

#### `join(table1, table2)`

Returns a new table with all values from both input tables.

#### `length(table)`

Returns the number of elements in a list-style table.

* * *

### 🔐 Dictionary Functions (`helper.dict`)

#### `add(dict, key, value)`

Adds or updates a key-value pair in the dictionary.

#### `del(dict, key)`

Removes a key from the dictionary.

#### `join(dict1, dict2)`

Returns a new dictionary with merged key-value pairs (dict2 overwrites dict1 on conflict).

#### `count(dict)`

Returns the number of keys in the dictionary.

* * *

### 🌐 HTTP Requests (`helper.requests`)

> ⚠ Requires [LuaSocket](https://github.com/diegonehab/luasocket)

#### `get(url, headers?, auth?)`

Performs an HTTP GET request.

- `headers`: Table of custom headers (e.g. `{ Accept = "application/json" }`)
    
- `auth`: Basic auth as `{ username = "", password = "" }`
    

#### `post(url, body, headers?, auth?)`

Performs an HTTP POST request.

- `body`: Request body (string)

#### `put(url, body, headers?, auth?)`

Same as POST, but uses PUT method.

#### `patch(url, body, headers?, auth?)`

Same as POST, but uses PATCH method.

#### `delete(url, headers?, auth?)`

Performs an HTTP DELETE request.

*All return: `body, status_code, response_headers, response_status`*

* * *

### 📁 File Helpers (`helper.file`)

#### `open(path, mode?)`

Opens a file. Defaults to `"r"` (read mode). Returns `file_handler, err`.

#### `read(file_handler)`

Reads the full contents of the open file.

#### `loop_lines(file_handler, callback)`

Iterates line-by-line and passes each line to a callback function.

#### `close(file_handler)`

Closes the file safely.

* * *

### 🧾 Logging (`helper.logging`)

#### `log_to_file(path, message)`

Appends a log entry to the file at `path`. Adds a timestamp.

* * *

### 🖥 System & OS Tools (`helper.os`)

#### `get_env_var(varname, default?)`

Returns the value of an environment variable or a fallback value.

#### `run_command(command, options?)`

Runs a shell command.

- `options`: `{ return_output = true/false, wait = true/false }`
    
- Returns either command output or exit status depending on options.
    

#### `get_current_username()`

Returns the current system username, cross-platform compatible.

* * *

### 🧪 Conversions (`helper.conversions`)

#### `base64_encode(string)`

Encodes a string in base64.

#### `base64_decode(string)`

Decodes a base64-encoded string.

#### `to_hex(string)`

Returns a hexadecimal representation of the input string.

#### `from_hex(hex_string)`

Decodes a hexadecimal string to original content.

#### `zip_file(input_file, output_zip)`

Zips a file using the system `zip` command.

#### `unzip_file(zip_path, output_dir)`

Extracts a zip file using the system `unzip` command.

#### `tar_directory(input_dir, output_tar)`

Tars a directory using the system `tar` command.

#### `untar_file(tar_path, output_dir)`

Extracts a `.tar` archive using the system `tar` command.

* * *

## 🔍 Example Usage

```lua
local helper = require("utils.helper")

-- Append and length
local mylist = {1, 2, 3}
helper.list.append(mylist, 4)
print("Length:", helper.list.length(mylist)) -- 4

-- Logging
helper.logging.log_to_file("log.txt", "Something happened!")

-- HTTP GET
local body, code = helper.requests.get("http://example.com")
print(code, body)

-- File read
local f = helper.file.open("README.md", "r")
if f then
  print(helper.file.read(f))
  helper.file.close(f)
end

-- Username
print("Hello,", helper.os.get_current_username())

```

## 📌 Requirements

- [LuaJIT](https://luajit.org/) or Lua 5.1+
    
- Optional: [LuaSocket](https://github.com/diegonehab/luasocket) for HTTP
    
- System utilities: `zip`, `unzip`, `tar` if you use those functions
    

* * *

## 💬 License

MIT — free to use, adapt, or extend.
