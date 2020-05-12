extends KinematicBody2D



const DAGGER = preload("res://scenes/weapons/Dagger.tscn")
const UP = Vector2(0, -1)
const SLOPE_STOP = 64

onready var raycasts = $Raycasts
onready var dagger_timer = $Timer/DaggerTimer
onready var hero_sword_timer = $Timer/HeroSwordTimer

var can_shoot := true
var player_health : float = 100
var dagger_number : float = 0
var jump_velocity = -100
var move_speed = 5 * 16
var _gravity = 100
var player_velocity = Vector2(0,0)
var weapon_choice : int
var is_grounded



func _ready() -> void:
	dagger_timer.set_wait_time(0.5)
	hero_sword_timer.set_wait_time(0.5)
	$Body/HeroSword/CollisionShape2D.disabled = true





func _on_Pause_pressed() -> void:
	get_tree().change_scene("res://scenes/UI/Windows/PauseMenu.tscn")


func _on_DaggerTimer_timeout() -> void:
	can_shoot = true

func _on_HeroSwordTimer_timeout() -> void:
	$Body/HeroSword/AnimatedSprite.stop()
	$Body/HeroSword/AnimatedSprite.set_frame(0)
	$Body/HeroSword/CollisionShape2D.disabled = true



func _on_PickUpArea_area_entered(area: Area2D) -> void: #increases dagger number by 1
	if area.get_parent().name == "PickUpDagger":
		dagger_number += 1
	elif area.get_parent().name == "HealthPotion":
		player_health += 50

func _on_enemyDetector_area_entered(area: Area2D) -> void:
	player_health -= area.dammage


func _physics_process(delta: float) -> void:
	_get_input()
	is_grounded = _check_is_grounded()
	player_velocity.y += _gravity * delta
	player_velocity = move_and_slide(player_velocity, UP, SLOPE_STOP)
	
	
	animation()
	
	
	#dagger
	dagger_number = min(dagger_number, 10)
	dagger_number()
	
	
	
	#weapon choice
	weapon_equiped()
	weapon_show()
	
	#attack
	attack()
	
	#updates health and kills play if player_health == 0
	$UI/HealthBar.value = player_health 
	player_health = $UI/HealthBar.value 
	player_health = min(player_health, 100)
	if player_health == 0:
		die()





func _get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	player_velocity.x = lerp(player_velocity.x, move_speed * move_direction, _get_h_weight())
	if move_direction != 0:
		$Body.scale.x = move_direction

func _input(event: InputEvent) -> void: #jump
	if event.is_action_pressed("jump") && is_grounded:
		player_velocity.y = jump_velocity


func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
			
	return false

func _get_h_weight():
	return 0.2 if is_grounded else 0.1


func animation():
	if player_velocity.x == 0:
		$Body/Sprite.play("Idle")
	elif player_velocity.x != 0:
		$Body/Sprite.play("Run")


func hero_sword_attack():#sword attack
	if Input.is_action_just_pressed("left mouse button"):
		if $Body/Sprite.flip_h == false:
			$Body/HeroSword/AnimatedSprite.play()
			$Body/HeroSword/CollisionShape2D.disabled = false
		hero_sword_timer.start()


func dagger_fire():
	var dagger = DAGGER.instance()
	get_parent().add_child(dagger)
	if $Body.scale.x == -1:
		dagger.dagger_speed *= -1
	dagger.position = $DaggerSpawnPosition.global_position
	dagger_timer.start()
	can_shoot = false

func dagger_deacrease():#decresses number of daggers by 1
	dagger_number -= 1 

