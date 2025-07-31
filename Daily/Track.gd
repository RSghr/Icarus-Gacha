extends Node2D

var participantScene = load("res://Daily/participant.tscn")

@onready var start = $Start
@onready var finish = $Finish
@onready var pos = $Medal/Position
@onready var medal = $Medal
var participant 

static var pos_arrival = 1
var started = false #put a signal
var finished = false

var medal_color_list = [
	Color.GOLDENROD,
	Color.SILVER,
	Color.SADDLE_BROWN,
	Color.DIM_GRAY,
	Color.DIM_GRAY,
	Color.DIM_GRAY
]

func _ready() -> void:
	if participant == null:
		participant = participantScene.instantiate()
		start.add_child(participant)
	reset_track()
	
func _process(_delta: float) -> void:
	if started && participant.position.x < finish.position.x * 2 && !finished:
		participant.position.x += participant.total_speed
		check_arrival()
	if started && participant.position.x < finish.position.x && !finished:
		participant.position.x += participant.total_speed + participant.mood_picker() * 0.1
		
func check_arrival():
	if participant.position.x > finish.position.x * 2:
		finished = true
		medal_color_picker()
		pos.text = str(pos_arrival)
		get_parent()._on_track_done()
		next_pos_arrival()

func next_pos_arrival():
	pos_arrival += 1

func medal_color_picker():
	medal.self_modulate = medal_color_list[pos_arrival - 1]
	if pos_arrival > 3:
		var fr = float(9 - pos_arrival) / 10
		medal.self_modulate.v = fr

func reset_track():
	finished = false
	started = false
	participant.position = Vector2(0,0)
	pos_arrival = 1
	medal.self_modulate.a = 0
	$Betting.modulate.a = 1
	pos.text = ""
	
func set_betting_selection(value):
	$Betting.modulate.a = value

func _on_betting_button_down() -> void:
	if !started :
		get_parent().chosen_track = $"."
		get_parent()._on_choose_bet(0.3)

func get_rank_on_arrival():
	return int($Medal/Position.text)
