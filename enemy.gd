extends CharacterBody2D

class_name Enemy

@onready var coral = get_node("/root/Main/Coral") #fetches the coral node
var health = 2
var speed = 100.0
var stunned = false
var resisted = false

var config = ConfigFile.new()

signal died

func _ready():
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast")
		%AnimatedSprite2D.material.set_shader_parameter("active", contrast)

func _physics_process(delta):
		
	if health <= 0:
		die()
	
	for node in %AnimatedOutline.get_children():
		node.frame = %AnimatedSprite2D.frame
	
	var direction = coral.global_position - global_position  #goes to the coral
	if direction.length() > 1000 and (direction.x > 100 or direction.x < -100):
		direction = Vector2(direction.x, 0)
		velocity = direction.normalized() * speed
	else:
		velocity = direction.normalized() * (speed * 2)
	
	if stunned == false:
		move_and_slide()

	#%Sprite2D.rotation = atan(velocity.y / velocity.x) #temporarily removed because it was not playing nice with collision
	#rotation_degrees = snapped(rotation_degrees, 45) 
		
	if velocity.x > 0:
		%AnimatedSprite2D.flip_h = true
		for node in %AnimatedOutline.get_children():
			node.flip_h = true
	else:
		%AnimatedSprite2D.flip_h = false
		for node in %AnimatedOutline.get_children():
			node.flip_h = false
	
func take_damage():
	health -= 1
	modulate = Color(modulate.r, modulate.g - 0.25, modulate.b - 0.25)
		
func die(): #oh no its dead
	var chanceToDrop = randi_range(1,1) # 100% chance to drop a chumk after death, for now
	if is_in_group("enemy") && chanceToDrop == 1:
		var new_chumk = preload("res://chumk.tscn").instantiate()
		add_child(new_chumk)
		new_chumk.global_scale = Vector2(1, 1)
		new_chumk.reparent(get_node("/root/Main"))
	queue_free()
	died.emit()
	
func get_stunned():
	stunned = true
	modulate = Color(modulate.r, modulate.g, modulate.b - 0.25)
	%StunTimer.start()
	#%AnimatedSprite2D.pause()

func get_poisoned():
	modulate = Color(modulate.r - 0.25, modulate.g, modulate.b - 0.25)
	stunned = true
	%PoisonTimer.start()

func _on_stun_timer_timeout():
	stunned = false
	modulate = Color(1, 1, 1)
	#%AnimatedSprite2D.play()

func _on_poison_timer_timeout():
	stunned = false
	take_damage()
