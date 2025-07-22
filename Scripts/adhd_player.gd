extends Node2D

@onready var videoStream = $VideoStreamPlayer

var local_videos = [
	"res://Video_Assets/horse_is_here.ogv",
	"res://Video_Assets/Avg_Tugboat.ogv",
	"res://Video_Assets/Warspite_Bugatti.ogv"
]
func play_ADHD_Videos():
	visible = true
	var rand = randi_range(0, local_videos.size() - 1)
	var video_stream = load(local_videos[rand])
	if video_stream:
		videoStream.stream = video_stream
		videoStream.play()
	else:
		push_warning("Failed to load video at index %d" % rand)

func stop_curr_vid():
	if videoStream.is_playing() :
		videoStream.stop()

func _on_video_stream_player_finished() -> void:
	visible = false
