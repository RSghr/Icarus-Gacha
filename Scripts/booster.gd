extends Node2D

var availability = 3
var mainScene

#On ready attach objects
func _ready():
	mainScene = get_tree().root.get_child(0)
	get_tree().root.get_child(0).link_anim($AnimationPlayer)

#Keyboard Input to open packs
func _unhandled_input(event):
	if event.is_action_pressed("Open"):
		if availability > 0:
			$AnimationPlayer.play("Booster_Open")

#If the booster is still available, open pack
func _on_booster_button_down():
	if availability > 0:
		$AnimationPlayer.play("Booster_Open")

#Animation idle handling
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Booster_Appear":
		$AnimationPlayer.play("Booster_Idle")

#Next pack resetting the pack opening
func _on_next_pack_button_down() -> void:
	if availability > 0:
		$Booster_Top.position = Vector2(0,0)
		$Booster_Top.rotation = 0.0
		$Booster_Top.modulate.a = 1.0
		$Booster_Sprite.modulate.a = 1.0
		$AnimationPlayer.play("Booster_Appear")
		mainScene._on_collect_button_down()
