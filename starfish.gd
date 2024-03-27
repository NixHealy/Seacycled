extends Area2D

var activated = false
var show_popup = false

@onready var main = get_node("/root/Main")

func _ready():
	%Popup.global_rotation_degrees = 0
	%Speech.global_rotation = 0
	%Popup.global_scale = Vector2(1, 1)
	%Speech.global_scale = Vector2(0.2, 0.2)
	%Speech.flip_h = true
	for node in %Outline.get_children():
		node.material.set_shader_parameter("alpha", 0.0)

func _process(delta):
	#only one starfish should display popup
	var starfishes = get_tree().get_nodes_in_group("starfish")
	var selected = starfishes[starfishes.size() - 1]
	for starfish in starfishes:
		if starfish.global_position.x < selected.global_position.x:
			selected = starfish
	
	selected.show_popup = true
	
	if activated == false && main.grace == true && main.all_collected == true && main.tutorial == false:
		for body in %Armour.get_overlapping_bodies():
			if body.is_in_group("player"):
				
				if show_popup == true:
					%Popup.visible = true
				%Speech.visible = false
				
				# Input required so user doesn't accidentally spend chumks
				if Input.is_action_just_pressed("attack"):
					if body.chumks >= 5:
						body.chumks -= 5
						for starfish in starfishes:
							starfish.activated = true
						for node in %Outline.get_children():
							node.material.set_shader_parameter("alpha", 1.0)
							
			else:
				%Popup.visible = false
				if show_popup == true:
					%Speech.visible = true
	else:
		%Popup.visible = false
		%Speech.visible = false

func _on_armour_body_entered(body):
	if activated:
		if body.is_in_group("enemy") and !body.is_in_group("spike"):
			body.resisted = true
			%PokeSound.play()
