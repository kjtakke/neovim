-- helper.lua
-- A single Lua module mimicking select Python functionalities:
--  1) "Tables" (list-like)
--  2) "Dict" (dictionary-like)
--  3) "Requests" (HTTP methods)
--  4) "Logging" (logging to file)
--  5) "File" operations
--  6) "os and subprocess"
--  7) "data conversions" (base64, hex, zip, tar, etc.)

local helper = {}

--------------------------------------------------------------------------------
-- TABLE FUNCTIONS (list-like)
--------------------------------------------------------------------------------
helper.list = {}

--- Append a value to the end of a list-like table
---@param t table
---@param value any
function helper.list.append(t, value)
  table.insert(t, value)
end

--- Remove an item at a given 1-based index
---@param t table
---@param index number
function helper.list.drop_index(t, index)
  table.remove(t, index)
end

--- Join two list-like tables. Returns a new table
---@param t1 table
---@param t2 table
---@return table
function helper.list.join(t1, t2)
  local result = {}
  for _, v in ipairs(t1) do
    table.insert(result, v)
  end
  for _, v in ipairs(t2) do
    table.insert(result, v)
  end
  return result
end

--- Return the length of a table (list)
---@param t table
---@return number
function helper.list.length(t)
  return #t
end

--------------------------------------------------------------------------------
-- DICT FUNCTIONS (dictionary-like)
--------------------------------------------------------------------------------
helper.dict = {}

--- Add or overwrite a key-value pair
---@param d table
---@param key any
---@param value any
function helper.dict.add(d, key, value)
  d[key] = value
end

--- Delete a key from the dictionary
---@param d table
---@param key any
function helper.dict.del(d, key)
  d[key] = nil
end

--- Join two dictionaries, returning a new table. If collision occurs, d2 overwrites d1
---@param d1 table
---@param d2 table
---@return table
function helper.dict.join(d1, d2)
  local result = {}
  -- copy all of d1
  for k, v in pairs(d1) do
    result[k] = v
  end
  -- merge/overwrite with d2
  for k, v in pairs(d2) do
    result[k] = v
  end
  return result
end

--- Count number of keys in dictionary
---@param d table
---@return number
function helper.dict.count(d)
  local cnt = 0
  for _ in pairs(d) do
    cnt = cnt + 1
  end
  return cnt
end

--------------------------------------------------------------------------------
-- REQUESTS (HTTP)
--------------------------------------------------------------------------------
-- This example uses LuaSocket for HTTP. You must have `luasocket` installed.
-- e.g. `luarocks install luasocket`
--
-- If using pure Lua 5.4 + a standard library, you may not have this by default.
--------------------------------------------------------------------------------
-- Example usage:
-- local resp, code, headers = helper.requests.get("http://httpbin.org/get", {Accept="application/json"})
--
local ok, http = pcall(require, "socket.http")
if not ok then
  -- If socket.http isn't available, we'll provide stubs with an error message
  http = {
    request = function(...)
      return nil, "LuaSocket is not available; please install luasocket."
    end
  }
end

helper.requests = {}

-- Private helper: build headers table from user-specified
local function build_headers(tbl)
  local h = {}
  if tbl then
    for k, v in pairs(tbl) do
      table.insert(h, k)
      table.insert(h, v)
    end
  end
  return h
end

--- Send a GET request
---@param url string
---@param headers? table  Optional headers
---@param auth? table     {username="foo", password="bar"} - basic
---@return string|nil response_body
---@return number|nil response_code
function helper.requests.get(url, headers, auth)
  local request_headers = build_headers(headers)

  if auth and auth.username and auth.password then
    local creds = auth.username .. ":" .. auth.password
    local b64 = helper.conversions.base64_encode(creds)
    table.insert(request_headers, "Authorization")
    table.insert(request_headers, "Basic " .. b64)
  end

  local resp_body, resp_code, resp_headers, resp_status = http.request{
    url = url,
    method = "GET",
    headers = request_headers
  }
  return resp_body, resp_code, resp_headers, resp_status
end

