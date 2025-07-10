extends Node

var username: String
var password: String
# For Signing-in situations, to add some sort of Two-Factor Authentication after creating the account,
# The user will have to create a custom question when logging in next time.
var q_confirm: String
var a_confirm: String

# A series of questions to answer if passowrd forgotten
var q1: String
var a1: String

var q2: String
var a2: String

var q3: String
var a3: String


# Called when the node enters the scene tree for the first time.
func _ready():
	username = ""
	password = "pass"
	q_confirm = "C'est quoi ton vrai nom ?"
	a_confirm = "Xavv"
	
	q1 = "Quel âge ?"
	a1 = "19"
	
	q2 = "Quel âge -1 ?"
	a2 = "18"
	
	q3 = "Quel mois ?"
	a3 = "Février"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
