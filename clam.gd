extends StaticBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var open_tex = load("res://img/open.png")
var close_tex = load("res://img/closed.png")
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	%Sprite2D.set_texture(close_tex)
	%TopCollision.set_deferred("disabled", true)
	%BottomCollision.set_deferred("disabled", true)
	global_position.y += 130
	
	if global_position.x < 0:
		%HelpLabel.scale.x = -1
		%HelpLabel.position.x += %Help.size.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_open == false && main.grace == true && main.all_collected == true:
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player"):
				if body.chumks >= 2:
					body.chumks -= 2
					open()
	
	if is_open == true:
		var ctr = 0
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("enemy"):
				ctr += 1
		if ctr > 5:
			for body in %Area2D.get_overlapping_bodies():
				if body.is_in_group("enemy"):
					body.queue_free()
			close()
			
	if main.grace == true:
		modulate.a = 1
		if player.chumks >= 2 and main.all_collected == true:
			%Help.visible = true
	else:
		%Help.visible = false
	if is_open:
		%Help.visible = false

func open():
	%Sprite2D.set_texture(open_tex)
	%TopCollision.set_deferred("disabled", false)
	%BottomCollision.set_deferred("disabled", false)
	is_open = true 
	global_position.y -= 120

func close():
	%Sprite2D.set_texture(close_tex)
	%TopCollision.set_deferred("disabled", true)
	%BottomCollision.set_deferred("disabled", true)
	is_open = false 
	global_position.y += 120
