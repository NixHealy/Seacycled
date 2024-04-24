extends CharacterBody2D

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var activated = false

var config = ConfigFile.new()

func _ready():
	%Popup.global_scale = Vector2(1, 1)
	%Speech.global_scale = Vector2(0.2, 0.2)
	
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast", false)
		%Sprite2D.material.set_shader_parameter("active", contrast)

		var sfx = config.get_value("Options", "sfx", 1.0)
		%ScrubSound.volume_db = log(sfx) * 20

func _physics_process(delta):
	for node in %Outline.get_children():
		node.frame = %Sprite2D.frame
	
	if activated:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 1.0)
	else:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 0.0)
	
	%Sprite2D.speed_scale = 0.25
	
	if !activated:
		return
	
	var pollutions = get_tree().get_nodes_in_group("pollution")
	
	if (pollutions.size() > 0):
		var closest = pollutions[pollutions.size() - 1]
	
		for pollution in pollutions:
			if pollution.stunned == false:
				if pollution.global_position.distance_to(coral.global_position) < closest.global_position.distance_to(coral.global_position):
					closest = pollution
				
		var direction = closest.global_position - global_position
		velocity = direction.normalized() * 10000 * delta
		if coral.is_polluted == true:
			move_and_slide()
			%Sprite2D.speed_scale = 3
						
			rotation = atan(velocity.y / velocity.x)
			
			if velocity.x > 0:
				$Sprite2D.flip_h = true
				for node in %Outline.get_children():
					node.flip_h = true
			else:
				$Sprite2D.flip_h = false
				for node in %Outline.get_children():
					node.flip_h = false
		
		if closest.global_position.distance_to(global_position) < 100:
			if closest.has_method("take_damage"):
				closest.take_damage() 
				%ScrubSound.play()

func activate():
	activated = true
