extends StaticBody2D

@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var open_tex = load("res://img/scaled/clam_open.png")
var close_tex = load("res://img/scaled/clam_closed.png")
var is_open = false
var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	%Popup.global_scale = Vector2(1, 1)
	%Speech.global_scale = Vector2(0.2, 0.2)
	
	%Sprite2D.set_texture(close_tex)
	for node in %Outline.get_children():
		node.set_texture(close_tex)
	%TopCollision.set_deferred("disabled", true)
	%BottomCollision.set_deferred("disabled", true)
	#global_position.y += 130
	
	if global_position.x < 500:
		#%HelpLabel.scale.x = -1
		#%HelpLabel.position.x += %Help.size.x
		%Popup.global_scale.x = -1
		%PopupLabel.scale.x = -1
		%PopupLabel.position.x = %PopupLabel.size.x
	
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast", false)
		%Sprite2D.material.set_shader_parameter("active", contrast)
		
		var sfx = config.get_value("Options", "sfx", 1.0)
		%CloseSound.volume_db = log(sfx) * 20
		%OpenSound.volume_db = log(sfx) * 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_open == true and %CloseTimer.is_stopped() and main.grace == false:
		%CloseTimer.start()
	
	#if is_open == false && main.grace == true && main.all_collected == true && main.tutorial == false:
		#for body in %Area2D.get_overlapping_bodies():
			#if body.is_in_group("player"):
				## Input required so user doesn't accidentally spend chumks
					#if Input.is_action_just_pressed("attack"):
						#if body.chumks >= 10:
							#body.chumks -= 10
							#open()
	
	# The clam should snap closed if there are more than five enemies inside
	#if is_open:
		#var numEnemies = 0
		#for body in %Area2D.get_overlapping_bodies():
			#if body.is_in_group("enemy"):
				#numEnemies += 1
		#if numEnemies > 5:
			#for body in %Area2D.get_overlapping_bodies():
				#if body.is_in_group("enemy"):
					#body.queue_free()
			#close()
			#numEnemies = 0

		
	#if main.grace == true and main.tutorial == false:
		#modulate.a = 1
		#if main.all_collected == true:
			##%Help.visible = true
			##%HelpLabel.text = "..."
			#%Popup.visible = false
			#%Speech.visible = true
			#for body in %Area2D.get_overlapping_bodies():
				#if body.is_in_group("player"):
					##%HelpLabel.text = "I'll stop those enemies in their path!\n[Cost: 2 Chumks]"
					#%Popup.visible = true
					#%Speech.visible = false
	#else:
		#%Help.visible = false
		#%Popup.visible = false
		#%Speech.visible = false
		#
	#if is_open:
		#%Help.visible = false
		#%Popup.visible = false
		#%Speech.visible = false

func open():
	%OpenSound.play()
	%Sprite2D.visible = false
	%Animation.visible = true
	%Animation.play()

func _on_animation_animation_finished():
	%Animation.visible = false
	%Sprite2D.visible = true
	is_open = true 
	%Sprite2D.set_texture(open_tex)
	for node in %Outline.get_children():
			node.set_texture(open_tex)
			node.material.set_shader_parameter("alpha", 1.0)
	%TopCollision.set_deferred("disabled", false)
	%BottomCollision.set_deferred("disabled", true) #bodge
	#global_position.y -= 120

func close():
	%CloseSound.play()
	is_open = false 
	%Sprite2D.set_texture(close_tex)
	for node in %Outline.get_children():
		if node.get_parent().get_parent().get_parent().is_open == false:
			node.set_texture(open_tex)
			node.material.set_shader_parameter("alpha", 0.0)
	%TopCollision.set_deferred("disabled", true)
	%BottomCollision.set_deferred("disabled", true)
	visible = false
	#global_position.y += 120


func _on_close_timer_timeout():
	for body in %Area2D.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			body.queue_free()
	close()



