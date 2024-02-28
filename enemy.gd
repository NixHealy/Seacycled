extends CharacterBody2D

class_name Enemy

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
var health = 2
var speed = 100.0
var stunned = false

signal died

func _physics_process(delta):
	if health <= 0:
		die()
	
	var direction = coral.global_position - global_position  #goes to the coral
	if direction.length_squared() > 500000 and direction.x > 100:
		direction = Vector2(direction.x, 0)
		velocity = direction.normalized() * speed
	else:
		velocity = direction.normalized() * (speed * 3)
	
	if stunned == false:
		move_and_slide()

	#rotation = atan(velocity.y / velocity.x) #temporarily removed because it was not playing nice with collision
	#rotation_degrees = snapped(rotation_degrees, 45) 
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
		
func take_damage():
	health -= 1
	modulate = Color(1, 0.5, 0.5, 1)
		
func die(): #oh no its dead
	if is_in_group("enemy"):
		var new_chumk = preload("res://chumk.tscn").instantiate()
		add_child(new_chumk)
		new_chumk.global_scale = Vector2(1, 1)
		new_chumk.reparent(get_node("/root/Main"))
	queue_free()
	died.emit()
	
func get_stunned():
	stunned = true
	modulate = Color(1, 1, 0.5)
	%StunTimer.start()

func _on_stun_timer_timeout():
	stunned = false
	modulate = Color(1, 1, 1)
