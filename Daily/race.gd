extends Node2D

@onready var track_list = [
	$Track1,
	$Track2,
	$Track3,
	$Track4,
	$Track5,
	$Track6
]

var participant_list = []
var race_ended = false

var chosen_track = null

func _ready() -> void:
	generate_participants()

func generate_participants():
	var char_icon
	for track in track_list:
		if "pos_arrival" in track:
			char_icon = track.get_node("Start").get_child(0)
			char_icon.init_character()
			while char_icon.char_frame in participant_list:
				char_icon.init_character()
			participant_list.append(char_icon.char_frame)

func _on_start_race_button_down() -> void:
	var currency = get_parent().currency
	
	if currency.check_balance(50):
		if !race_ended:
			currency.modify_balance(50,-1)
			race_ended = false
		for track in track_list:
			if track.started:
				reset_race(track)
			else: 
				track.started = true
				$Start_Race.visible = false
				_on_choose_bet(0)
	
func reset_race(track):
	participant_list.clear()
	generate_participants()
	track._ready()
	track.reset_track()
	race_ended = false

func _on_track_done() -> void:
	if participant_list.size() == $Track1.pos_arrival :
			$Start_Race.visible = true
			race_ended = true
			if chosen_track:
				reward_betting(chosen_track.get_rank_on_arrival())
			
func _on_choose_bet(value):
	for track in track_list:
		if track != chosen_track:
			track.set_betting_selection(value)
		else:
			track.set_betting_selection(1)

func reward_betting(rank):	
	var currency = get_parent().currency
	
	match rank :
		1:
			currency.modify_balance(200,1)
			currency.update_daily_save()
		2:
			currency.modify_balance(100,1)
			currency.update_daily_save()
		3:
			currency.modify_balance(25,1)
			currency.update_daily_save()
