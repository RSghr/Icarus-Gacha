extends Node2D

var cardScene = load("res://Scenes/Card.tscn")
var boosterScene = load("res://Scenes/booster.tscn")
@onready var marker_nodes = [
	$Marker2D1,
	$Marker2D2,
	$Marker2D3,
	$Marker2D4,
	$Marker2D5
]

@onready var collection = $Collection

#func _unhandled_input(event):
	#if event.is_action_pressed("Generate"): 
			#var instance = boosterScene.instantiate()
			#add_child(instance)
	#if event.is_action_pressed("Clear"):
		#collection_grade_sorter()
		#collection.clear_less_grade()
		#for i in range(1,6):
			#var mark = get_node("Marker2D" + str(i))
			#for child in mark.get_children():
				#var tween = create_tween()
				#tween.tween_property(child, "position", $Deleted.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				#child.reparent($Deleted)
		#for nodes in get_children():
			#if "toDestroy" in nodes:
				#var tween = create_tween()
				#tween.tween_property(nodes, "position", $Deleted.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				#nodes.reparent($Deleted)
		#card_sorter()
		#collection_grade_sorter()
		#collection.clear_less_grade()
		#collection.save_cards_list()

@export var scroll_speed: float = 0.7

var mouse_edge = 3000.0
var mouse_edge_positive = mouse_edge
var mouse_edge_negative = mouse_edge * -1

func create_collection():
	var card_list_params = collection.load_cards()
	for card_params in card_list_params:
		var instance = cardScene.instantiate()
		$Deleted.add_child(instance)
		instance._ready()
		instance.card_params = card_params
		instance.import_vars()
		instance.flipped = true
		instance.get_node("Back").visible = false
		card_sorter()

func _ready():
	create_collection()

func link_anim(anim):
	anim.animation_finished.connect(_on_booster_animation_finished)

func _process(delta):
	if collection.shown :
		if $Camera2D.position.x < mouse_edge_positive:
			if get_viewport().get_mouse_position().x > 1500 :
				$Camera2D.position.x += scroll_speed * 50
		if $Camera2D.position.x > mouse_edge_negative:
			if get_viewport().get_mouse_position().x < 200 :
				$Camera2D.position.x -= scroll_speed * 50
	else :
		$Camera2D.position.x =  0

func _on_booster_animation_finished(anim_name):
	if anim_name == "Booster_Open": 
			spawn_cards_to_markers()

func spawn_cards_to_markers():
	for marker in marker_nodes:
		var instance = cardScene.instantiate()
		instance.position = global_position
		add_child(instance)
		# Animate movement to marker
		var tween = create_tween()
		tween.tween_property(instance, "position", marker.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	$Booster.availability -= 1
	if $Booster.availability == 0:
		$Booster.queue_free()

func card_sorter():
	for cards in $Deleted.get_children():
		var category = collection.get_child(0).find_child(cards.card_params["name"])
		cards.get_node("Shine").modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(cards, "position", category.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		cards.reparent(category)

func collection_grade_sorter():
	for categ in collection.get_child(0).get_children():
		if categ.get_child_count() > 0:
			var max_grade = categ.get_child(0).card_grade.text
			for cards in categ.get_children():
				var a = cards.card_grade.text
				var b = max_grade
				if _sort_grade(a,b):
					categ.move_child(cards,0)
					max_grade = cards.card_grade.text

func _sort_grade(a, b) -> bool:  
	match a:
		"F":
			if b =="Z" or b == "S+" or b == "S" or b == "A" or b == "B" or b == "C" or b == "D" or b == "E" :
				return true
			else:
				return false
		"E":
			if b =="Z" or b == "S+" or b == "S" or b == "A" or b == "B" or b == "C" or b == "D":
				return true
			else:
				return false
		"D":
			if b =="Z" or b == "S+" or b == "S" or b == "A" or b == "B" or b == "C":
				return true
			else:
				return false
		"C":
			if b =="Z" or b == "S+" or b == "S" or b == "A" or b == "B":
				return true
			else:
				return false
		"B":
			if b =="Z" or b == "S+" or b == "S" or b == "A":
				return true
			else:
				return false
		"A":
			if b =="Z" or b == "S+" or b == "S":
				return true
			else:
				return false
		"S":
			if b =="Z" or b == "S+":
				return true
			else:
				return false
		"S+":
			if b == "Z":
				return true
			else:
				return false
		"Z":
			return false
	return false

func _on_collect_button_down() -> void:
	collection_grade_sorter()
	collection.clear_less_grade()
	for i in range(1,6):
		var mark = get_node("Marker2D" + str(i))
		for child in mark.get_children():
			var tween = create_tween()
			tween.tween_property(child, "position", $Deleted.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			child.reparent($Deleted)
	for nodes in get_children():
		if "toDestroy" in nodes:
			var tween = create_tween()
			tween.tween_property(nodes, "position", $Deleted.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			nodes.reparent($Deleted)
	card_sorter()
	collection_grade_sorter()
	collection.clear_less_grade()
	collection.save_cards_list()

func _on_quit_button_down() -> void:
	get_tree().quit()
