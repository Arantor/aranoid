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
	set_value('scale', config.get_value("prefs", "scale", 3))
	set_value('mouse_sensitivity', config.get_value("prefs", "mouse_sensitivity", 9))

func get_value(key):
	return config_items[key]

func set_value(key, value):
	config_items[key] = value
	
	if key == 'sound_volume':
		var _bus := AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(_bus, linear_to_db(value / 18.0))

	if key == 'scale':
		get_tree().root.size = Vector2i(320 * value, 180 * value)
		get_tree().root.position = (DisplayServer.screen_get_size() - get_tree().root.size) / 2


func set_defaults():
	config_items['sound_volume'] = 18
	config_items['scale'] = 3
	config_items['mouse_sensitivity'] = 9

func save_settings():
	config.set_value("prefs", "sound_volume", int(config_items['sound_volume']))
	config.set_value("prefs", "scale", int(config_items['scale']))
	config.set_value("prefs", "mouse_sensitivity", int(config_items['mouse_sensitivity']))
	config.save("user://aranoid.cfg")
