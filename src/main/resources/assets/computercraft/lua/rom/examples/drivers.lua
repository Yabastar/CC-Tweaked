drivers = dofile("rom/driverbase.lua")
reddriver = drivers["rednet"]
result = dofile(reddriver)
print(result)
