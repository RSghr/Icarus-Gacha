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
			return Name_list.find_key(i)
	return "GLITCHED"

func grade_color_picker():
	if card_grade.text == "F" or card_grade.text == "E":
		grade_color = Color.WEB_GRAY
	if card_grade.text == "D" or card_grade.text == "C":
		grade_color = Color.WEB_GREEN
	if card_grade.text == "B":
		grade_color = Color.BLUE
	if card_grade.text == "A":
		grade_color = Color.DEEP_PINK
	if card_grade.text == "S":
		grade_color = Color.GOLDENROD
	if card_grade.text == "S+":
		grade_color = Color.FIREBRICK
	if card_grade.text == "Z":
		grade_color = Color.BLACK

func Color_Applier():
	card_frame.modulate = grade_color
	card_name.modulate = grade_color
	card_desc.modulate = grade_color
	card_grade.modulate = grade_color
	card_shine.modulate = grade_color
	card_shine.get_child(0).modulate.a = 0

func Frame_Applier():
	if card_name.text in Name_list:
		character.frame = Name_list[card_name.text]
	else:
		var r = randi_range(0, 11)
		character.frame = r

func randomize_Name_Grade():
	card_edition.text = "0"
	card_name.text = name_random()
	card_grade.text = grade_random()
	grade_color_picker()
	Color_Applier()
	Frame_Applier()
	export_vars()
	
func export_vars():
	card_params["name"] = card_name.text
	card_params["grade"] = card_grade.text
	card_params["edition"] = card_edition.text

func import_vars():
	card_edition.text = card_params["edition"]
	card_name.text = card_params["name"]
	card_grade.text = card_params["grade"]
	grade_color_picker()
	Color_Applier()
	Frame_Applier()
	export_vars()

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
