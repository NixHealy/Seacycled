extends Node

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://stage_select.tscn")

func _on_options_button_pressed():
	pass # Replace with function body.

func _on_how_to_button_pressed():
		get_tree().change_scene_to_file("res://howto.tscn")
