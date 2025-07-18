extends Node2D

const SAVE_PATH = "user://Icarus_Gacha/daily_button.cfg"
@onready var dailyButton = $Get_Daily
@onready var pulls = 3

var boosterScene = load("res://Scenes/booster.tscn")
var mainScene
var coded = false

func _ready():
	mainScene = get_tree().root.get_child(0)
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	var today = get_today_string()
	var last_press_date = ""
	if err == OK:
		last_press_date = config.get_value("daily", "last_pressed", "")
	
	if last_press_date == today :
		pulls = config.get_value("packs", "unopened", pulls)
	label_update()
	if last_press_date == today and !coded and pulls == 0:
		button_update(0.0, true)

func get_today_string() -> String:
	var now = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d" % [now.year, now.month, now.day]

func _on_get_daily_button_down() -> void:
	# Save today's date to file
	update_daily_save()
	
	var instance = boosterScene.instantiate()
	instance.availability = pulls
	mainScene.add_child(instance)
	button_update(0.0, true)

func update_daily_save():
	var config = ConfigFile.new()
	config.set_value("daily", "last_pressed", get_today_string())
	config.set_value("packs", "unopened", pulls)
	config.save(SAVE_PATH)

func button_update(a, disable):
	modulate.a = a
	$Get_Daily.disabled = disable
	label_update()
	
func label_update():
	$RichTextLabel.text = "Get your "
	if pulls == 1:
		$RichTextLabel.text += "pack"
	else :
		$RichTextLabel.text += str(pulls)
		$RichTextLabel.text += " packs"
	
