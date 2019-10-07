require('config')


-- TODO: либо коннектимся если точка из настроек есть, либо поднимаем свою мини точку
print("Starting ESP"..node.chipid().."...")

wifi.setmode(wifi.STATION)
wifi.sta.config(WIFI_STATION)

print('MAC address:', wifi.sta.getmac())

tmr.create():alarm(1000, tmr.ALARM_AUTO, function(cb_timer)
	if wifi.sta.getip() == nil then
		print("Waiting for IP address...")
	else
		cb_timer:unregister()
		print("Wifi connection estabilished")
		print("IP address: " .. wifi.sta.getip())
		if file.open("main.lua") ~= nil then
			dofile("main.lua")
		else
			print("main.lua doesn't eixst!")
		end
	end
end)
