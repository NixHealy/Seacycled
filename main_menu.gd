extends Node

var vx = randi_range(-100, 100)
var vy = randi_range(-100, 100)

func _ready():
	# Create new ConfigFile object.
	var config = ConfigFile.new()

	# Store some values.
	config.set_value("Options", "volume", 100)

	# Save it to a file (overwrite if already exists).
	config.save("user://scores.cfg")

func _process(delta):
	if %Fish.position.x < 700:
		vx = vx + 2.0
	if %Fish.position.x > 800:
		vx = vx - 2.0
	if %Fish.position.y > 400:
		vy = vy - 2.0
	if %Fish.position.y < 400:
		vy = vy + 2.0
	%Fish.velocity = Vector2(vx, vy)
	%FishSprite.rotation = atan(vy / vx)
	
	var speed = sqrt(vx * vx + vy * vy)
	if speed > 500:
		vx = (vx/speed) * 500
		vy = (vy/speed) * 500
	if speed < 100:
		vx = (vx/speed) * 100
		vy = (vy/speed) * 100
	
	if %Fish.velocity.x > 0:
		%FishSprite.flip_h = true
	else:
		%FishSprite.flip_h = false
	%Fish.move_and_slide()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_how_to_pressed():
	get_tree().change_scene_to_file("res://tutorial.tscn")

func _on_options_pressed():
	%OptionsMenu.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_background_music_finished():
	%BackgroundMusic.play()
