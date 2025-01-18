extends Node


var autolang: String	# Language
var highscore_solo: int	# High score


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
