extends CharacterBody2D

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
@onready var main = get_node("/root/Main")
@onready var player = get_node("/root/Main/Player")

var norm_tex = load("res://img/ray.png")
var zap_tex = load("res://img/zap.png")

var activated = false

func _physics_process(delta):
	if main.grace == true:
		modulate.a = 1
		if player.chumks >= 2 and main.all_collected == true:
			%Help.visible = true
	else:
		%Help.visible = false
	if activated:
		%Help.visible = false
		
	if activated == false && main.grace == true && main.all_collected == true:
		for body in %Area2D.get_overlapping_bodies():
			if body.is_in_group("player"):
				if body.chumks >= 2:
					body.chumks -= 2
					activate()
	
	if !activated:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if (enemies.size() > 0):
		var closest = enemies[enemies.size() - 1]
	
		for enemy in enemies:
			if enemy.stunned == false:
				if enemy.global_position.distance_to(coral.global_position) < closest.global_position.distance_to(coral.global_position):
					closest = enemy
				
		var direction = closest.global_position - global_position
		velocity = direction.normalized() * 30000 * delta
		move_and_slide()
		
		rotation = atan(velocity.y / velocity.x)
		if velocity.x > 0:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
		
		if closest.global_position.distance_to(global_position) < 100:
			if closest.has_method("get_stunned") and %StunTimer.is_stopped():
				closest.get_stunned() 
				%Sprite2D.set_texture(zap_tex)
				%StunTimer.start()

func _on_stun_timer_timeout():
	%Sprite2D.set_texture(norm_tex)

func activate():
	activated = true
