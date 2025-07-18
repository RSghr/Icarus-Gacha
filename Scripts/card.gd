extends Node2D

@onready var card = $"."
@onready var card_frame = $Frame
@onready var character = $Character_Frame
@onready var card_shine = $Shine
var card_shine_anim
@onready var card_name = $Name
@onready var card_grade = $Grade
@onready var card_desc = $Description
@onready var card_edition = $Edition
@onready var anim_player = $AnimationPlayer

var card_params = {
	"grade": "F",
	"name": "Pyro",
	"edition": 1,
	"description": "Placeholder"
}


var flipped = false
var grade_color = Color.WHITE
var toDestroy := true

#InspectVars
var inspected = false
var inspect_pos = null
var eyeing = false

var Name_Chance = [
	50,                     #0 : 500
	40,                   	#1 : 900
	40,                    	#2 : 1300
	35,              		#5 : 1750
	35,                     #9 : 2100
	30,                    	#3 : 2400
	30,                     #6 : 2700
	15,                   	#7 : 2850
	10,                  	#8 : 2850
	4,                    	#4 : 2890
	1       				#10: 2900
]	

var Name_list = {
	"Pyro" : 0,                      #0
	"Magpie" : 1,                    #1
	"RippinKittin" : 2,              #2
	"Boss" : 3,                      #5
	"Frivelk" : 4,                   #9
	"Shakary" : 5,                   #3
	"Warspite" : 6,                  #6
	"Roach" : 7,                     #7
	"Panini" : 8,                    #8
	"Pengus" : 9,                    #4
	"Roach Summer Edition" : 10      #10
}

var desc_list = {
	"Masterful baker when not on missions, he brings bread instead of extra magazines. He knows where the hellbomb is." : 0,																						#0
	"Her messed up sleep schedule allows her to deploy at times when the enemy expects it the least.\nShe packs an extra hellbomb but she never let anyone know where it is hidden." : 1,							#1
	"He is a methodical killer, expert in laser weaponry, and he loves to spend his 2.4 seconds of free time with his pet Jowie.\nJowie is a good corgi." : 2,														#2
	"No matter who she's facing, with the giant Greatsword in her hand, she will scream \"woMEN GO IN!!\" and charge straight into battle." : 3,																	#5
	"SEAF usually chant a traditionnal chime when they get a glance of her, it goes like : \"Tu Tu Tu TURU MAX VERSTAPPEN!\" " : 4,																					#9
	"First human hybrid, she spends FTL travel time making a new armor that fits her tail." : 5,																													#3
	"She is playful and sassy, she loves to bully SEAF soldiers on her free time.\nShe is the top member of the piss laser Department." : 6,																		#6
	"She is quite reserved but cares deeply about her comrades, she can go above and beyond for them.\nHer only flaw, is that she doesn't know how to respond to compliments without fleeing the scene." : 7,		#7
	"Helps out in the bakery, she is known as the \"MASTER BAKER\", but also as the leader of Icarus squad. She's ready to carry the burden of her allies anytime." : 8,											#8
	"Sometimes you can hear her evil laugh down the hallways of the destroyer...\nNever trust her when she says \"I have a plan, hear me out\"." : 9,                    											#4
	"Holy shit her boobs are huge!" : 10,      																																										#10
	"R̵̨̄Ẹ̴̑D̸͎͐͋A̴̞̎C̸̻̒T̷̥͐̋E̸̦͋D̷̨͓̆" : 11																																																		#11
}

var Grade_Chance = [
	100,          # F : 1000
	150,          # E : 2500
	125,          # D : 3750
	75,          # C : 4500
	25,          # B : 4750
	10,          # A : 4850
	4,           # S : 4890
	1            # S+: 4900
]

var Grade_list = [
	"F",
	"E",
	"D",
	"C",
	"B",
	"A",
	"S",
	"S+"
]

var color_list = {
	"F" : Color.WEB_GRAY,
	"E" : Color.WEB_GRAY,
	"D" : Color.WEB_GREEN,
	"C" : Color.WEB_GREEN,
	"B" : Color.BLUE,
	"A" : Color.DEEP_PINK,
	"S" : Color.GOLDENROD,
	"S+": Color.FIREBRICK,
	"Z"	: Color.BLACK
}

