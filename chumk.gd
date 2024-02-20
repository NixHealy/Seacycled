extends Area2D

@onready var main = get_node("/root/Main") #fetches the main node

# Called when the node enters the scene tree for the first time.
func _ready():
	%Particles.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if main.grace == true:
		%Particles.visible = true
	else:
		%Particles.visible = false
