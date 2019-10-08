-- wifi
WIFI_STATION = {}
WIFI_STATION.ssid = 'home_srv2'
WIFI_STATION.pwd  = '89857824690'

-- mqtt
MQTT_IP        = "192.168.88.249"
MQTT_PORT      = 1883
MQTT_CLIENT_ID = "ESP8266-"  .. node.chipid()
MQTT_REFRESH   = 10000
MQTT_USER	     = "pi"
MQTT_PASS      = "raspberry"

-- gpio
DATA_PIN = 2

-- deep sleep
-- 30 sec
DSLEEP_TIME = 30000000 
-- 
DSLEEP_MODE = 4
