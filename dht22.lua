function GetDHTData(pin)
	status, temp, humi, temp_dec, humi_dec = dht.read(pin)
	if status == dht.OK then
		print("DHT Temp: "..temp.." Humidity: "..humi.."\r\n")
		return {temperature=temp, humidity=humi}
	elseif status == dht.ERROR_CHECKSUM then
		print("DHT Checksum error.")
	elseif status == dht.ERROR_TIMEOUT then
		print("DHT timed out.")
	end
	return {temperature=0,humidity=0}
end
