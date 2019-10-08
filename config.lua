-- wifi STATION
WIFI_STATION = {}
WIFI_STATION.ssid = 'home_srv2'
WIFI_STATION.pwd  = '89857824690'

--wifi AP
WIFI_AP = {}
WIFI_AP.ssid = 'esp_dht_0.0.1'
WIFI_AP.auth = wifi.WPA_WPA2_PSK
WIFI_AP.pwd  = '123456789'

-- mqtt
MQTT_IP        = "192.168.88.249"
MQTT_PORT      = 1883
MQTT_CLIENT_ID = "ESP8266-"..node.chipid()
MQTT_REFRESH   = 10 * 1000
MQTT_USER	     = "pi"
MQTT_PASS      = "raspberry"
TOPIC          = 'dht22/'

-- gpio
DATA_PIN = 2
