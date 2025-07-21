extends Node2D

@export var fusion_list = []
@export var current_rarity = "F"
@onready var grade_text = $Grade

#Return the next rarity
func next_rarity(rarity):
	match rarity:
		"F":
			return "E"
		"E":
			return "D"
		"D":
			return "C"
		"C":
			return "B"
		"B":
			return "A"
		"A":
			return "S"
		"S":
			return "S+"
		"S+":
			return "Z"
		"Z":
			return "Z"
	return "Z"

#Find the highest edition of cards to fuse into
func highest_edition(card_list):
	var card_max_edition = card_list[0]
	for card in card_list:
		if int(card.card_params["edition"]) > int(card_max_edition.card_params["edition"]):
			card_max_edition = card
	return card_max_edition

#Fusing cards logic
func fuse_cards():
	if fusion_list.size() > 2 :
		var car_fused = highest_edition(fusion_list)
		car_fused.card_grade.text = next_rarity(car_fused.card_grade.text)
		var to_delete = 2
		for card in fusion_list:
			if card.card_grade.text != car_fused.card_grade.text and to_delete > 0:
				card.queue_free()
				to_delete -= 1
		car_fused.init_card()
		fusion_list.clear()

#Call the fusion cards functions
func _on_fusion_button_down() -> void:
	fuse_cards()
	get_parent().get_parent().get_parent().save_cards()
	queue_free()
