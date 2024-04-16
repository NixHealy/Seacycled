extends CharacterBody2D

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var activated = false
var config = ConfigFile.new()

func _ready():
	%Popup.global_scale = Vector2(1, 1)
	%Speech.global_scale = Vector2(-0.2, 0.2)

func _physics_process(delta):
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast")
		%Sprite2D.material.set_shader_parameter("active", contrast)
		
	if activated:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 1.0)
	else:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 0.0)
	
	if main.grace == true and main.tutorial == false and main.all_collected == true:
			#%Help.visible = true
			#%HelpLabel.text = "..."
			%Popup.visible = false
			%Speech.visible = true
			for body in %Area2D.get_overlapping_bodies():
				if body.is_in_group("player"):
					%Popup.visible = true
					%Speech.visible = false
	else:
		#%Help.visible = false
		%Popup.visible = false
		%Speech.visible = false
	if activated:
		#%Help.visible = false
		%Popup.visible = false
		%Speech.visible = false
		
	if activated == false && main.grace == true && main.all_collected == true:
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player") and Input.is_action_just_pressed("attack"):
				if body.chumks >= 10:
					body.chumks -= 10
					activate()
	
	if !activated:
		return

	var direction = coral.global_position - global_position
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
