extends Node

var config
var config_items = {}

func _ready():
	config = ConfigFile.new()
	var err = config.load("user://aranoid.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		set_defaults()
		return

	set_value('sound_volume', config.get_value("prefs", "sound_volume", 18))

func get_value(key):
	return config_items[key]

func set_value(key, value):
	config_items[key] = value
	
	if key == 'sound_volume':
		var _bus := AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(_bus, linear_to_db(value / 18.0))

func set_defaults():
	config_items['sound_volume'] = 18

func save_settings():
	config.set_value("prefs", "sound_volume", int(config_items['sound_volume']))
	config.save("user://aranoid.cfg")