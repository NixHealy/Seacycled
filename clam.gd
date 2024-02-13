extends StaticBody2D

@onready var main = get_node( "/root/Main")

var open_tex = load("res://img/open.png")
var close_tex = load("res://img/closed.png")
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	%Sprite2D.set_texture(close_tex)
	%TopCollision.set_deferred("disabled", true)
	%BottomCollision.set_deferred("disabled", true)
	global_position.y += 130

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_open == false && main.grace == true:
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player"):
				if body.chumks >= 2:
					body.chumks -= 2
					open()

func open():
	%Sprite2D.set_texture(open_tex)
	%TopCollision.set_deferred("disabled", false)
	%BottomCollision.set_deferred("disabled", false)
	is_open = true 
	global_position.y -= 120