func dagger_number():
	if dagger_number == 1:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.hide()
		$UI/WeaponMenu/DaggerScore/Dagger3.hide()
		$UI/WeaponMenu/DaggerScore/Dagger4.hide()
		$UI/WeaponMenu/DaggerScore/Dagger5.hide()
		$UI/WeaponMenu/DaggerScore/Dagger6.hide()
		$UI/WeaponMenu/DaggerScore/Dagger7.hide()
		$UI/WeaponMenu/DaggerScore/Dagger8.hide()
		$UI/WeaponMenu/DaggerScore/Dagger9.hide()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()
	elif dagger_number == 2:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.show()
		$UI/WeaponMenu/DaggerScore/Dagger3.hide()
		$UI/WeaponMenu/DaggerScore/Dagger4.hide()
		$UI/WeaponMenu/DaggerScore/Dagger5.hide()
		$UI/WeaponMenu/DaggerScore/Dagger6.hide()
		$UI/WeaponMenu/DaggerScore/Dagger7.hide()
		$UI/WeaponMenu/DaggerScore/Dagger8.hide()
		$UI/WeaponMenu/DaggerScore/Dagger9.hide()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()
	elif dagger_number == 3:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.show()
		$UI/WeaponMenu/DaggerScore/Dagger3.show()
		$UI/WeaponMenu/DaggerScore/Dagger4.hide()
		$UI/WeaponMenu/DaggerScore/Dagger5.hide()
		$UI/WeaponMenu/DaggerScore/Dagger6.hide()
		$UI/WeaponMenu/DaggerScore/Dagger7.hide()
		$UI/WeaponMenu/DaggerScore/Dagger8.hide()
		$UI/WeaponMenu/DaggerScore/Dagger9.hide()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()
	elif dagger_number == 4:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.show()
		$UI/WeaponMenu/DaggerScore/Dagger3.show()
		$UI/WeaponMenu/DaggerScore/Dagger4.show()
		$UI/WeaponMenu/DaggerScore/Dagger5.hide()
		$UI/WeaponMenu/DaggerScore/Dagger6.hide()
		$UI/WeaponMenu/DaggerScore/Dagger7.hide()
		$UI/WeaponMenu/DaggerScore/Dagger8.hide()
		$UI/WeaponMenu/DaggerScore/Dagger9.hide()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()
	elif dagger_number == 5:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.show()
		$UI/WeaponMenu/DaggerScore/Dagger3.show()
		$UI/WeaponMenu/DaggerScore/Dagger4.show()
		$UI/WeaponMenu/DaggerScore/Dagger5.show()
		$UI/WeaponMenu/DaggerScore/Dagger6.hide()
		$UI/WeaponMenu/DaggerScore/Dagger7.hide()
		$UI/WeaponMenu/DaggerScore/Dagger8.hide()
		$UI/WeaponMenu/DaggerScore/Dagger9.hide()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()
	elif dagger_number == 6:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.show()
		$UI/WeaponMenu/DaggerScore/Dagger3.show()
		$UI/WeaponMenu/DaggerScore/Dagger4.show()
		$UI/WeaponMenu/DaggerScore/Dagger5.show()
		$UI/WeaponMenu/DaggerScore/Dagger6.show()
		$UI/WeaponMenu/DaggerScore/Dagger7.hide()
		$UI/WeaponMenu/DaggerScore/Dagger8.hide()
		$UI/WeaponMenu/DaggerScore/Dagger9.hide()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()
	elif dagger_number == 7:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.show()
		$UI/WeaponMenu/DaggerScore/Dagger3.show()
		$UI/WeaponMenu/DaggerScore/Dagger4.show()
		$UI/WeaponMenu/DaggerScore/Dagger5.show()
		$UI/WeaponMenu/DaggerScore/Dagger6.show()
		$UI/WeaponMenu/DaggerScore/Dagger7.show()
		$UI/WeaponMenu/DaggerScore/Dagger8.hide()
		$UI/WeaponMenu/DaggerScore/Dagger9.hide()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()
	elif dagger_number == 8:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.show()
		$UI/WeaponMenu/DaggerScore/Dagger3.show()
		$UI/WeaponMenu/DaggerScore/Dagger4.show()
		$UI/WeaponMenu/DaggerScore/Dagger5.show()
		$UI/WeaponMenu/DaggerScore/Dagger6.show()
		$UI/WeaponMenu/DaggerScore/Dagger7.show()
		$UI/WeaponMenu/DaggerScore/Dagger8.show()
		$UI/WeaponMenu/DaggerScore/Dagger9.hide()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()
	elif dagger_number == 9:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.show()
		$UI/WeaponMenu/DaggerScore/Dagger3.show()
		$UI/WeaponMenu/DaggerScore/Dagger4.show()
		$UI/WeaponMenu/DaggerScore/Dagger5.show()
		$UI/WeaponMenu/DaggerScore/Dagger6.show()
		$UI/WeaponMenu/DaggerScore/Dagger7.show()
		$UI/WeaponMenu/DaggerScore/Dagger8.show()
		$UI/WeaponMenu/DaggerScore/Dagger9.show()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()
	elif dagger_number == 10:
		$UI/WeaponMenu/DaggerScore/Dagger1.show()
		$UI/WeaponMenu/DaggerScore/Dagger2.show()
		$UI/WeaponMenu/DaggerScore/Dagger3.show()
		$UI/WeaponMenu/DaggerScore/Dagger4.show()
		$UI/WeaponMenu/DaggerScore/Dagger5.show()
		$UI/WeaponMenu/DaggerScore/Dagger6.show()
		$UI/WeaponMenu/DaggerScore/Dagger7.show()
		$UI/WeaponMenu/DaggerScore/Dagger8.show()
		$UI/WeaponMenu/DaggerScore/Dagger9.show()
		$UI/WeaponMenu/DaggerScore/Dagger10.show()
	elif dagger_number == 0:
		$UI/WeaponMenu/DaggerScore/Dagger1.hide()
		$UI/WeaponMenu/DaggerScore/Dagger2.hide()
		$UI/WeaponMenu/DaggerScore/Dagger3.hide()
		$UI/WeaponMenu/DaggerScore/Dagger4.hide()
		$UI/WeaponMenu/DaggerScore/Dagger5.hide()
		$UI/WeaponMenu/DaggerScore/Dagger6.hide()
		$UI/WeaponMenu/DaggerScore/Dagger7.hide()
		$UI/WeaponMenu/DaggerScore/Dagger8.hide()
		$UI/WeaponMenu/DaggerScore/Dagger9.hide()
		$UI/WeaponMenu/DaggerScore/Dagger10.hide()



