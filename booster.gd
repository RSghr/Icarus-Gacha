extends Node2D

var availability = 3

func _ready():
	get_tree().root.get_child(0).link_anim($AnimationPlayer)

func _unhandled_input(event):
	if event.is_action_pressed("Open"):
		if availability > 0:
			$AnimationPlayer.play("Booster_Open")


func _on_booster_button_down():
	if availability > 0:
		$AnimationPlayer.play("Booster_Open")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Booster_Appear":
		$AnimationPlayer.play("Booster_Idle")

func _on_next_pack_button_down() -> void:
	if availability > 0:
		$Booster_Top.position = Vector2(0,0)
		$Booster_Top.rotation = 0.0
		$Booster_Top.modulate.a = 1.0
		$Booster_Sprite.modulate.a = 1.0
		$AnimationPlayer.play("Booster_Appear")
