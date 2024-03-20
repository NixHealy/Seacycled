extends Sprite2D

var config = ConfigFile.new()

func _on_accept_pressed():
	config.save("user://options.ini")
	visible = false

func _on_cancel_pressed():
	visible = false

func _on_music_bar_value_changed(value):
	# remember to actually modify the volume by reading this
	config.set_value("Options", "volume", value)

func _on_visibility_changed():
	config.load("user://options.ini")
	var volume = config.get_value("Options", "volume")
	%MusicBar.value = volume