func weapon_equiped():
	if Input.is_action_just_pressed("one"):
		weapon_choice = 1
		$UI/WeaponMenu/WeaponChoice/DaggerTexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
		$UI/WeaponMenu/WeaponChoice/HeroSwordtexture/ColorRect.color = Color(0.0,0.0,0.0,0.120)
	elif Input.is_action_just_pressed("two"):
		weapon_choice = 2
		$UI/WeaponMenu/WeaponChoice/DaggerTexture/ColorRect.color = Color(0.0,0.0,0.0,0.120)
		$UI/WeaponMenu/WeaponChoice/HeroSwordtexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
	elif Input.is_action_just_pressed("three"):
		weapon_choice = 3
		$UI/WeaponMenu/WeaponChoice/DaggerTexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
		$UI/WeaponMenu/WeaponChoice/HeroSwordtexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
	elif Input.is_action_just_pressed("four"):
		weapon_choice = 4
		$UI/WeaponMenu/WeaponChoice/DaggerTexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
		$UI/WeaponMenu/WeaponChoice/HeroSwordtexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
	elif Input.is_action_just_pressed("five"):
		weapon_choice = 5
		$UI/WeaponMenu/WeaponChoice/DaggerTexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
		$UI/WeaponMenu/WeaponChoice/HeroSwordtexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
	elif Input.is_action_just_pressed("six"):
		weapon_choice = 6
		$UI/WeaponMenu/WeaponChoice/DaggerTexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
		$UI/WeaponMenu/WeaponChoice/HeroSwordtexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
	elif Input.is_action_just_pressed("seven"):
		weapon_choice = 7
		$UI/WeaponMenu/WeaponChoice/DaggerTexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
		$UI/WeaponMenu/WeaponChoice/HeroSwordtexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
	elif Input.is_action_just_pressed("eight"):
		weapon_choice = 8
		$UI/WeaponMenu/WeaponChoice/DaggerTexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
		$UI/WeaponMenu/WeaponChoice/HeroSwordtexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
	elif Input.is_action_just_pressed("nine"):
		weapon_choice = 9
		$UI/WeaponMenu/WeaponChoice/DaggerTexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)
		$UI/WeaponMenu/WeaponChoice/HeroSwordtexture/ColorRect.color = Color(0.0,0.0,0.0,0.0)

func weapon_show():
	if weapon_choice == 0:
		$Body/HeroSword.hide()
		$Body/DaggerSprite.hide()
	elif weapon_choice == 1:
		$Body/HeroSword.show()
		$Body/DaggerSprite.hide()
	elif weapon_choice == 2:
		$Body/HeroSword.hide()
		if dagger_number != 0:
			$Body/DaggerSprite.show()
		else:
			$Body/DaggerSprite.hide()
	elif weapon_choice == 3:
		$Body/HeroSword.show()
		$Body/DaggerSprite.hide()
	elif weapon_choice == 4:
		$Body/HeroSword.show()
		$Body/DaggerSprite.hide()
	elif weapon_choice == 5:
		$Body/HeroSword.show()
		$Body/DaggerSprite.hide()
	elif weapon_choice == 6:
		$Body/HeroSword.show()
		$Body/DaggerSprite.hide()
	elif weapon_choice == 7:
		$Body/HeroSword.show()
		$Body/DaggerSprite.hide()
	elif weapon_choice == 8:
		$Body/HeroSword.show()
		$Body/DaggerSprite.hide()
	elif weapon_choice == 9:
		$Body/HeroSword.show()
		$Body/DaggerSprite.hide()



func attack():
	if can_shoot == true and dagger_number > 0 and weapon_choice == 2:
		if Input.is_action_just_pressed("left mouse button"):
			dagger_fire()
			dagger_deacrease()
	elif weapon_choice == 1:
			hero_sword_attack()



func die():
	queue_free()
	get_tree().change_scene("res://scenes/UI/Windows/GameOver.tscn")


