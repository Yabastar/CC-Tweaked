local args = {...}

local function readLuaCode(filename)
  local file = fs.open(filename, "r")
  local lua_code_lines = {}

  if file then
    local line = file.readLine()
    while line do
      table.insert(lua_code_lines, line)
      line = file.readLine()
    end

    file.close()
  end

  return lua_code_lines
end

local function writeLuaCode(filename, lua_code_lines)
  local file = fs.open(filename, "w")

  for i, line in ipairs(lua_code_lines) do
    file.writeLine(line)
  end

  file.close()
end

local function appendDriverAssignment(filename, key, value)
  local lua_code_lines = readLuaCode(filename)

  -- Construct the assignment string
  local assignment = string.format('drivers["%s"] = "%s"', key, value)
  table.insert(lua_code_lines, assignment)

  writeLuaCode(filename, lua_code_lines)
end

local function getDriverValue(filename, key)
  local lua_code_lines = readLuaCode(filename)

  -- Find the assignment for the specified key
  local pattern = string.format('drivers\\["%s"\\]%s*=.-', key, '%s*')
  for i, line in ipairs(lua_code_lines) do
    if line:match(pattern) then
      local value = line:match('"(.*)"')
      print(value)
      return
    end
  end

  print("Key not found in the driver assignments.")
end

-- Main logic
if #args < 3 then
  print("Usage: drivermod set [key] [value]")
  print("       drivermod get [key]")
  print("\nFind examples of how to use the drivers in the 'examples' folder located in the folder 'rom'.")
  return
end

local command = args[1]
local key = args[2]
local value = args[3]

if command == "set" then
  appendDriverAssignment("rom/driverbase.lua", key, value)
  print("Driver assignment added successfully.")
elseif command == "get" then
  getDriverValue("rom/driverbase.lua", key)
else
  print("Invalid command.")
end
