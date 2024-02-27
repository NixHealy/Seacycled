extends CharacterBody2D

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node

var norm_tex = load("res://img/ray.png")
var zap_tex = load("res://img/zap.png")

func _physics_process(delta):
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if (enemies.size() > 0):
		var closest = enemies[enemies.size() - 1]
	
		for enemy in enemies:
			if enemy.stunned == false:
				if enemy.global_position.distance_to(coral.global_position) < closest.global_position.distance_to(coral.global_position):
					closest = enemy
				
		var direction = closest.global_position - global_position
		velocity = direction.normalized() * 20000 * delta
		move_and_slide()
		
		if closest.global_position.distance_to(global_position) < 100:
			if closest.has_method("get_stunned") and %StunTimer.is_stopped():
				closest.get_stunned() 
				%Sprite2D.set_texture(zap_tex)
				%StunTimer.start()

func _on_stun_timer_timeout():
	%Sprite2D.set_texture(norm_tex)
