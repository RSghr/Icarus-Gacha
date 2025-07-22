extends Node2D

var shown = false
var card_list = []

var fusionScene = load("res://Scenes/fusion.tscn")
var mainScene

#On ready find the main scene
func _ready():
	mainScene = get_tree().root.get_child(0)
	
#Save collection in file
func save_cards():
	create_dir()
	var data = {"cards": card_list}
	if FileAccess.file_exists("user://Icarus_Gacha/save_cards.json"):
		delete_save()
	var file = FileAccess.open("user://Icarus_Gacha/save_cards.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	
#Erase file
func delete_save():
	if FileAccess.file_exists("user://Icarus_Gacha/save_cards.json"):
		var dir = DirAccess.open("user://Icarus_Gacha/")
		if dir:
			dir.remove("save_cards.json")
			print("Save file deleted.")
		else:
			push_error("Failed to open user:// directory.")
	else:
		print("No save file to delete.")

#Create directory if it doesn't exist
func create_dir():
	var dir = DirAccess.open("user://")

	if not dir.dir_exists("Icarus_Gacha"):
		var err = dir.make_dir("Icarus_Gacha")
		if err == OK:
			print("Created save folder: Icarus_Gacha")
		else:
			print("Failed to create folder: ", err)
	else:
		print("Folder already exists.")

#Load cards in collection
func load_cards() -> Array:
	create_dir()
	if not FileAccess.file_exists("user://Icarus_Gacha/save_cards.json"):
		return []
	var file = FileAccess.open("user://Icarus_Gacha/save_cards.json", FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	var result = JSON.parse_string(text)
	if result == null:
		push_warning("Failed to parse card save file")
		return []
	return result["cards"]

#Delete cards that have a lesser grade
func clear_less_grade():
	for categ in get_child(0).get_children():
		var childnum = categ.get_child_count()
		while childnum > 1:
			categ.get_child(0).queue_free()
			childnum -= 1

#save list of cards
func save_cards_list():
	card_list.clear()
	for categ in get_child(0).get_children():
		if categ.get_child_count() > 0:
			for card in categ.get_children():
				if "toDestroy" in card:
					mainScene.collection_grade_sorter()
					card_list.append(card.card_params)
	save_cards()
	look_for_duplicates()
	mainScene.collection_grade_sorter()

#Check for duplicate cards, 3 of them allow a fusion
func look_for_duplicates():
	var duplicate_list = []
	var grade_in_categ = []
	for categ in get_child(0).get_children():
		if categ.get_child_count() > 0:
			grade_in_categ = dupes_in_categ(categ.get_children())
			if grade_in_categ.size() > 0:
				for grade in grade_in_categ:
					for card in categ.get_children():
						if "toDestroy" in card :
							if card.card_params["grade"] == grade and !(fusion_exists_categ(categ)):
								duplicate_list.append(card)
					if duplicate_list.size() > 2:
						var instance = fusionScene.instantiate()
						for i in range(0,duplicate_list.size()):
							instance.fusion_list.append(duplicate_list[i])
						categ.add_child(instance)
						instance.grade_text.text = instance.fusion_list[0].card_params["grade"]
						instance.current_rarity = instance.fusion_list[0].card_params["grade"]
						instance.position = categ.get_child(0).position
						instance.position.y += 500 
					duplicate_list.clear()
		#order_fuse_buttons(categ)
	mainScene.collection_grade_sorter()
	

#offset the buttons to show in a cascade vertically
#Not used as only one fusion button is summoned at a time
func order_fuse_buttons(categ):
	var offset = 0
	for nodes in categ.get_children():
		if "fusion_list" in nodes:
			nodes.position.y += offset
			offset += 110

#Check if the fusion button exist in the category
func fusion_exists_categ(categ):
	for nodes in categ.get_children():
		if "fusion_list" in nodes:
			return true
	return false

#Find the duplicates in the category
func dupes_in_categ(categ_list):
		var grade_list = []
		for card in categ_list:
			if "toDestroy" in card:
				if !(card.card_params["grade"] in grade_list):
					grade_list.append(card.card_params["grade"])
		return grade_list
		
#Reset Collection - Not used
func Reset(event):
	if event.is_action_pressed("Reset"):
		for categ in get_child(0).get_children():
			if "toDestroy" in categ.get_child(0):
				categ.get_child(0).queue_free()
		card_list.clear()
		delete_save()

#Show collection
func _on_show_button_down() -> void:
	get_tree().root.get_child(0)._on_collect_button_down()
	if !shown :
		$AnimationPlayer.play("Collection_Show")
		shown = true
	else :
		$AnimationPlayer.play_backwards("Collection_Show")
		shown = false
