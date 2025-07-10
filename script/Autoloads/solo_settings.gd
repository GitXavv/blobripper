extends Node

var init_timer: int = 30 # Time per round
var rng_wait = 0.9 # Frequency of the bot actions. The shorter this value, the bigger the frequency.
var init_lives: int = 3  # Player starts with this amount of lives
var init_turn: int = 3 # Turns to complete to win the gmme

var progressive: bool = false # If true, frequency increases progressively in game

# Mods
# Hard mods
var hidden: bool = false
var swap: bool = false
var stuck_swap: bool = false
var all_in_one: bool = false
var delayed: bool = false
var latency: float = 0.2 # The three levels available 0.2, 0.3 or 0.4. A bigger latency implies a greater boost.

# Easy mods
var nohalt: bool = false
var only_one: bool = false

var last_chance: bool = false # For survival mode only

# Survival mode: yes or no
var sv_mode: bool = false




func _ready():
	pass # Replace with function body.
