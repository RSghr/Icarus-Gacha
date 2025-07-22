extends Node2D

const SAVE_PATH = "user://Icarus_Gacha/daily_button.cfg"
@onready var dailyButton = $Get_Daily
@onready var pulls = 3

var boosterScene = load("res://Scenes/booster.tscn")
var mainScene
var coded = false

#On ready, check if the daily boosters were claimed already
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

#Get today's date
func get_today_string() -> String:
	var now = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d" % [now.year, now.month, now.day]

#When pressing button, update save and create X boosters
func _on_get_daily_button_down() -> void:
	# Save today's date to file
	update_daily_save()
	
	var instance = boosterScene.instantiate()
	instance.availability = pulls
	mainScene.add_child(instance)
	button_update(0.0, true)

#Update the last time the button was pressed, and how many unopened packs are left
func update_daily_save():
	var config = ConfigFile.new()
	config.set_value("daily", "last_pressed", get_today_string())
	config.set_value("packs", "unopened", pulls)
	config.save(SAVE_PATH)

#if it was already claimed, just hide it
func button_update(a, disable):
	modulate.a = a
	dailyButton.disabled = disable
	label_update()

#Update the number of packs left to open
func label_update():
	$RichTextLabel.text = "Get your "
	if pulls == 1:
		$RichTextLabel.text += "pack"
	else :
		$RichTextLabel.text += str(pulls)
		$RichTextLabel.text += " packs"
	
