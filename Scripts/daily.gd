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

	var last_press_date = ""
	if err == OK:
		last_press_date = config.get_value("daily", "last_pressed", "")
	
	var today = get_today_string()

	if last_press_date == today and !coded:
		queue_free()

func get_today_string() -> String:
	var now = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d" % [now.year, now.month, now.day]

func _on_get_daily_button_down() -> void:
	# Save today's date to file
	var config = ConfigFile.new()
	config.set_value("daily", "last_pressed", get_today_string())
	config.save(SAVE_PATH)
	
	var instance = boosterScene.instantiate()
	instance.availability = pulls
	mainScene.add_child(instance)	
	queue_free()
