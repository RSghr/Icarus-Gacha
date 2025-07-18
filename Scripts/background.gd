extends Node2D

@export var bg_count = 5


func _on_next_2_button_down() -> void:
	if bg_count != $AnimatedSprite2D.frame:
		$AnimatedSprite2D.frame += 1 
	else :
		$AnimatedSprite2D.frame = 0 
