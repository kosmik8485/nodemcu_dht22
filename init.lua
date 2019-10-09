dofile('config.lua')
do
	function startup()
		if file.open("main.lua") == nil then
			print("main.lua deleted or renamed!")
		else
			print("Running...")
			dofile("main.lua")		
		end
	end

	-- WIFI events
	wifi_connect_event = function(T)
		print("Connecting to AP("..T.SSID..") established!")
		print("Waiting for IP address...")
		if disconnect_ct ~= nil then disconnect_ct = nil end
	end

	wifi_got_ip_event = function(T)
		print("Wifi connection is ready! IP address is:"..T.IP)
		print("Startup will resume momentarily, you have 3 seconds to abort.")
		print("Waiting...")
		tmr.create():alarm(3000, tmr.ALARM_SINGLE, startup)
	end

	wifi_disconnect_event = function(T)
		if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then
			return
		end

		local total_tries = 10
		print("\nWifi connection to AP("..T.SSID..") has failed!")

		for key,val in pairs(wifi.eventmon.reason) do
			if val == T.reason then
				print("Disconnect reason: "..val.."("..key..")")
				break
			end
		end

		if disconnect_ct == nil then
			disconnect_ct = 1
		else
			disconnect_ct = disconnect_ct + 1
		end

		if disconnect_ct < total_tries then
			print("Retrying connection...(attempt "..(disconnect_ct+1).." of "..total_tries..")")
		else
			wifi.sta.disconnect()
			print("Aborting connection to AP!")

			disconnect_ct = nil
		end
	end

	-- Reg wifi event callback
	wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
	wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
	wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)
	
	raw_code, reset_reason = node.bootreason()
	--print("Booting: " .. reset_reason .. " [ " .. raw_code .. " ] ")
	if reset_reason == 0 then
		print("Power ON! Starting ESP" .. node.chipid() .. "...")
	elseif reset_reason == 4 then
		print("Softreset!")
	elseif reset_reason == 5 then
		print("WakeUp!")
	else
		print("Some reason: " .. reset_reason .. " [ " .. raw_code .. " ]")
	end
	
	if reset_reason == 5 then
		wifi.resume(function() 
			wifi.setmode(wifi.STATION)
			wifi.sta.config(WIFI_STATION)
		end)
	else
		wifi.setmode(wifi.STATION)
		wifi.sta.config(WIFI_STATION)
	end
	
	print("WiFi mode: " .. wifi.getmode() .. "\nWiFi phymode: " .. wifi.getphymode())
end	
