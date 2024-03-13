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
		#%HelpLabel.scale.x = -1
		#%HelpLabel.position.x += %Help.size.x
		%Popup.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_open == false && main.grace == true && main.all_collected == true && main.tutorial == false:
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player"):
				# Input required so user doesn't accidentally spend chumks
					if Input.is_action_just_pressed("attack"):
						if body.chumks >= 10:
							body.chumks -= 10
							open()
	
	# The clam should snap closed if there are more than five enemies inside
	if is_open:
		var numEnemies = 0
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("enemy"):
				numEnemies += 1
		if numEnemies > 5:
			for body in %Area2D.get_overlapping_bodies():
				if body.is_in_group("enemy"):
					body.queue_free()
			close()
			numEnemies = 0

		
	if main.grace == true and main.tutorial == false:
		modulate.a = 1
		if player.chumks >= 2 and main.all_collected == true:
			#%Help.visible = true
			#%HelpLabel.text = "..."
			%Popup.visible = false
			for body in %Area2D.get_overlapping_bodies():
				if body.is_in_group("player"):
					#%HelpLabel.text = "I'll stop those enemies in their path!\n[Cost: 2 Chumks]"
					%Popup.visible = true
	else:
		%Help.visible = false
		%Popup.visible = false
		
	if is_open:
		%Help.visible = false
		%Popup.visible = false

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
