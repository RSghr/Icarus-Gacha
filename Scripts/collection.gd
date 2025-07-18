extends Node2D

var shown = false
var card_list = []

func save_cards():
	create_dir()
	var data = {"cards": card_list}
	if FileAccess.file_exists("user://Icarus_Gacha/save_cards.json"):
		delete_save()
	var file = FileAccess.open("user://Icarus_Gacha/save_cards.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	
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

func clear_less_grade():
	for categ in get_child(0).get_children():
		var childnum = categ.get_child_count()
		while childnum > 1:
			categ.get_child(0).queue_free()
			childnum -= 1

func save_cards_list():
	card_list.clear()
	for categ in get_child(0).get_children():
		if categ.get_child_count() > 0:
			card_list.append(categ.get_child(0).card_params)
	save_cards()
	
func Reset(event):
	if event.is_action_pressed("Reset"):
		for categ in get_child(0).get_children():
			if "toDestroy" in categ.get_child(0):
				categ.get_child(0).queue_free()
		card_list.clear()
		delete_save()

func _on_show_button_down() -> void:
	get_tree().root.get_child(0)._on_collect_button_down()
	if !shown :
		$AnimationPlayer.play("Collection_Show")
		shown = true
	else :
		$AnimationPlayer.play_backwards("Collection_Show")
		shown = false
