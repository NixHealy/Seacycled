extends Sprite2D

var config = ConfigFile.new()

func _on_accept_pressed():
	config.save("user://options.ini")
	visible = false

func _on_cancel_pressed():
	visible = false

func _on_music_bar_value_changed(value):
	config.set_value("Options", "volume", value)

func _on_visibility_changed():
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		%MusicBar.value = config.get_value("Options", "volume")
		%ContrastButton.button_pressed = config.get_value("Options", "contrast")

func _on_contrast_button_toggled(toggled_on):
	if toggled_on:
		%ContrastButton.text = "ON"
	else:
		%ContrastButton.text = "OFF"
	config.set_value("Options", "contrast", toggled_on)
