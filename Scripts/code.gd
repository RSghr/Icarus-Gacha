extends Node2D

@export var SECRET_KEY = "ICARE_SUPER_SECRET_CODE"

var dailyScene = load("res://Scenes/daily.tscn")
var mainScene

#On ready print today's code Redeem
func _ready():
	mainScene = get_tree().root.get_child(0)
	#for cpt in range(0,7): #Generate codes for the whole week
		#_CODE_REDEEM(cpt) #Keep commented prints the code to redeem. for Admin only

#Generate the code based on the date and secret key
func generate_daily_code(days) -> String:
	var date_str = get_today_string(days)
	var base = date_str + SECRET_KEY
	var hashed = str(hash_string(base))
	return hashed.substr(0, 6).to_upper()

#Get today's date
func get_today_string(days) -> String:
	var now = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d" % [now.year, now.month, now.day + days]

#Hash the string
func hash_string(input: String) -> int:
	var hashed = 0
	for c in input:
		hashed = int(c.unicode_at(0)) + ((hashed << 5) - hashed)
	return abs(hashed)

#Check if code is good or not
func redeem_code(user_input: String, days) -> bool:
	var correct_code = generate_daily_code(days)
	if user_input.strip_edges().to_upper() != correct_code:
		_Custom_Redeem(user_input)
		return false  # Wrong code

	# Check if already used
	var config = ConfigFile.new()
	var path = "user://Icarus_Gacha/redeem_log.cfg"
	config.load(path)
	var used = config.get_value("daily", get_today_string(days), false)
	if used:
		return false  # Already redeemed

	# Mark as used
	config.set_value("daily", get_today_string(days), true)
	config.save(path)
	return true

func _CODE_REDEEM(days): #TO BE COMMENTED
	var config = ConfigFile.new()
	var path = "res://Code_of_the_day.cfg"
	config.load(path)
	config.set_value("CODE", get_today_string(days), generate_daily_code(days))
	config.save(path)

func _Custom_Redeem(code):
	var config = ConfigFile.new()
	var path = "user://Icarus_Gacha/redeem_log.cfg"
	config.load(path)
	var used = config.get_value("OTC", "redeemed", false)
	if code == "0.5.0 is here" and !used:
		_Create_pulls(10)
		config.load(path)
		config.set_value("OTC", "redeemed", true)
		config.save(path)
	if code == "ADHD" :
		mainScene.adhd_player.play_ADHD_Videos()
	if code == "stop" :
		mainScene.adhd_player.stop_curr_vid()

#Code redeem logic, show daily object if true
func _on_button_button_down() -> void:
	var code = $TextEdit.text
	if redeem_code(code, 0):
		_Create_pulls(3)
	else:
		$TextEdit.text = ""
		$TextEdit.placeholder_text = "Invalid or already used."

func _Create_pulls(pulls):
	var instance = mainScene.get_node("Daily")
	instance._ready()
	instance.coded = true
	instance.pulls += pulls
	instance.button_update(1.0, false)
	instance.update_daily_save()
	instance.label_update()
	instance.position = Vector2(-250.0, 1000.0)
	$TextEdit.text = "Code redeemed!"


func _on_text_edit_text_submitted(new_text: String) -> void:
	_on_button_button_down()
