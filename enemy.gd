extends CharacterBody2D

class_name Enemy

# Fetch the coral node
@onready var coral = get_node("/root/Main/Coral")

# Enemy properties
var health = 2
var speed = 50.0
var stunned = false
var resisted = false

# Configuration file
var config = ConfigFile.new()

# Signal emitted when the enemy dies
signal died

func _ready():
	# Load settings from options file if available
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		# Set contrast shader parameter based on options
		var contrast = false
		contrast = config.get_value("Options", "contrast", false)
		%AnimatedSprite2D.material.set_shader_parameter("active", contrast)

func _physics_process(delta):
	# Check if enemy health is zero or less, then die
	if health <= 0:
		die()
	
	# Update animation frame for child nodes
	for node in %AnimatedOutline.get_children():
		node.frame = %AnimatedSprite2D.frame
	
	# Calculate direction towards the coral
	var direction = coral.global_position - global_position
	
	# Adjust velocity based on direction
	if direction.length() > 500 and (direction.x > 100 or direction.x < -100):
		direction = Vector2(direction.x, 0)
		velocity = direction.normalized() * speed
	else:
		velocity = direction.normalized() * (speed * 3)
	
	# Move if enemy not stunned
	if stunned == false:
		move_and_slide()
	
	# Flip sprite horizontally based on velocity direction
	if velocity.x > 0:
		%AnimatedSprite2D.flip_h = true
		for node in %AnimatedOutline.get_children():
			node.flip_h = true
	else:
		%AnimatedSprite2D.flip_h = false
		for node in %AnimatedOutline.get_children():
			node.flip_h = false

# Function to reduce enemy health when damaged
func take_damage():
	health -= 1
	modulate = Color(modulate.r, modulate.g - 0.25, modulate.b - 0.25)

# Function to handle enemy death
func die():
	# Drop chumk after death
	if is_in_group("enemy"):
		var new_chumk = preload("res://chumk.tscn").instantiate()
		add_child(new_chumk)
		new_chumk.global_scale = Vector2(1, 1)
		new_chumk.reparent(get_node("/root/Main"))
	queue_free()
	died.emit()

# Function to stun the enemy
func get_stunned():
	stunned = true
	modulate = Color(modulate.r, modulate.g, modulate.b - 0.25)
	%StunTimer.start()
	%ShockEffect.emitting = true
	
	# Pause enemy animation
	var anim = get_node_or_null("%AnimatedSprite2D")
	if anim != null:
		%AnimatedSprite2D.pause()

# Function to poision the enemy
func get_poisoned():
	modulate = Color(modulate.r - 0.25, modulate.g, modulate.b - 0.25)
	stunned = true
	%PoisonTimer.start()

func _on_stun_timer_timeout():
	stunned = false
	modulate = Color(1, 1, 1)
	
	# Resume enemy animation
	var anim = get_node_or_null("%AnimatedSprite2D")
	if anim != null:
		%AnimatedSprite2D.pause()

func _on_poison_timer_timeout():
	stunned = false
	take_damage() # Take damage from poison effect
