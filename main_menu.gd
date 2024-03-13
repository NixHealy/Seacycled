extends Node

func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_how_to_pressed():
	get_tree().change_scene_to_file("res://tutorial.tscn")

func _on_options_pressed():
	%OptionsMenu.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_accept_pressed():
	if %OptionsMenu.visible == true:
		%OptionsMenu.visible = false

func _on_cancel_pressed():
	if %OptionsMenu.visible == true:
		%OptionsMenu.visible = false
