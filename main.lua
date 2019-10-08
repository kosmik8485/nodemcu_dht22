require('config')
require('dht22')

m  = mqtt.Client(MQTT_CLIENT_ID, 120, MQTT_USER, MQTT_PASS)
ip = wifi.sta.getip()

m:lwt("/offline", '{"message":"'..MQTT_CLIENT_ID..'", "topic":"'..TOPIC..'", "ip":"'..ip..'"}',0,0)

print("Connecting to MQTT: "..MQTT_IP..":"..MQTT_PORT.."...")

m:connect(MQTT_IP, MQTT_PORT, 0, function(conn)
	print("Connected to MQTT: "..MQTT_IP..":"..MQTT_PORT.." as "..MQTT_CLIENT_ID)
	
	dht_data = GetDHTData(DATA_PIN)
	
	DATA = '{"mac":"'..wifi.sta.getmac()..'", "ip":"'..ip..'", "refresh":"'..MQTT_REFRESH..'",'
	DATA = DATA..' "temperature":"'..dht_data.temperature..'", "humidity":"'..dht_data.humidity..'"}"'
	
	-- send json
	m:publish(TOPIC..'json', DATA, 0, 0, function(conn)
		print(MQTT_CLIENT_ID.." sending data: "..DATA.." to "..TOPIC.."json")
	end)
	
	-- send temperature
	m:publish(TOPIC..'temp', dht_data.temperature, 0, 0, function(conn)
		print(MQTT_CLIENT_ID.." sending temperature("..dht_data.temperature..") only to "..TOPIC.."temp")
	end)
	
	-- send humidity
	m:publish(TOPIC..'h', dht_data.humidity, 0, 0, function(conn)
		print(MQTT_CLIENT_ID.." sending humidity("..dht_data.humidity..") only to "..TOPIC.."h")
	end)
	
	tmr.create():alarm(MQTT_REFRESH, tmr.ALARM_AUTO, function()
		dht_data = GetDHTData(DATA_PIN)
		
		DATA = '{"mac":"'..wifi.sta.getmac()..'", "ip":"'..ip..'", "refresh":"'..MQTT_REFRESH..'",'
		DATA = DATA..' "temperature":"'..dht_data.temperature..'", "humidity":"'..dht_data.humidity..'"}"'
	
		-- send json
		m:publish(TOPIC..'json', DATA, 0, 0, function(conn)
			print(MQTT_CLIENT_ID.." sending data: "..DATA.." to "..TOPIC.."json")
		end)
	
		-- send temperature
		m:publish(TOPIC..'temp', dht_data.temperature, 0, 0, function(conn)
			print(MQTT_CLIENT_ID.." sending temperature("..dht_data.temperature..") only to "..TOPIC.."temp")
		end)
		
		-- send humidity
		m:publish(TOPIC..'h', dht_data.humidity, 0, 0, function(conn)
			print(MQTT_CLIENT_ID.." sending humidity("..dht_data.humidity..") only to "..TOPIC.."h")
		end)
	end)
end)
