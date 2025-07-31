extends Node2D

var base_speed = 5
var mood = 0
var char_frame = 0
var mood_list = [
	[0.25,0.5,0.75,1,1.5],
	[0.25,0.5,0.5,0.5,0.25],
	[0.5,0.75,0.75,0.5,1],
	[0.25,0.25,0.75,1.5,2],
	[1.5,1.5,0.5,0.75,0.75]
]

var mood_color = [
	Color.BLUE,			#Normal
	Color.RED,			#Very bad
	Color.ORANGE,		#Bad
	Color.YELLOW,		#Good
	Color.WEB_GREEN		#Very good
]

@onready var character_sprite = $AnimatedSprite2D
@onready var cooldown = $Cooldown
@onready var moodSprite = $Mood

var Name_list = [
	2.3,					#"Pyro"
	2.4,					#"Magpie"
	2.6,					#"RippinKittin"
	2.8,					#"Boss"
	2.9,					#"Frivelk"
	2.6,					#"Shakary"
	2.2,					#"Warspite"
	2.5,					#"Roach"
	2.4,					#"Panini"
	2.1 					#"Pengus"
]

var total_speed = 0

func _ready() -> void:
	init_character()
	init_mood()
	cooldown.start()

func init_character():
	var r = randi_range(0,Name_list.size() - 1)
	character_sprite.frame = r
	base_speed = Name_list[r]
	char_frame = r

func init_mood():
	var r = randi_range(0, mood_list.size() - 1)
	mood = mood_list[r]
	moodSprite.modulate = mood_color[r]
	mood_selector(r)

func mood_picker():
	var r = randi_range(0, mood.size() - 1)
	return mood[r]
	
func speed_changer():
	var r = randf_range(0, 2)
	var speed_changed = base_speed * r + base_speed * mood_picker()
	cooldown.wait_time = mood_picker()
	if speed_changed > int(base_speed * 3):
		return base_speed * mood_picker()
	if speed_changed <= 0:
		return base_speed
	return speed_changed

func _on_cooldown_timeout() -> void:
	total_speed = speed_changer()
	cooldown.start()

func mood_selector(value):
	match value:
		0:
			moodSprite.rotation = deg_to_rad(90)
		1:
			moodSprite.rotation = deg_to_rad(180)
		2:
			moodSprite.rotation = deg_to_rad(135)
		3:
			moodSprite.rotation = deg_to_rad(45)
		4:
			moodSprite.rotation = deg_to_rad(0)
			
