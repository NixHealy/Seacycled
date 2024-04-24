extends StaticBody2D

var activated = false
var show_popup = false
@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var config = ConfigFile.new()

func _ready():
	%Popup.global_rotation = 0
	%Speech.global_rotation = 0
	%Popup.global_scale = Vector2(1, 1)
	%Speech.global_scale = Vector2(0.2, 0.2)
	
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast", false)
		%Sprite2D.material.set_shader_parameter("active", contrast)
	
func _process(delta):
	for node in %Outline.get_children():
		node.frame = %Sprite2D.frame
	
	#only one urchin should display popup
	var urchins = get_tree().get_nodes_in_group("urchin")
	var selected = urchins[urchins.size() - 1]
	for urchin in urchins:
		if urchin.global_position.y < selected.global_position.y:
			selected = urchin
	
	selected.show_popup = true
	
	if main.grace == true:
		modulate.a = 1
		
	if activated:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 1.0)
	else:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 0.0)
		
	#if main.grace == true and main.all_collected == true && main.tutorial == false:
		##%Help.visible = true
		##%HelpLabel.text = "..."
		#%Popup.visible = false
		#if show_popup == true:
			#%Speech.visible = true
		#for body in %Area2D.get_overlapping_bodies():
			#if body.is_in_group("player"):
				##%HelpLabel.text = "I'll protect the coral!\n[Cost: 1 Chumk]"
				#if show_popup == true:
					#%Popup.visible = true
					#%Speech.visible = false
	#else:
		##%Help.visible = false
		#%Popup.visible = false
		#%Speech.visible = false
	#if activated:
		##%Help.visible = false
		#%Popup.visible = false
		#%Speech.visible = false
		#
	#if activated == false && main.grace == true && main.all_collected == true && main.tutorial == false:
		#for body in %Area2D.get_overlapping_bodies():
			#if body.is_in_group("player") and Input.is_action_just_pressed("attack"):
				#if body.chumks >= 10:
					#body.chumks -= 10
					#for urchin in get_tree().get_nodes_in_group("urchin"):
						#urchin.activated = true

func _on_area_2d_body_entered(body):
	if body.has_method("get_poisoned") and activated:
		body.get_poisoned()
		%PoisonSound.play()
