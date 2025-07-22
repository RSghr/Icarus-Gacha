extends Node2D

#Scene objects
var cardScene = load("res://Scenes/Card.tscn")
var boosterScene = load("res://Scenes/booster.tscn")

#Catching the variable of all important objects
@onready var adhd_player = $Camera2D/ADHDPlayer
@onready var collection = $Collection
@onready var daily = $Daily
@onready var marker_nodes = [
	$Marker2D1,
	$Marker2D2,
	$Marker2D3,
	$Marker2D4,
	$Marker2D5
]

#Camera handling
@export var scroll_speed: float = 0.7
@export var pb_speed: float =  5.0
var curr_pb_speed: float = 1.0
var mouse_edge = 3000.0
var mouse_edge_positive = mouse_edge
var mouse_edge_negative = mouse_edge * -1

#Load the save, and generate the cards in the collection
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

#On ready, look for collection
func _ready():
	create_collection()

#link animation of booster for its finish state
func link_anim(anim):
	anim.animation_finished.connect(_on_booster_animation_finished)

#Camera handling, allow scroll only when showing collection
func _process(_delta):
	if collection.shown :
		var viewportX_limit = get_viewport_rect().end.x / 5
		var viewportY_limit = get_viewport_rect().end.y / 10
		if $Camera2D.position.x < mouse_edge_positive:
			if get_viewport().get_mouse_position().x > (get_viewport_rect().end.x - viewportX_limit) and  get_viewport().get_mouse_position().y > viewportY_limit:
				$Camera2D.position.x += scroll_speed * 50
				collection.get_node("Show").position.x += scroll_speed * 50
		if $Camera2D.position.x > mouse_edge_negative:
			if get_viewport().get_mouse_position().x < viewportX_limit and  get_viewport().get_mouse_position().y > viewportY_limit:
				$Camera2D.position.x -= scroll_speed * 50
				collection.get_node("Show").position.x -= scroll_speed * 50
	else :
		$Camera2D.position.x =  0
		collection.get_node("Show").position.x = -800.0

#When booster opened, spawn X card on screen
func _on_booster_animation_finished(anim_name):
	if anim_name == "Booster_Open": 
			spawn_cards_to_markers()

#Spawn randomly generated cards on specific markers
#Manage daily pulls available.
func spawn_cards_to_markers():
	for marker in marker_nodes:
		var instance = cardScene.instantiate()
		instance.position = global_position
		add_child(instance)
		instance.anim_player.speed_scale = curr_pb_speed
		# Animate movement to marker
		var tween = create_tween()
		tween.tween_property(instance, "position", marker.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	$Booster.availability -= 1
	$Daily.pulls = $Booster.availability
	$Daily.update_daily_save()
	if $Booster.availability == 0:
		$Booster.queue_free()

#Sending cards to the collection, depending on which name they belong to
func card_sorter():
	for cards in $Deleted.get_children():
		var category = collection.get_child(0).find_child(cards.card_params["name"])
		cards.get_node("Shine").modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(cards, "position", category.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		cards.reparent(category)

#Sorting the card grades from lowest (first child) to Highest (last child).
func collection_grade_sorter():
	for categ in collection.get_child(0).get_children():
		if categ.get_child_count() > 0:
			var max_grade = categ.get_child(0).card_grade.text
			for cards in categ.get_children():
				if "toDestroy" in cards:
					var a = cards.card_grade.text
					var b = max_grade
					if _sort_grade(a,b):
						categ.move_child(cards,0)
					else:
						max_grade = cards.card_grade.text

#Grade sorter logic
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

#Sending cards to collection, calling the sorting functions and saving the collection
func _on_collect_button_down() -> void:
	collection_grade_sorter()
	#collection.clear_less_grade()
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
	#collection.clear_less_grade()
	collection.save_cards_list()

#Quit the game
func _on_quit_button_down() -> void:
	_on_collect_button_down()
	get_tree().quit()

func _on_button_toggled(toggled_on: bool) -> void:
	var anim_players = get_tree().get_nodes_in_group("AnimationPlayers")
	if toggled_on :
		$Camera2D/Speedup/Sprite2D.frame = 1
		for anim_player in anim_players:
			curr_pb_speed = pb_speed
			_set_playback_speed(anim_player, curr_pb_speed)
	else :
		$Camera2D/Speedup/Sprite2D.scale = Vector2(0.8,0.8)
		$Camera2D/Speedup/Sprite2D.frame = 0
		for anim_player in anim_players:
			curr_pb_speed = 1.0
			_set_playback_speed(anim_player, curr_pb_speed)
			
func _set_playback_speed(animation, pb_speed):
	animation.speed_scale = pb_speed
