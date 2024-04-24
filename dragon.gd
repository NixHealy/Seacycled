extends CharacterBody2D

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var activated = false
var config = ConfigFile.new()

func _ready():
	%Popup.global_scale = Vector2(1, 1)
	%Speech.global_scale = Vector2(-0.2, -0.2)
	%Speech.flip_h = true
	
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast", false)
		%Sprite2D.material.set_shader_parameter("active", contrast)

func _physics_process(delta):
	for node in %Outline.get_children():
		node.frame = %Sprite2D.frame
		
	if coral.health < 100 and main.grace:
		if %Sprite2D.get_animation() != "heal":
			%Sprite2D.set_animation("heal")
			for node in %Outline.get_children():
				node.set_animation("heal")
	else:
		%Sprite2D.set_animation("default")
		for node in %Outline.get_children():
			node.set_animation("default")
	
	if activated:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 1.0)
	else:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 0.0)
	
	if !activated:
		return

	var direction = Vector2(coral.global_position.x - 20, coral.global_position.y + 50) - global_position
	velocity = direction.normalized() * 30000 * delta
	if direction.length() > 20:
		move_and_slide()

func activate():
	activated = true

func _on_heal_timer_timeout():
	if main.grace == true and activated == true:
		if coral.health < 95:
			coral.health = coral.health + 5
		else:
			coral.health = 100
