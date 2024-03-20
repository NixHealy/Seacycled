extends CharacterBody2D

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var norm_tex = load("res://img/newray.png")

var activated = false

func _physics_process(delta):	
	if activated:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 1.0)
	else:
		for node in %Outline.get_children():
			node.material.set_shader_parameter("alpha", 0.0)
	
	if main.grace == true and main.tutorial == false and main.all_collected == true:
		modulate.a = 1
		if main.all_collected == true:
			#%Help.visible = true
			#%HelpLabel.text = "..."
			%Popup.visible = false
			%Speech.visible = true
			for body in %Area2D.get_overlapping_bodies():
				if body.is_in_group("player"):
					#%HelpLabel.text = "I'll paralyse those mutants!\n[Cost: 2 Chumks]"
					%Popup.visible = true
					%Speech.visible = false
	else:
		#%Help.visible = false
		%Popup.visible = false
		%Speech.visible = false
	if activated:
		#%Help.visible = false
		%Popup.visible = false
		%Speech.visible = false
		
	if activated == false && main.grace == true && main.all_collected == true:
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player") and Input.is_action_just_pressed("attack"):
				if body.chumks >= 10:
					body.chumks -= 10
					activate()
	
	if !activated:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if (enemies.size() > 0):
		var closest = enemies[enemies.size() - 1]
	
		for enemy in enemies:
			if !enemy.is_in_group("spike"):
				if enemy.stunned == false:
					if enemy.global_position.distance_to(coral.global_position) < closest.global_position.distance_to(coral.global_position):
						closest = enemy
				
		var direction = closest.global_position - global_position
		velocity = direction.normalized() * 30000 * delta
		move_and_slide()
		
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
			if closest.has_method("get_stunned") and %StunTimer.is_stopped() and !closest.is_in_group("spike"):
				closest.get_stunned() 
				%Sprite2D.set_texture(norm_tex)
				%StunTimer.start()

func _on_stun_timer_timeout():
	%Sprite2D.set_texture(norm_tex)

func activate():
	activated = true
