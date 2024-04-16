extends CharacterBody2D

#maybe add health
var health = 1
var stunned = false
var config = ConfigFile.new()

func _ready():
	position = Vector2(20,0).rotated(rotation)
	
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast")
		%Sprite2D.material.set_shader_parameter("active", contrast)

func _physics_process(delta):
		
	velocity = Vector2(200, 0).rotated(rotation)
	move_and_slide()
	
func get_stunned():
	pass

func get_poisoned():
	pass
