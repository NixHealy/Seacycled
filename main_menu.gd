extends Node

var vx = randi() % 200 - 100
var vy = randi() % 200 - 100

func _process(delta):
	if %Fish.position.x < 700:
		vx = vx + 1.0
	if %Fish.position.x > 800:
		vx = vx - 1.0
	if %Fish.position.y > 400:
		vy = vy - 0.7
	if %Fish.position.y < 400:
		vy = vy + 0.7
	%Fish.velocity = Vector2(vx, vy)
	%FishSprite.rotation = atan(%Fish.velocity.y / %Fish.velocity.x)
	if %Fish.velocity.x > 0:
		%FishSprite.flip_h = true
	else:
		%FishSprite.flip_h = false
	%Fish.move_and_slide()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_how_to_pressed():
	#get_tree().change_scene_to_file("res://tutorial.tscn")
	pass

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
