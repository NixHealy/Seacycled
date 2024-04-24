extends Node

# Exports
@export var wave = 1
@export var grace = false

# Variables
var all_collected = true
var starting = true
var tutorial = false

# Volume and Config
var volume = 100.0
var config = ConfigFile.new()

func _ready():
	# Hide elements initially
	%GameOver.visible = false
	%Button.visible = false
	%HelpText.visible = false
	%CountdownSprite.play()
	
	# Load options if available
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		volume = config.get_value("Options", "volume", 1.0)
		%BackgroundMusic.volume_db = log(volume) * 20
	
		var contrast = false
		contrast = config.get_value("Options", "contrast", false)
		%Black.visible = contrast
		
		var sfx = config.get_value("Options", "sfx", 1.0)
		%CountdownMusic.volume_db = log(sfx) * 20

func _process(delta):
	
	%StartLabel.text = str(ceil(%StartTimer.time_left - 1))
	if %StartTimer.time_left < 1:
		%StartLabel.text = "GO!"
	
	if %StartTimer.is_stopped() and %BackgroundMusic.playing == false:
		%BackgroundMusic.play()
	
	if Input.is_action_just_pressed("pause"):
		%PauseMenu.visible = true
		get_tree().paused = true
	
	if starting == false:
		%EnemyTimer.wait_time = 1 - 0.1 * wave
		
		if %ProgressBar.value >= 100:
			%ProgressBar.value = 0
			wave += 1
			%WaveLabel.text = "Wave " + str(wave)
			
		%ChumkLabel.text = str(%Player.chumks)
		
		all_collected = true
		
		if grace == true:
			for i in get_children():
				if i.is_in_group("collectable"):
					all_collected = false
					break
					
		if all_collected == true and grace == true:
			%HelpText.text = "Now recruit allies or heal the coral!"
			%Button.visible = true
			%AllyButtons.visible = true
			if %HelpDelay.is_stopped():
				%HelpDelay.start()
		else:
			%HelpText.text = "Wave Over!\nCollect all the chumks!"
			%Button.visible = false

# If wave 1, only trevally enemies should spawn
# If wave 2, trevally and crab enemies should spawn
# If wave 3, trevally, crab and barracuda enemies should spawn
# wave 4+, all enemy types should spawn
func spawn_mob():
	var num = randi_range(1, 100)
	var new_mob = null
	
	# WAVE 1: Only Trevally enemies can spawn
	if wave == 1:
		new_mob = preload("res://trevally_enemy.tscn").instantiate()
		
	# WAVE 2: Trevally and Crab enemies can spawn
	elif wave == 2:
		if num >= 1 && num <= 70:
			# trevally enemy, high chance
			new_mob = preload("res://trevally_enemy.tscn").instantiate()
		else:
			# crab enemy, medium chance
			new_mob = preload("res://crab_enemy.tscn").instantiate()
			
	# WAVE 3: Trevally, Crab and Barracuda enemies can spawn
	elif wave == 3:
		if num >= 1 && num < 50:
			# trevally enemy, high chance
			new_mob = preload("res://trevally_enemy.tscn").instantiate()
		elif num >= 50 && num < 80:
			# crab enemy, medium chance
			new_mob = preload("res://crab_enemy.tscn").instantiate()
		else:
			# barracuda enemy, medium chance
			new_mob = preload("res://enemy.tscn").instantiate()
			
	# WAVE 4+: Trevally, Crab, Barracuda and Parrotfish can spawn
	elif wave == 4:
		if num >= 1 && num < 20:
			# Spawn Barracuda enemy, medium chance
			new_mob = preload("res://enemy.tscn").instantiate()
		elif num >= 20 && num < 50:
			# Spawn Crab enemy, high chance
			new_mob = preload("res://crab_enemy.tscn").instantiate()
		elif num >= 50 && num < 90:
			# Spawn Trevally enemy, high chance
			new_mob = preload("res://trevally_enemy.tscn").instantiate()
		else:
			# Spawn Parrotfish enemy, low chance
			new_mob = preload("res://parrotfish_enemy.tscn").instantiate()
			
	# WAVE 5+: All enemy types can spawn (FINAL WAVE, MUCH HARDER!)
	else:
		if num >= 1 && num < 15:
			# Spawn Barracuda enemy, medium chance
			new_mob = preload("res://enemy.tscn").instantiate()
		elif num >= 15 && num < 35:
			# Spawn Crab enemy, high chance
			new_mob = preload("res://crab_enemy.tscn").instantiate()
		elif num >= 35 && num < 60:
			# Spawn Trevally enemy, high chance
			new_mob = preload("res://trevally_enemy.tscn").instantiate()
		elif num >= 60 && num < 80:
			# Spawn Parrotfish enemy, low chance
			new_mob = preload("res://parrotfish_enemy.tscn").instantiate()
		else:
			# Spawn Pufferfish enemy, low chance
			new_mob = preload("res://puffer_enemy.tscn").instantiate()
	
	var numPath = randi_range(1, 2) #picks a random path to put it on
	if numPath == 1: # spawn enemy from the right-side
		%Path1.progress_ratio = randf() #chooses a point in the path
		new_mob.global_position = %Path1.global_position #and puts it there
	if numPath == 2: # spawn enemy from the left-side
		%Path2.progress_ratio = randf()
		new_mob.global_position = %Path2.global_position
	
	add_child(new_mob) # adds the enemy to the scene
	
	# Danger icon for approaching enemies
	var danger = preload("res://danger_icon.tscn").instantiate()
	if numPath == 1:
		danger.global_position = Vector2(100, new_mob.global_position.y)
	if numPath == 2:
		danger.global_position = Vector2(1000, new_mob.global_position.y)
	add_child(danger) # adds the danger icon to the scene
	
