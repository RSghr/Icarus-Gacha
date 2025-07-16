extends Node2D

@export var SECRET_KEY = "ICARE_SUPER_SECRET_CODE"

var dailyScene = load("res://Scenes/daily.tscn")
var mainScene

func _ready():
	mainScene = get_tree().root.get_child(0)
	print("Today's code is: ", generate_daily_code())
	#_CODE_REDEEM() #Keep commented prints the code to redeem. for Admin only
	
func generate_daily_code() -> String:
	var date_str = get_today_string()
	var base = date_str + SECRET_KEY
	var hashed = str(hash_string(base))
	return hashed.substr(0, 6).to_upper()

func get_today_string() -> String:
	var now = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d" % [now.year, now.month, now.day]

func hash_string(input: String) -> int:
	var hashed = 0
	for c in input:
		hashed = int(c.unicode_at(0)) + ((hashed << 5) - hashed)
	return abs(hashed)
	
func redeem_code(user_input: String) -> bool:
	var correct_code = generate_daily_code()
	if user_input.strip_edges().to_upper() != correct_code:
		return false  # Wrong code

	# Check if already used
	var config = ConfigFile.new()
	var path = "user://Icarus_Gacha/redeem_log.cfg"
	config.load(path)
	var used = config.get_value("daily", get_today_string(), false)
	if used:
		return false  # Already redeemed

	# Mark as used
	config.set_value("daily", get_today_string(), true)
	config.save(path)
	return true

func _CODE_REDEEM(): #TO BE COMMENBTED
	var config = ConfigFile.new()
	var path = "res://Code_of_the_day.cfg"
	config.load(path)
	config.set_value("CODE", get_today_string(), generate_daily_code())
	config.save(path)

func _on_button_button_down() -> void:
	var code = $TextEdit.text
	if redeem_code(code):
		var instance = dailyScene.instantiate()
		instance.coded = true
		mainScene.add_child(instance)
		instance.position = Vector2(-250.0, 1000.0)
		$TextEdit.text = "Code redeemed!"
	else:
		$TextEdit.text = "Invalid or already used\n code."
