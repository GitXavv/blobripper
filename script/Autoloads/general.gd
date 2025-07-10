extends Node

var ingame_background = 0
var bg0 = "res://backgrounds/0.png"
var bg1 = "res://backgrounds/1.png"
var bgs = [bg0, bg1]

var autolang: String = "fr"	# Language
var highscore_solo: int	# High score
var highscore_solo_sv: int	# High score in survival mode

# To mute the perfect dodge sound to reduce distraction from it
var nododge_sound: bool = false

# Appreciations of the score in the pause menu:
var appreciations: bool = true


func langkeys(up1: String, left1: String):
	if autolang =="fr":
		up1 = "up1_az"
		left1 = "left1_az"
	elif autolang =="en":
		up1 = "up1_qw"
		left1 = "left1_qw"
	return[up1,left1]

func high_init():
	highscore_solo =0

func _ready():
	pass # Replace with function body.