# Spawn sinking pollution from the top of the screen
func spawn_pollution():
	var new_poll = preload("res://pollution.tscn").instantiate()
	%PollowPath.progress_ratio = randf() # pick a random point across the top
	new_poll.global_position = %PollowPath.global_position # follow the path towards the coral
	add_child(new_poll) # adds the pollution to the scene

func _on_enemy_timer_timeout(): #timer between mob spawns
	spawn_mob() 
	
func _on_pollution_timer_timeout(): # timer between pollution spawns
	spawn_pollution()

func _on_coral_died(): #oh no the coral is dead
	%GameOver.visible = true #show the game over screen
	get_tree().paused = true # pause all entities

func _on_wave_timer_timeout(): # wave timer
	%ProgressBar.value += 1 # increment the progress bar
	
	if %ProgressBar.value >= 100: #if the wave is done
		if wave == 5: # check for win condition
			%UI.visible = false
			%GameOver.visible = true
			$GameOver/Label.text = "YOU WIN!"
			$GameOver/ColorRect.color = Color(0.2, 0.4, 1, 0.5)
			get_tree().paused = true
		
		%WaveTimer.stop()
		%EnemyTimer.stop()
		%PollutionTimer.stop()
		
		var enemies = get_tree().get_nodes_in_group("enemy") #delete all the enemies
		for enemy in enemies:
			enemy.queue_free()
		var pollutions = get_tree().get_nodes_in_group("pollution") #delete all the pollution
		for pollution in pollutions:
			pollution.queue_free()
		var chumks = get_tree().get_nodes_in_group("collectable")
		for chumk in chumks:
			if chumk.position.x < 0 or chumk.position.x > 1100:
				chumk.queue_free() # remove chunks from outside the visible window
		
		grace = true
		%Button.visible = false
		%HelpText.visible = false

# PAUSE MENU: reset button
func _on_reset_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

# START TIMER
func _on_start_timer_timeout():
	starting = false
	%EnemyTimer.start()
	%PollutionTimer.start()
	%WaveTimer.start()
	%StartLabel.visible = false

# loop the background music
func _on_background_music_finished():
	%BackgroundMusic.play()

func _on_help_delay_timeout():
	if grace == true:
		#%GraceLabel.visible = true
		%Button.visible = true

# PAUSE MENU: resume
func _on_resume_pressed():
	get_tree().paused = false
	%PauseMenu.visible = false
	%OptionsMenu.visible = false
	
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		volume = config.get_value("Options", "volume", 1.0)
		%BackgroundMusic.volume_db = log(volume) * 20
		
		var sfx = config.get_value("Options", "sfx", 1.0)
		for node in get_sfx_children($"."):
			if node.is_in_group("sfx"):
				node.volume_db = log(sfx) * 20
				
		%Player.norm_volume = log(sfx) * 20

# how to
func _on_how_to_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://tutorial.tscn")

# options
func _on_options_pressed():
	%OptionsMenu.visible = true

# main menu
func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")

# quit game
func _on_quit_pressed():
	get_tree().quit()

func get_sfx_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		if N.is_in_group("ally") or N.is_in_group("enemy") or N.is_in_group("player") or N.is_in_group("coral"):
			if N.get_child_count() > 0:
				nodes.append_array(get_sfx_children(N))
		elif N.is_in_group("sfx"):
			nodes.append(N)
	return nodes

func _on_button_pressed():
	if grace == true and all_collected == true:
		grace = false
		%WaveTimer.wait_time += 0.1
		%WaveTimer.start()
		%EnemyTimer.start()
		%PollutionTimer.start()
		%Button.visible = false
		%HelpText.visible = false
		%AllyButtons.visible = false


func _on_pause_button_pressed():
	%PauseMenu.visible = true
	get_tree().paused = true