func grade_random():
	var r = randi_range(1, 4900)
	var cumulative = 0
	card_edition.text = str(r + int(card_edition.text))
	for i in range(0, Grade_Chance.size()):
		cumulative += Grade_Chance[i] * 10
		if r < cumulative:
			return Grade_list[i]
	return "Z"

func name_random():
	var r = randi_range(1, 2900)
	var cumulative = 0
	card_edition.text = str(r + int(card_edition.text))
	for i in range(0, Name_Chance.size()):
		cumulative += Name_Chance[i] * 10
		if r < cumulative:
			card_desc.text = desc_list.find_key(i)
			return Name_list.find_key(i)
	card_desc.text = desc_list.find_key(-1)
	return "GLITCHED"

func grade_color_picker():
	grade_color = color_list[card_grade.text]

func Color_Applier():
	card_frame.modulate = grade_color
	card_name.modulate = grade_color
	card_desc.modulate = grade_color
	if card_params["grade"] == "Z":
		card_desc.modulate = Color.GRAY
	card_grade.modulate = grade_color
	card_shine.modulate = grade_color
	card_shine.get_child(0).modulate.a = 0

func Frame_Applier():
	if card_name.text in Name_list:
		character.frame = Name_list[card_name.text]
		card_desc.text = desc_list.find_key(Name_list[card_name.text])
	else:
		var r = randi_range(0, 11)
		character.frame = r
		card_desc.text = desc_list.find_key(11)
		glitched_color_applier()

func glitched_color_applier():
	var r = randi_range(0, Grade_list.size() - 1)
	var glitched_color = color_list[Grade_list[r]]
	card_frame.modulate = glitched_color
	r = randi_range(0, Grade_list.size() - 1)
	glitched_color = color_list[Grade_list[r]]
	card_name.modulate = glitched_color
	r = randi_range(0, Grade_list.size() - 1)
	glitched_color = color_list[Grade_list[r]]
	card_desc.modulate = glitched_color
	if Grade_list[r] == "Z":
		card_desc.modulate = Color.GRAY
	r = randi_range(0, Grade_list.size() - 1)
	glitched_color = color_list[Grade_list[r]]
	card_grade.modulate = glitched_color
	r = randi_range(0, Grade_list.size() - 1)
	glitched_color = color_list[Grade_list[r]]
	card_shine.modulate = glitched_color
	card_shine.get_child(0).modulate.a = 0

func randomize_Name_Grade():
	card_edition.text = "0"
	card_name.text = name_random()
	card_grade.text = grade_random()
	init_card()

func init_card():
	grade_color_picker()
	Color_Applier()
	Frame_Applier()
	export_vars()
	
func export_vars():
	card_params["name"] = card_name.text
	card_params["grade"] = card_grade.text
	card_params["edition"] = card_edition.text
	card_params["description"] = card_desc.text

func import_vars():
	card_edition.text = card_params["edition"]
	card_name.text = card_params["name"]
	card_grade.text = card_params["grade"]
	card_desc.text = card_params["description"]
	init_card()

func _ready() :
	randomize_Name_Grade()
	card_shine_anim = card_shine.get_child(1)

func flip_card():
	if !flipped:
		anim_player.play("Card_Flip")
		flipped = true

func _on_button_button_down():
	flip_card()
	
func _on_button_mouse_entered() -> void:
	if !flipped :
		card_shine_anim.play("Shine_Appear")

func _on_button_mouse_exited() -> void:
	if !flipped :
		card_shine_anim.play_backwards("Shine_Appear")

func _on_inspect_button_down() -> void:
	if !inspected :
		inspect_pos = global_position
		scale += Vector2(1.65, 1.65)
		global_position = Vector2(0.0, 0.0)
		z_index = 1
		inspected = true
	else :
		global_position = inspect_pos
		z_index = 0
		card_frame.visible = true
		card_name.visible = true
		card_grade.visible = true
		card_edition.visible = true
		card_desc.visible = true
		$Eye.modulate.a = 1
		scale -= Vector2(1.65, 1.65)
		inspected = false
	


func _on_eye_button_down() -> void:
	if inspected and !eyeing:
		card_frame.visible = false
		card_name.visible = false
		card_grade.visible = false
		card_edition.visible = false
		card_desc.visible = false
		$Eye.modulate.a = 0.2
		eyeing = true
	else :
		card_frame.visible = true
		card_name.visible = true
		card_grade.visible = true
		card_edition.visible = true
		card_desc.visible = true
		$Eye.modulate.a = 1
		eyeing = false
