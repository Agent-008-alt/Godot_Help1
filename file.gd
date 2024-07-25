extends CharacterBody2D

@export var Speed = 600
var can_attack = false

var can_sword = true
var can_dash = true
var melee_count = 1
@export var dash_speed = 250
@onready var anim = $Animation
@onready var sprite = $PlayerSprite
@onready var health_bar = $Health_Bar
@onready var sword_cd = $Sword_Cooldown
@onready var punch_collision = $kh_punch/punch_collision
@onready var kick_collision = $kh_kick/Kick_collision
@onready var sword_collision = $kh_sword/sword_collision
@onready var uppercut_collision = $kh_uppercut/uppercut_collision
@onready var melee_count_check = $Melee_Count_Check
@onready var punch_cooldown = $Punch_cooldown
@onready var melee_timer1 = $melee_timer1
@onready var melee_timer2 = $melee_timer2
@onready var melee_timer3 = $melee_timer3





#Melee Stages
enum Melee{
	Idle,
	Punch,
	Kick,
	Uppercut
	}

var current_melee_state = Melee.Idle

func _physics_process(delta):
	
	
	flip_sprites()
	get_input()
	move_and_slide()


func _ready():
	pass



func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * Speed
	
	
	var dash_direction = Input.get_axis("left", "right")
	
	
	#Punch Attack
	if Input.is_action_just_pressed("x_attack") :
		if current_melee_state == Melee.Idle:
			melee_timer1.start()
			anim.play("Punch")
			
			current_melee_state = Melee.Punch
		
		elif current_melee_state == Melee.Punch:
			melee_timer1.stop()
			anim.play("Kick")
			melee_timer2.start()
			current_melee_state = Melee.Kick
			
		elif current_melee_state == Melee.Kick:
			anim.play("Uppercut")
			melee_timer2.stop()
			current_melee_state = Melee.Uppercut
			melee_timer3.start()
			
			
	
		
		
	
	
	
	
	
	#Sword Attack 
	if Input.is_action_just_pressed("a_attack") and can_sword:
		velocity.y = 0
		velocity.x = 0
		anim.play("Sword")
		sword_cd.start()
		can_sword = false
	
	#Dash Attack
	if Input.is_action_just_pressed("y_attack") and can_dash:
		anim.play("Dash")
		
		velocity = input_direction * dash_speed * 60
	
	
	
	if Input.is_action_just_pressed("v_attack"):
		velocity = input_direction * dash_speed * 2000
	
	
	player_movement()




func player_movement():
	if anim.current_animation != "Punch" and anim.current_animation != "Kick" and anim.current_animation != "Sword" and anim.current_animation != "Dash" and anim.current_animation != "Uppercut":
		if velocity.x != 0 or velocity.y != 0:
			anim.play("Walk")
		else:
			anim.play("Idle")
			




func _on_sword_cooldown_timeout():
	can_sword = true




#Can Attack functions
func _on_attack_area_body_entered(body):
	if body.name == "main_collision":
		if body.is_in_group("Enemy"):
			can_attack = true


func _on_attack_area_body_exited(body):
	if body.is_in_group("Enemy"):
		can_attack = false




func flip_sprites():
	
	if velocity.x < 0:
		sprite.flip_h = true
		sword_collision.position.x = -143
		punch_collision.position.x = -180.839
		kick_collision.position.x = -117
		uppercut_collision.position.x = -97

	if velocity.x > 0:
		
		sprite.flip_h = false
		sword_collision.position.x = 115
		punch_collision.position.x = 27.161
		kick_collision.position.x = 117
		uppercut_collision.position.x = 97




func take_damage_gdro1d():
	
	health_bar.value -= 3
	
	
	if health_bar.value <= 0:
		queue_redraw()











func _on_melee_count_check_timeout():
	current_melee_state = Melee.Idle
	melee_count_check.stop()


func _on_punch_timer_timeout():
	current_melee_state = Melee.Idle
	melee_timer1.stop()
	


func _on_melee_timer_2_timeout():
	current_melee_state = Melee.Idle
	melee_timer2.stop()


func _on_melee_timer_3_timeout():
		current_melee_state = Melee.Idle
		melee_timer3.stop()
