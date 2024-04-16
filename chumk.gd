extends Area2D

@onready var main = get_node("/root/Main") #fetches the main node

var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	%Particles.visible = false
	
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast")
		%Sprite2D.material.set_shader_parameter("active", contrast)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if main.grace == true:
		%Particles.visible = true
	else:
		%Particles.visible = false