--- Send a POST request
---@param url string
---@param data string Body data
---@param headers? table
---@param auth? table
function helper.requests.post(url, data, headers, auth)
  local request_headers = build_headers(headers)  
  if data then
    table.insert(request_headers, "Content-Length")
    table.insert(request_headers, tostring(#data))
  end

  if auth and auth.username and auth.password then
    local creds = auth.username .. ":" .. auth.password
    local b64 = helper.conversions.base64_encode(creds)
    table.insert(request_headers, "Authorization")
    table.insert(request_headers, "Basic " .. b64)
  end

  local resp_body, resp_code, resp_headers, resp_status = http.request{
    url = url,
    method = "POST",
    source = ltn12 and ltn12.source.string(data) or nil,
    headers = request_headers
  }
  return resp_body, resp_code, resp_headers, resp_status
end

--- Send a PUT request
function helper.requests.put(url, data, headers, auth)
  local request_headers = build_headers(headers)
  if data then
    table.insert(request_headers, "Content-Length")
    table.insert(request_headers, tostring(#data))
  end

  if auth and auth.username and auth.password then
    local creds = auth.username .. ":" .. auth.password
    local b64 = helper.conversions.base64_encode(creds)
    table.insert(request_headers, "Authorization")
    table.insert(request_headers, "Basic " .. b64)
  end

  local resp_body, resp_code, resp_headers, resp_status = http.request{
    url = url,
    method = "PUT",
    source = ltn12 and ltn12.source.string(data) or nil,
    headers = request_headers
  }
  return resp_body, resp_code, resp_headers, resp_status
end

--- Send a PATCH request
function helper.requests.patch(url, data, headers, auth)
  local request_headers = build_headers(headers)
  if data then
    table.insert(request_headers, "Content-Length")
    table.insert(request_headers, tostring(#data))
  end

  if auth and auth.username and auth.password then
    local creds = auth.username .. ":" .. auth.password
    local b64 = helper.conversions.base64_encode(creds)
    table.insert(request_headers, "Authorization")
    table.insert(request_headers, "Basic " .. b64)
  end

  local resp_body, resp_code, resp_headers, resp_status = http.request{
    url = url,
    method = "PATCH",
    source = ltn12 and ltn12.source.string(data) or nil,
    headers = request_headers
  }
  return resp_body, resp_code, resp_headers, resp_status
end

--- Send a DELETE request
function helper.requests.delete(url, headers, auth)
  local request_headers = build_headers(headers)

  if auth and auth.username and auth.password then
    local creds = auth.username .. ":" .. auth.password
    local b64 = helper.conversions.base64_encode(creds)
    table.insert(request_headers, "Authorization")
    table.insert(request_headers, "Basic " .. b64)
  end

  local resp_body, resp_code, resp_headers, resp_status = http.request{
    url = url,
    method = "DELETE",
    headers = request_headers
  }
  return resp_body, resp_code, resp_headers, resp_status
end

--------------------------------------------------------------------------------
-- LOGGING (to file)
--------------------------------------------------------------------------------
helper.logging = {}

--- Create or open a log file for appending, write a log entry, and close.
---@param filepath string
---@param message string
function helper.logging.log_to_file(filepath, message)
  local file, err = io.open(filepath, "a")
  if not file then
    error("Failed to open log file: " .. (err or ""))
  end

  -- Simple timestamp
  local time_str = os.date("%Y-%m-%d %H:%M:%S")
  file:write(string.format("[%s] %s\n", time_str, message))
  file:close()
end

--------------------------------------------------------------------------------
-- FILE OPERATIONS
--------------------------------------------------------------------------------
helper.file = {}

--- Open a file
---@param path string
---@param mode string? default = "r"
---@return file*|nil file_handler
function helper.file.open(path, mode)
  mode = mode or "r"
  local f, err = io.open(path, mode)
  if not f then
    return nil, err
  end
  return f
end

--- Read entire file contents
---@param file_handler file*
---@return string contents
function helper.file.read(file_handler)
  if not file_handler then return nil, "No file handler" end
  return file_handler:read("*a")
end

--- Loop through lines
---@param file_handler file*
---@param callback function
function helper.file.loop_lines(file_handler, callback)
  if not file_handler then return end
  for line in file_handler:lines() do
    callback(line)
  end
end

--- Close file
---@param file_handler file*
function helper.file.close(file_handler)
  if not file_handler then return end
  file_handler:close()
end

--------------------------------------------------------------------------------
-- OS AND SUBPROCESS
--------------------------------------------------------------------------------
helper.os = {}

--- Get environment variable with optional default
---@param varname string
---@param default any
---@return any
function helper.os.get_env_var(varname, default)
  local val = os.getenv(varname)
  if val == nil then
    return default
  end
  return val
end

--- Run shell command
--- @param cmd string Command to run
--- @param options table? {return_output=true/false, wait=true/false}
--- @return string|number|nil result
---         If return_output=true, returns output as string
---         If return_output=false, returns exit code or nil
function helper.os.run_command(cmd, options)
  options = options or {}
  local return_output = options.return_output
  local wait = options.wait ~= false  -- default true

  if return_output then
    -- Capture command output
    local f = io.popen(cmd)
    local result = f:read("*a")
    local ok, exit_reason, exit_code = f:close()
    -- if not ok then
    --   error("Command failed: "..(exit_reason or "unknown"))
    -- end
    return result
  else
    -- Directly run. On many systems `os.execute` returns exit code (some might return status differently).
    local res, exit_reason, exit_code = os.execute(cmd)
    if wait then
      -- Typically, we wait automatically. So just return code or boolean
      if type(res) == "number" then
        return res
      else
        -- old lua versions might return boolean for success/fail
        return res
      end
    else
      -- If we do not wait, there's no standard built-in for async in plain Lua.
      -- This is a stub for demonstration.
      return nil
    end
  end
end

--------------------------------------------------------------------------------
-- DATA CONVERSIONS (base64, hex, zip, tar)
--------------------------------------------------------------------------------
helper.conversions = {}

-- Base64 encode/decode (simple pure Lua implementation)
local b64chars = 
  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

--- Encode a string in Base64
---@param s string
---@return string
function helper.conversions.base64_encode(s)
  local bytes = {s:byte(1, #s)}
  local encoded = {}

  for i = 1, #bytes, 3 do
    local b1 = bytes[i]
    local b2 = bytes[i + 1] or 0
    local b3 = bytes[i + 2] or 0

    local c1 = bit.rshift(b1, 2)
    local c2 = bit.bor(bit.lshift(bit.band(b1, 0x03), 4), bit.rshift(b2, 4))
    local c3 = bit.bor(bit.lshift(bit.band(b2, 0x0F), 2), bit.rshift(b3, 6))
    local c4 = bit.band(b3, 0x3F)

    encoded[#encoded + 1] = b64chars:sub(c1 + 1, c1 + 1)
    encoded[#encoded + 1] = b64chars:sub(c2 + 1, c2 + 1)

    if i + 1 <= #bytes then
      encoded[#encoded + 1] = b64chars:sub(c3 + 1, c3 + 1)
    else
      encoded[#encoded + 1] = "="
    end

    if i + 2 <= #bytes then
      encoded[#encoded + 1] = b64chars:sub(c4 + 1, c4 + 1)
    else
      encoded[#encoded + 1] = "="
    end
  end

  return table.concat(encoded)
end



function helper.conversions.base64_decode(s)
  s = s:gsub("%s", "") -- Remove whitespace

  local decoded = {}
  local pad = 0
  if s:sub(-2) == "==" then
    pad = 2
  elseif s:sub(-1) == "=" then
    pad = 1
  end

  s = s:gsub("=", "") -- Strip padding for processing

  for i = 1, #s, 4 do
    local c1 = (b64chars:find(s:sub(i, i)) or 1) - 1
    local c2 = (b64chars:find(s:sub(i+1, i+1)) or 1) - 1
    local c3 = (b64chars:find(s:sub(i+2, i+2)) or 1) - 1
    local c4 = (b64chars:find(s:sub(i+3, i+3)) or 1) - 1

    local b1 = bit.bor(bit.lshift(c1, 2), bit.rshift(c2, 4))
    local b2 = bit.bor(bit.lshift(bit.band(c2, 0x0F), 4), bit.rshift(c3, 2))
    local b3 = bit.bor(bit.lshift(bit.band(c3, 0x03), 6), c4)

    table.insert(decoded, string.char(b1))
    if (i + 2) <= #s and pad < 2 then
      table.insert(decoded, string.char(b2))
    end
    if (i + 3) <= #s and pad < 1 then
      table.insert(decoded, string.char(b3))
    end
  end

  return table.concat(decoded)
end


---@param s string
---@return string
function helper.conversions.to_hex(s)
  return (s:gsub(".", function(c)
    return string.format("%02x", c:byte())
  end))
end

--- Convert a hexadecimal string back to normal string
---@param hex string
---@return string
function helper.conversions.from_hex(hex)
  return (hex:gsub("%x%x", function(cc)
    return string.char(tonumber(cc, 16))
  end))
end

--- (Naive) Zip a single file using system command or stub
--- For real usage, use a robust library or an OS-level zip command.
---@param input_path string
---@param output_zip string
function helper.conversions.zip_file(input_path, output_zip)
  -- Attempt system zip command
  local cmd = string.format('zip -j %q %q', output_zip, input_path)
  local res = os.execute(cmd)
  if not res then
    error("System 'zip' command failed or not available.")
  end
end

--- (Naive) Unzip a file using system command
---@param zip_path string
---@param output_dir string
function helper.conversions.unzip_file(zip_path, output_dir)
  local cmd = string.format('unzip %q -d %q', zip_path, output_dir)
  local res = os.execute(cmd)
  if not res then
    error("System 'unzip' command failed or not available.")
  end
end

--- (Naive) Tar a directory using system command
---@param input_dir string
---@param output_tar string
function helper.conversions.tar_directory(input_dir, output_tar)
  local cmd = string.format('tar -cf %q -C %q .', output_tar, input_dir)
  local res = os.execute(cmd)
  if not res then
    error("System 'tar' command failed or not available.")
  end
end

--- (Naive) Untar a file using system command
---@param tar_path string
---@param output_dir string
function helper.conversions.untar_file(tar_path, output_dir)
  local cmd = string.format('tar -xf %q -C %q', tar_path, output_dir)
  local res = os.execute(cmd)
  if not res then
    error("System 'tar' command failed or not available.")
  end
end

--------------------------------------------------------------------------------
-- Return the master table
--------------------------------------------------------------------------------
return helper
