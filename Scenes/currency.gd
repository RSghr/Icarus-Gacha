extends Node2D

const SAVE_PATH = "user://Icarus_Gacha/Currency.cfg"
var currency = 0
var daily_currency = 300
var loading = true

@onready var scoretext = $RichTextLabel
@onready var getpack = $GetPack
var boosterScene = load("res://Scenes/booster.tscn")

var mainScene

func _ready():
	mainScene = get_tree().root.get_child(0)
	update_daily_save()

func update_text():
	scoretext.text = str(currency)
	
func check_balance(value):
	if currency >= value:
		return true
	else :
		return false

func modify_balance(amount,type): #1 : Addition / -1 : Substraction
	currency += amount * type
	update_daily_save()

#Get today's date
func get_today_string() -> String:
	var now = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d" % [now.year, now.month, now.day]

func update_daily_save():
	var config = ConfigFile.new()
	var currConfig = config.load(SAVE_PATH)
	var today = get_today_string()
	var last_conn_date = ""
	if currConfig == OK:
		last_conn_date = config.get_value("LastConnected", "Time", "")
	
	if loading:
		currency = int(config.get_value("currency", "bottle", 0))
		loading = false
	
	if last_conn_date != today:
		config.set_value("LastConnected", "Time", get_today_string())
		currency += daily_currency
	
	config.set_value("currency", "bottle", currency)
	
	update_text()
	config.save(SAVE_PATH)

func spawn_pack():
	var instance = boosterScene.instantiate()
	instance.availability = 1
	mainScene.add_child(instance)
