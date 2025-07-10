extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	SilentWolf.configure({
	"api_key": "3tlJG9hfTU59BSgJDHuYUaojAEfn3rjY4IYFK5yX",
	"game_id": "blobbysweeper",
	"log_level": 1
	})

	SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/solo.tscn"
	})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
