require('config')
require('dht22')

m   = mqtt.Client(MQTT_CLIENT_ID, 120, MQTT_USER, MQTT_PASS)
ip  = wifi.sta.getip()
mac = wifi.sta.getmac()

m:lwt("esp/offline", '{"message":"'..MQTT_CLIENT_ID..'", "topic":"'..TOPIC..'", "ip":"'..ip..'"}',0,0)

function handle_mqtt_erro(client, reason)
	tmr.create():alarm(10*1000, tmr.ALARM_SINGLE, do_mqtt_connect)
end

local dht_timer = tmr.create()
cnt = 0
dht_timer:register(MQTT_REFRESH, tmr.ALARM_AUTO, function(t)
		dht_data = GetDHTData(DATA_PIN)
		
		DATA = '{"mac":"'..mac..'", "ip":"'..ip..'", "refresh":"'..MQTT_REFRESH..'",'
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
			
		cnt = cnt + 1
		
		if cnt >= 10 then
			cnt = 0
			t:stop()
		end
end)

function handle_mqtt_connect(client)
	print("Connected to MQTT: "..MQTT_IP..":"..MQTT_PORT.." as "..MQTT_CLIENT_ID)
	
	dht_data = GetDHTData(DATA_PIN)
	
	DATA = '{"mac":"'..mac..'", "ip":"'..ip..'", "refresh":"'..MQTT_REFRESH..'",'
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
	
	dht_timer:start()
end

function do_mqtt_connect()
	m:connect(MQTT_IP, MQTT_PORT, 0, handle_mqtt_connect, hanlde_mqtt_error)
end

print("Connecting to MQTT: "..MQTT_IP..":"..MQTT_PORT.."...")

do_mqtt_connect()
