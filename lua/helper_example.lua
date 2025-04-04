local helper = require("utils.helper")

-- TABLE (LIST-LIKE)
local mylist = {1,2,3}
helper.list.append(mylist, 4)        -- {1,2,3,4}
helper.list.drop_index(mylist, 2)    -- {1,3,4}
print(helper.list.length(mylist))    -- 3

-- DICT (DICTIONARY-LIKE)
local mydict = {}
helper.dict.add(mydict, "name", "Alice")
helper.dict.add(mydict, "age", 30)
print(helper.dict.count(mydict))     -- 2
helper.dict.del(mydict, "age")
print(helper.dict.count(mydict))     -- 1

-- REQUESTS (Requires LuaSocket)
local body, code, resp_headers = helper.requests.get("http://example.com", {Accept="text/html"})
print(code, body)

-- LOGGING
helper.logging.log_to_file("mylog.txt", "This is a log entry")

-- FILE
local f, err = helper.file.open("somefile.txt", "r")
if f then
  helper.file.loop_lines(f, function(line)
    print("Got line:", line)
  end)
  helper.file.close(f)
else
  print("Error opening file:", err)
end

-- OS / SUBPROCESS
print(helper.os.get_env_var("HOME", "/tmp"))
local cmd_output = helper.os.run_command("ls -1", {return_output=true})
print("Command output:", cmd_output)

-- DATA CONVERSIONS
local b64 = helper.conversions.base64_encode("Hello Lua!")
print("Base64 of 'Hello Lua!':", b64)
print("Decoded:", helper.conversions.base64_decode(b64))

local hexed = helper.conversions.to_hex("abc123")
print("Hex of 'abc123':", hexed)
print("From hex:", helper.conversions.from_hex(hexed))

