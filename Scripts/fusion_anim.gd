extends Node2D

@onready var card_List = [
	$Card_Holder/Card,
	$Card_Holder/Card2,
	$Card_Holder/Card3
]

@onready var resultCard = $ResultCard

var card_grade = "F"
var card_name = "Pyro"

func _ready() -> void:
	_set_cards()
	
func _set_cards():
	for cards in card_List:
		cards.card_params["grade"] = card_grade
		cards.card_params["name"] = card_name
		cards.import_vars()
	resultCard.card_params["grade"] = fusion.next_rarity(card_grade)
	resultCard.card_params["name"] = card_name
	resultCard.import_vars()

func _on_take_in_button_down() -> void:
	queue_free()
