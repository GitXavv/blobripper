extends Node

var bgs = General.bgs
var set_bg = General.ingame_background
var background = bgs[set_bg]

const unit = 60

var settings_loaded: bool = false
var beginning: bool = false

var countdown: int

var up1: String
var left1: String

#To tell the game where the player is on the grid precisely
#The ex_variables are to avoid diagonal moves DURING a straight move animation
#it basically cancels every diagonal moves now
var topl: bool = true
var ex_topl: bool =false
var topr: bool = false
var ex_topr: bool =false
var botl: bool =false
var ex_botl: bool =false
var botr: bool =false
var ex_botr: bool =false

var moving: bool = false

var left: bool = false
var right: bool = false
var up: bool = false
var down: bool = false

var trajectory = 1


var trap_topl: bool = false
var trap_topr: bool = false
var trap_botl: bool = false
var trap_botr: bool = false

var bomb_topl: bool = false
var bomb_topr: bool = false
var bomb_botl: bool = false
var bomb_botr: bool = false

#tiles and textures
var tile1 #topl
var tile2 #topr
var tile3 #botl
var tile4 #botr

var tile_normal = "res://assets/tile.png"
var tile_target = "res://assets/tile-mined.png"
var tile_hit = "res://assets/tile-bombed.png" # The
var tile_hit2 = "res://assets/tile-bombed-2.png" # Tile
var tile_hit3 = "res://assets/tile-bombed-3.png" # Hit
var tile_hit4 = "res://assets/tile-bombed-4.png" # Textures
var tile_hits = [tile_hit, tile_hit2, tile_hit3, tile_hit4] # Will be
var th_texture # Randomized
var tile_broken = "res://assets/tile-broken.png"

#Blob states
var blob
var blob_normal = "res://assets/blob1.png"
var blob_danger = "res://assets/blob1_danger.png"
var blob_hit = "res://assets/blob1_dead.png" #When the blob is hit
var blob_dizzy = "res://assets/blob1_dizzy.png" # For the swap modS. Yes, modS!
var interblob: String # To sap between normal and dizzy for the swap mod.
var dead: bool =false


#Cooldowns. Determines if a specific cooldown timer is active or not. This is to avoid using a shared countdown
#for many tiles, as the cooldown's timeout may reset them all at the same time, which is not intended
var cd1: bool = false
var cd2: bool = false
var cd3: bool = false
var cd4: bool = false

#Multiplayer-only feature
#Total ammo. The amount of times tiles can be mined.
#var tot_ammo: int
const nbtiles = 4 #Only helps with determining the ammo: ammo = nbtiles-2 (So that two tiles maximum remain untouched during a rafal for example)
var ammo: int

# Random chosen tile. Both variables go together.
var rng= RandomNumberGenerator.new() #Represent each of the 4 tiles
var rndtile: int #Represent the tile chosen by rng

# The time the computer takes to perform one action
var rng_wait = SoloSettings.rng_wait
var rng_wait_backup

var startup= RandomNumberGenerator.new() # Like the rng wait but for the start. Is in [0.4 ; 1]

#Timer
var init_timer= SoloSettings.init_timer # Auto_setting
var timer: int
#When the time is over
var over: bool =false

# To prevent mashers.
var prehalt: bool = false
var move1: bool = false
var move2: bool = false
var move3: bool = false
var move4: bool = false
var move5: bool = false
var move6: bool = false
var move7: bool = false
var move8: bool = false # A 10th movement (10 because 11-1) in only one 1 second (if rng_wait == rng_wait_base) will be considered mashing
var moves = [move1, move2, move3, move4, move5, move6, move7, move8, prehalt]
var move_nb: int
# var ct The counter that will help in the 'for' loop when reviewing the array
var halt_timer: bool = false # To avoid conflicts such as the Halter timer resetting after each move. 1 whole second (if rng_wait == rng_wait_base) - and not less - has to end before the timer restarts
var halt: bool = false
# Converter. Used to translate the rng_wait timer to the Halter timer.
# halt_wt = rng_wait/rng_wait_base. rng_wait_base is a constant = 0.4
const rng_wait_base = 0.4 # Don't touch this unless REALLY necessary
var halt_wt: float

# Messages generated when you die when halted
var en_die1 = "Unfortunate..."
var en_die2 = "You must dodge quickly but also efficiently."
var en_die3 = "Free death..."
var en_die = [en_die1, en_die2, en_die3]
var en_die_pick= RandomNumberGenerator.new()

var fr_die1 = "Dommage..."
var fr_die2 = "Tu dois être rapide mais aussi efficace."
var fr_die3 = "Mort gratuite..."
var fr_die = [fr_die1, fr_die2, fr_die3]
var fr_die_pick= RandomNumberGenerator.new()

# The scoring system
var score: int
var final_score_turn: int # Score obtained at the end of each turn. It is so that the score does not get too reduced (if not going back to 0) when losing at a turn other than the first. This variable is handled in on_timer_timeout()
var timer_reducer
var move_multiplicator
const nbtiles_multiplicator = 4 # 4 because this game mode is a 2x2
var prescore: int # For nerf mods

var high_score: int # = old_high_score until record broken
var old_high_score: int # Loadable data
var beaten: bool # If high_score is beaten


var init_lives = SoloSettings.init_lives  # Auto setting
var lives: int
var init_turn = SoloSettings.init_lives # Auto setting
var turn: int
var trueover: bool =false # When all the lives are lost or all the turns done
var victory: bool # If all the turns done
var defeated: bool # If all lives lost
var calculating: bool # Check if still calculating the stats in the result screen


#Statistics
var tot_moves: int
var tot_moves_ct: int
var tot_time: int
# To respect the format 00min 00sec
var tot_time_ct: int
var tot_time_ctsec: int
var tot_time_ctmin: int
#
var die_halt: int
var die_halt_ct: int
var survival_halt: int
var survival_halt_ct: int
var dodge_count: int
var dodge_count_ct: int
var lost_score: int
var lost_score_ct: int
var consecutives: int = 1 # Number of games played (first play included)
var cons_ct: int		# "ct"s are counters for some cool effects when loading the statistics

# Controls
var left2
var right2
var up2
var down2

# Increasing frequency
var progressive = SoloSettings.progressive # If true, rng_wait progressively decreases
var rng_wait_reducer: float # rng_wait is progressively reduced by this value calculated in is_progressive(). It is so that the progress speed is basically the same no matter the init_timer. Don't apply in survival mode

# Mods
# (This is useless now )var mod_multiplier: float # The score multiplier resulting from mod combinations
# The more the constants are small, the greater the better the score is buffed.
# Hard mods

var hidden: bool = SoloSettings.hidden
const hidden_mtp = 15 # "mtp" means multiplicator
var hidden_catcher: int # if hidden true, catcher =1, if not, catcher =0. This will help for scoring buff

var swap: bool = SoloSettings.swap
var swap_timer: int # For the swap mod timer to switch between normal and swap
const swap_mtp = 20 # Big scores kept being unavoidable, so the multiplications are being turned into an addition of the current score/constant
var normal: bool # Normal controls
var swapped: bool # Swapped controls. Don't confuse with "swap"!!!
var swap_catcher: int # if hidden true, catcher =1, if not, catcher =0. This will help for scoring buff

var stuck_swap: bool = SoloSettings.stuck_swap # If not want constant swaps

var all_in_one: bool = SoloSettings.all_in_one
var rng_multiple = []
const aio_mtp = 35
var aio_catcher: int

var delayed: bool = SoloSettings.delayed
var latency: float = SoloSettings.latency

var action_up: bool
var action_down: bool
var action_left: bool
var action_right: bool

var delay_mtp: float # This would usually play the role of a constant, but since the one for this mod depends on the latency variable, it becomes a variable that is calculated in global_mod_multiplier()
var delay_catcher: int

# Easy mods
var nohalt: bool = SoloSettings.nohalt
const nohalt_dvd = 1.55 # "dvd" means divider
var nohalt_catcher: float
var nohalt_canceller: int

var only_one: bool = SoloSettings.only_one # Can't be enabled with all_in_one on
const only_dvd = 1.04
var only_catcher: float
var only_canceller: int

var last_chance: bool = SoloSettings.last_chance # For survival

# Survival mode (SV)
var sv_mode: bool = SoloSettings.sv_mode
var high_score_sv: int # = old_high_score until record broken
var old_high_score_sv: int # Loadable data
var beaten_sv: bool # If high_score is beaten
var pretimer: bool
var timer_limit: int # To avoid conflicts with the normal game mode for the Timer function

# Dodge
var dodged: bool
var dodge_frame_counter: int # = 1
var boosting: bool
var preboost: int # Score preboosted before mod multiplications
var dodge_score_booster: float # score is increased by this when perfect dodge
var nododge_sound: bool = General.nododge_sound # If the players does not want the perfect dodge sound to play and distract them.

var full_reset: bool = false # To fix animation collision while restarting a match
var retry_shortcut: bool # Press Enter to retry a game
var auto_hover: bool

# Online leaderboard stuffs----
var player_name: String
# To test
@onready var lb_scores = preload("res://addons/silent_wolf/Scores/Leaderboard.tscn")


# Pausing the game
var pause: bool
# These are to catch the Rng Timer objects' remaining time when pausing since there is not any way to actually pause a timer in this Godot Engine
# 'paused' will catch the remaining time when paused.
var rng_wait1_paused: float
var rng_wait2_paused: float

var halt_timer_paused: float

var progr_timer_paused: float

var upped_paused: float
var downed_paused: float
var lefted_paused: float
var righted_paused: float

var rng2_started: bool # This is to prevent Rng2 Timer object to start when resuming the game after pausing the game at the very beginning when Rng2 is not even supposed to start yet.

var timer_paused: float # To pause the timer on time mode

var appreciations: bool = General.appreciations # If true, compares your current score with the current high score at the bottom of the screen. Loadable option


# Exiting the game
var sure: bool
var exiting: bool = false
var forfeiting: bool = false # When at the forfeit menu screen
var forfeited: bool = false # If game forfeited


# ----------------------------------------------
func is_progressive():
	# If progressive mode on:
	if progressive ==true:
		$Progress.wait_time = 1
		rng_wait = 1.5 # Initial rng_wait is stored
		rng_wait_reducer = (-0.1+rng_wait)/(init_timer-1) # This is the solution of an equation so that the rng_wait always hits 0.1 at the last second.
	elif progressive ==false && sv_mode ==true: # On survival mode, to make the game less boring if you manage to control the rhythm and live long enough. Things will get spicier every 5 minutes
		$Progress.wait_time = 30
		rng_wait = SoloSettings.rng_wait # This is mostly for the last_chance mod so that the rng_wait goes back to the base value when you respawn

func multiplicators():
	if settings_loaded ==false:
		is_progressive()
	@warning_ignore("narrowing_conversion")
	move_multiplicator = 1.5*rng_wait + 10
	@warning_ignore("integer_division")
	timer_reducer = init_timer/100

func global_mod_multiplier():
	# Boosters
	if hidden ==true:
		hidden_catcher =1
	else:
		hidden_catcher =0
	
	swap_catcher = 0 # The game starts with no swap "multiplier"
	
	if all_in_one ==true:
		aio_catcher =1
	else:
		aio_catcher =0
	
	delay_mtp = 4.8/latency # 4.8/0.2 gives 24 for example, the default delay_mtp value
	if delayed ==true:
		delay_catcher =1
	else:
		delay_catcher =0
	
	# Dividers ------ # See score_mod_nerf() for explanation
	if nohalt ==true:
		nohalt_catcher = 1
		nohalt_canceller = 1
	else:
		nohalt_catcher = nohalt_dvd
		nohalt_canceller = 0
	
	if only_one ==true:
		only_catcher = 1
		only_canceller = 1
	else:
		only_catcher = only_dvd
		only_canceller = 0
func score_mod_boost(): # Just to avoid repeating this everywhere case new mods are added
	@warning_ignore("integer_division")
	score += (hidden_catcher*(score/hidden_mtp))+(swap_catcher*(score/swap_mtp))+(aio_catcher*(score/aio_mtp))+(delay_catcher*(score/delay_mtp))
func score_mod_nerf():
	@warning_ignore("narrowing_conversion")
	score = (nohalt_canceller*nohalt_catcher*(score/nohalt_dvd)) # If mod_catcher = mod_dvd, there will be cancelation, hence score = score
	if score ==0:
		score = prescore
	if only_canceller !=0:
		@warning_ignore("narrowing_conversion")
		score /=only_dvd

func load_settings():
	$bg.texture = load(background)
	var config = ConfigFile.new()
	var file = config.load("user://settings.cfg")
	if file == OK:
		# Language
		var lang = config.get_value("settings", "language", "en")
		if lang in ["en", "fr"]:  # Check if valid language
			General.autolang = lang
		else:
			reset_datas()
		# High score
		var high = config.get_value("settings", "high_score", 5000)
		if high <0:
			reset_datas()
		else:
			high_score = high
		var high_sv = config.get_value("settings", "high_score_sv", 5000)
		if high_sv <0:
			reset_datas()
		else:
			high_score_sv = high_sv
	else:
		reset_datas()
	var keys = General.langkeys(up1, left1)
	up1 = keys[0]
	left1 = keys[1]
	
	move_nb = moves.size() # Number of elements in the "moves" array. Useful for the 'for' loop in the goto functions
	

func reset_datas(): # Only if language has an invalid value
	General.autolang = "fr"
	high_score = 5000
	high_score_sv = 7000

func Halter_wait_time():
	halt_wt = (rng_wait/rng_wait_base)+0.55 # The lower the rng_wait is, the shorter the Halter time will be
	$Halter.wait_time = halt_wt

func Score_viz_update():
	$Score.text = "Score: " + str(score)
	if General.autolang == "en":
		if sv_mode ==false:
			$High.text = "High Score: " + str(high_score)
		else:
			$High.text = "High Score: " + str(high_score_sv)
	elif General.autolang == "fr":
		if sv_mode ==false:
			$High.text = "Meilleur Score: " + str(high_score)
		else:
			$High.text = "Meilleur Score: " + str(high_score_sv)

# Swap mod timer
func swap_timer_init():
	if sv_mode ==false:
		@warning_ignore("integer_division")
		swap_timer = init_timer/5
	else:
		swap_timer = 15
	$Swap.wait_time = swap_timer

func set_latency_timer():
	$Upped.wait_time = latency
	$Downed.wait_time = latency
	$Lefted.wait_time = latency
	$Righted.wait_time = latency


func Stats_init():
	tot_moves =0
	tot_time =0
	die_halt =0
	survival_halt =0
	dodge_count =0
	lost_score =0
	
	tot_moves_ct =0
	tot_time_ct =0
	tot_time_ctsec =0
	tot_time_ctmin =0
	die_halt_ct =0
	survival_halt_ct =0
	dodge_count_ct =0
	lost_score_ct =0
	cons_ct =0
	
	if General.autolang == "en":
		$Statistics/Victory.text = "VICTORY!"
		$Statistics/Defeat.text = "DEFEATED"
		$Statistics/GameOver.text = "GAME OVER"
		
		$Statistics/Moves.text = "Total moves:"
		$Statistics/Time.text = "Total time elapsed:"
		$Statistics/DeathHalt.text = "Death by halt:"
		$Statistics/Rescapee.text = "Rescapee from halt:"
		$Statistics/PfDodges.text = "Perfect Dodges:"
		$Statistics/LostSc.text = "Lost score:"
		$Statistics/Sessions.text = "Sessions played in a row:"
		$Statistics/Titles.text = "Titles earned:"
		
		$Statistics/Register.text = "Submit your score online!"
		$Statistics/Register/user.placeholder_text = "Enter your player name!"
		$Statistics/Register/submit.text = "SUBMIT"
		
		$Statistics/Sure.text = "Are you sure? Press again if yes."
	elif General.autolang == "fr":
		$Statistics/Victory.text = "VICTOIRE !"
		$Statistics/Defeat.text = "PERDU"
		$Statistics/GameOver.text = "PARTIE TERMINÉE"
		
		$Statistics/Moves.text = "Déplacement effectués:"
		$Statistics/Time.text = "Temps écoulé:"
		$Statistics/DeathHalt.text = "Morts par halte:"
		$Statistics/Rescapee.text = "Survies après halte:"
		$Statistics/PfDodges.text = "Esquives parfaites:"
		$Statistics/LostSc.text = "Score perdu:"
		$Statistics/Sessions.text = "Parties jouées d'affilée:"
		$Statistics/Titles.text = "Titres obtenus:"
		
		$Statistics/Register.text = "Envoie ton score en ligne !"
		$Statistics/Register/user.placeholder_text = "Entre ton nom de joueur"
		$Statistics/Register/submit.text = "Envoyer"
	
		$Statistics/Sure.text = "Tu es sûr(e) ? Clique encore si oui."

func Pause_init():
	if General.autolang == "en":
		$Pause/bg/Resume.text = "RESUME"
		$Pause/bg/Resume/expl.text = "Continue where you paused. Get on your
		marks well before clicking this button!"
		
		$Pause/bg/Forfeit.text = "FORFEIT"
		$Pause/bg/Forfeit/expl.text = "Give up this game. You can decide to give it
		another try or leave the game afterwards."
		
		if sv_mode == false:
			$Pause/bg/GameMode.text = "- Time mode: " + str(init_timer) + "s"
		else:
			$Pause/bg/GameMode.text = "- Survival mode"
		
		# Frequency
		if progressive == true:
			$Pause/bg/Freq.text = "- Progressive rhythm"
		else:
			if rng_wait == 1.5:
				$Pause/bg/Freq.text = "- Slow rhythm"
			elif rng_wait == 0.9:
				$Pause/bg/Freq.text = "- Average rhythm"
			elif rng_wait == 0.4:
				$Pause/bg/Freq.text = "- Fast rhythm"
			elif rng_wait == 0.2:
				$Pause/bg/Freq.text = "- Very fast rhythm"
			elif rng_wait == 0.01:
				$Pause/bg/Freq.text = "- Crazy rhythm"
			else:
				$Pause/bg/Freq.text = "- Uncommon rhythm"
		
		# Game in a row
		if consecutives ==1:
			$Pause/bg/InARow.text = "- 1st game in a row"
		elif consecutives ==2:
			$Pause/bg/InARow.text = "- 2nd game in a row"
		elif consecutives ==3:
			$Pause/bg/InARow.text = "- 3rd game in a row"
		else:
			$Pause/bg/InARow.text = "- " + str(consecutives) + "th game in a row"
			
		# Your current score VS Your high score
		# List of messages said when current score < high score /2 (Was about to be /4 but I realized it would give me an unnecessary amount of work if I splitted it that much. This whole thing is already not relevant
		var score_under4th_1= "It may be hard to get that high score back but it is too early to give up now."
		var score_under4th_2= "What if you tried beating that high score?"
		var score_under4th_3= "People want to see that high score beaten! Come on!"
		var score_under4th_4= "You don't grind score today?"
		var score_under4th = [score_under4th_1, score_under4th_2, score_under4th_3, score_under4th_4]
		var sc_un4th_pick
		
		# List of messages said when current score < high score /1.25
		var score_middle_1= "Interesting performance! You are getting there!"
		var score_middle_2= "Yes! Chase that high score!"
		var score_middle_3= "You have good reflexes. The hard work is going to pay."
		var score_middle_4= "Is the high score going to be beaten ? We will know in a few minutes!"
		var score_middle = [score_middle_1, score_middle_2, score_middle_3, score_middle_4]
		var sc_mid_pick
		
		# List of messages said when current score < high score while being almost = high_score
		var score_almost_1= "Only a few amount of efforts and risks to take and high score is yours!"
		var score_almost_2= "You are so close to that high score!"
		var score_almost_3= "Now is a bad time to give up! A terrible time even!"
		var score_almost_4= "Congratulations in advance for beating the high score!"
		var score_almost = [score_almost_1, score_almost_2, score_almost_3, score_almost_4]
		var sc_alm_pick
		
		# List of messages said when current score < high score while being almost = high_score
		var score_beat_1= "You got there! Now you are not allowed to fall back!"
		var score_beat_2= "High score beaten! But watch out! Things can still be reversed."
		var score_beat_3= "Beating that high score was surely not an easy task. Keeping it until the end will surely not be any easier."
		var score_beat_4= "Imagine losing that new high score. Couldn't be you, right?"
		var score_beat = [score_beat_1, score_beat_2, score_beat_3, score_beat_4]
		var sc_beat_pick
		
		
		sc_un4th_pick = RandomNumberGenerator.new()
		sc_un4th_pick.randomize()
		sc_un4th_pick = sc_un4th_pick.randi_range(0,3)
		
		sc_mid_pick = RandomNumberGenerator.new()
		sc_mid_pick.randomize()
		sc_mid_pick = sc_mid_pick.randi_range(0,3)
		
		sc_alm_pick = RandomNumberGenerator.new()
		sc_alm_pick.randomize()
		sc_alm_pick = sc_alm_pick.randi_range(0,3)
		
		sc_beat_pick = RandomNumberGenerator.new()
		sc_beat_pick.randomize()
		sc_beat_pick = sc_beat_pick.randi_range(0,3)
		
		
		if score < old_high_score/2 || (score < old_high_score_sv/2 && sv_mode ==true):
			$Pause/bg/Compare_HS.text = score_under4th[sc_un4th_pick]
		elif (score >= old_high_score/2 && score < old_high_score/1.25) || (score >= old_high_score_sv/2 && score < old_high_score_sv/1.25 && sv_mode ==true):
			$Pause/bg/Compare_HS.text = score_middle[sc_mid_pick]
		elif (score >= old_high_score/1.25 && score < old_high_score) || (score >= old_high_score_sv/1.25 && score < old_high_score_sv && sv_mode ==true):
			$Pause/bg/Compare_HS.text = score_almost[sc_alm_pick]
		elif (score == old_high_score) || (score == old_high_score_sv && sv_mode ==true):
			$Pause/bg/Compare_HS.text = "YOU GOT THAT HIGH SCORE! Now try to beat this! Should be easy."
		else:
			$Pause/bg/Compare_HS.text = score_beat[sc_beat_pick]
		
		# Forfeit menu screen
		if score > old_high_score || (score > old_high_score_sv && sv_mode ==true):
			$Pause/sure/sureMsg.text = "Are you sure you want to forfeit ? Fair warning that your current high score will not be saved if you give up. Last chance to make the right decision."
		else:
			$Pause/sure/sureMsg.text = "Are you sure you want to forfeit ? Last chance to make the right decision."
		$Pause/sure/Yes.text = "YES"
		$Pause/sure/No.text = "NO"
	
	elif General.autolang == "fr":
		$Pause/bg/Resume.text = "REPRENDRE"
		$Pause/bg/Resume/expl.text = "Continue où tu t'es arrêté. Prépare-toi bien avant d'appuyer sur ce bouton."
		
		$Pause/bg/Forfeit.text = "ABANDONNER"
		$Pause/bg/Forfeit/expl.text = "Met un terme à cette partie ci. Tu peux décider d'en jouer une nouvelle ou de quitter."
		
		if sv_mode == false:
			$Pause/bg/GameMode.text = "- Mode temps: " + str(init_timer) + "s"
		else:
			$Pause/bg/GameMode.text = "- Mode survie"
		
		# Frequency
		if progressive == true:
			$Pause/bg/Freq.text = "- Rythme progressif"
		else:
			if rng_wait == 1.5:
				$Pause/bg/Freq.text = "- Rythme lent"
			elif rng_wait == 0.9:
				$Pause/bg/Freq.text = "- Rythme moyen"
			elif rng_wait == 0.4:
				$Pause/bg/Freq.text = "- Rythme rapide"
			elif rng_wait == 0.2:
				$Pause/bg/Freq.text = "- Rythme très rapide"
			elif rng_wait == 0.01:
				$Pause/bg/Freq.text = "- Rythme fou"
			else:
				$Pause/bg/Freq.text = "- Rythme inhabituel"
		
		# Game in a row
		if consecutives ==1:
			$Pause/bg/InARow.text = "- 1ère partie d'affilée"
		elif consecutives ==2:
			$Pause/bg/InARow.text = "- 2ème partie d'affilée"
		elif consecutives ==3:
			$Pause/bg/InARow.text = "- 3ème partie d'affilée"
		else:
			$Pause/bg/InARow.text = "- " + str(consecutives) + "ème partie d'affilée"
			
		# Your current score VS Your high score
		# List of messages said when current score < high score /2 (Was about to be /4 but I realized it would give me an unnecessary amount of work if I splitted it that much. This whole thing is already not relevant
		var score_under4th_1= "Ça doit sûrement être dur de remonter à ce meilleur score mais ce n'est pas impossible."
		var score_under4th_2= "Et si tu essayais de battre ton meilleur score ?"
		var score_under4th_3= "Les gens veulent voir ce meilleur score changer. Vas-y !"
		var score_under4th_4= "Tu te fiches du score aujourd'hui ?"
		var score_under4th = [score_under4th_1, score_under4th_2, score_under4th_3, score_under4th_4]
		var sc_un4th_pick
		
		# List of messages said when current score < high score /1.25
		var score_middle_1= "Belle progression ! Tu y arrives !"
		var score_middle_2= "Oui ! Rattrape ce meilleur score !"
		var score_middle_3= "Tu as de bons réflexes et bientôt ton dur travail va payer."
		var score_middle_4= "Est-ce qu'on va voir un nouveau meilleur score ? La réponse dans quelques minutes."
		var score_middle = [score_middle_1, score_middle_2, score_middle_3, score_middle_4]
		var sc_mid_pick
		
		# List of messages said when current score < high score while being almost = high_score
		var score_almost_1= "Encore un tout petit peu d'effort à faire et de risque à prendre et ce meilleur score sera de toi !"
		var score_almost_2= "Tu es si près du but, si près du meilleur score !"
		var score_almost_3= "Là c'est le pire moment pour abandonner. Tu y est vraiment presque !"
		var score_almost_4= "Félicitations en avance pour ton nouveau meilleur score !"
		var score_almost = [score_almost_1, score_almost_2, score_almost_3, score_almost_4]
		var sc_alm_pick
		
		# List of messages said when current score < high score while being almost = high_score
		var score_beat_1= "Oui, tu l'as fait ! Maintenant tu n'as pas le droit de tout gâcher."
		var score_beat_2= "Nouveau meilleur score ! Mais ne jubile pas trop pour le moment. Les choses peuvent viter changer si tu es maladroit."
		var score_beat_3= "Battre ce meilleur score n'était sûrement pas facile. Le conserver jusqu'à la fin le sera sûrement encore moins."
		var score_beat_4= "Tu as ta récompense. Maintenant tu dois la sécuriser."
		var score_beat = [score_beat_1, score_beat_2, score_beat_3, score_beat_4]
		var sc_beat_pick
		
		
		sc_un4th_pick = RandomNumberGenerator.new()
		sc_un4th_pick.randomize()
		sc_un4th_pick = sc_un4th_pick.randi_range(0,3)
		
		sc_mid_pick = RandomNumberGenerator.new()
		sc_mid_pick.randomize()
		sc_mid_pick = sc_mid_pick.randi_range(0,3)
		
		sc_alm_pick = RandomNumberGenerator.new()
		sc_alm_pick.randomize()
		sc_alm_pick = sc_alm_pick.randi_range(0,3)
		
		sc_beat_pick = RandomNumberGenerator.new()
		sc_beat_pick.randomize()
		sc_beat_pick = sc_beat_pick.randi_range(0,3)
		
		
		if score < old_high_score/2 || (score < old_high_score_sv/2 && sv_mode ==true):
			$Pause/bg/Compare_HS.text = score_under4th[sc_un4th_pick]
		elif (score >= old_high_score/2 && score < old_high_score/1.25) || (score >= old_high_score_sv/2 && score < old_high_score_sv/1.25 && sv_mode ==true):
			$Pause/bg/Compare_HS.text = score_middle[sc_mid_pick]
		elif (score >= old_high_score/1.25 && score < old_high_score) || (score >= old_high_score_sv/1.25 && score < old_high_score_sv && sv_mode ==true):
			$Pause/bg/Compare_HS.text = score_almost[sc_alm_pick]
		elif (score == old_high_score) || (score == old_high_score_sv && sv_mode ==true):
			$Pause/bg/Compare_HS.text = "Tu as atteint le meilleur score ! Maintenant fais mieux que ça."
		else:
			$Pause/bg/Compare_HS.text = score_beat[sc_beat_pick]
			
		# Forfeit menu screen
		if score > old_high_score || (score > old_high_score_sv && sv_mode ==true):
			$Pause/sure/sureMsg.text = "Tu es sûr(e) de vouloir abandonner ? Ton meilleur score actuel ne sera pas sauvegardé si tu abandonnes comme ça. Dernière chance de faire le bon choix."
		else:
			$Pause/sure/sureMsg.text = "Tu es sûr(e) de vouloir abandonner ? Dernière chance de faire le bon choix."
		$Pause/sure/Yes.text = "OUI"
		$Pause/sure/No.text = "NON"
	
	# Check if appreciations are disabled (false) or not (true)
	if appreciations ==false:
		$Pause/bg/Compare_HS.hide()
	else:
		$Pause/bg/Compare_HS.show()

# Swap mod (Not Stuck Swap. Swap!!!)
func normal_mode():
	left2 = "left2"
	right2 = "right2"
	up2 = "up2"
	down2 = "down2"
	blob_normal = interblob
	if swap ==true:
		$Status_dizzy.hide()
		$Status_normal.show()

func swapped_mode():
	left2 = "right2"
	right2 = "left2"
	up2 = "down2"
	down2 = "up2"
	blob_normal = blob_dizzy

func initialization():
	if settings_loaded ==false:
		pause = false
		rng2_started =false
		interblob = blob_normal # For the swap mod
		halt_timer = false
		load_settings()
		Halter_wait_time()
		multiplicators()
		set_latency_timer() # For the latency mod
		score =0
		prescore =0 # For nerf mods
		old_high_score = high_score
		old_high_score_sv = high_score_sv
		Score_viz_update()
		settings_loaded =true
		if sv_mode ==false:
			turn = init_turn
			lives = init_lives
		else:
			turn =1
			if last_chance ==false:
				lives =1
			else:
				lives =2
		
		rng_wait_backup = rng_wait
		
		beaten =false
		trueover =false
		
		Stats_init()
		# Mods
		if stuck_swap ==false:
			normal_mode()
		elif stuck_swap ==true:
			swapped_mode()
		
		if swap ==true:
			swap_timer_init()
			if hidden ==false:
				$Status_normal.show()
		
		# Score booster by perfect dodge
		if (all_in_one ==true || only_one ==true) && progressive ==false:
			dodge_score_booster = (1/rng_wait)*1000
		elif progressive ==true:
			dodge_score_booster = (1/rng_wait)*2500
		else:
			dodge_score_booster = (1/rng_wait)*4000
		
		pretimer =true # Survival mode
		
		preboost = 0
		
		final_score_turn = 0
		
		countdown =3
		$Countdown/Ctd_viz.text = str(countdown)
		$Countdown/Ctd_viz.show()
		if beginning ==false:
			$Transition.show()
			$Animation.play("GameStarts")
			beginning =true
		else:
			$Animation.play("Countdown")
			$Countdown.start()
		victory = false
		defeated = false
		calculating = false
		$Statistics/Victory.hide()
		$Statistics/Defeat.hide()
		$Statistics/GameOver.hide()
		$Statistics/Retry.hide()
		$Statistics/Exit.hide()
		
		retry_shortcut = false
		auto_hover = false
		
		sure = false
		$Statistics/Sure.hide()

# ------- GAME STARTS HERE -------
func _ready():
	initialization()
	global_mod_multiplier()
	
	#Tiles declaration
	tile1 = $Tile1
	tile2 = $Tile2
	tile3 = $Tile3
	tile4 = $Tile4
	
	blob = $Blob1
	
	dodged =false
	dodge_frame_counter =1
	
	#Timer initialization (visualizer)
	if sv_mode ==false:
		timer = init_timer # Auto setting
	else:
		if countdown !=0: # In other words, if first turn in survival mode with last chance on:
			init_timer =0
		timer = init_timer
	
	# Multiplayer-only feature
	#tot_ammo =10 #Initial value
	ammo = nbtiles-1
	#print("Base ammo: ", ammo)
	$Rng2.stop()
	startup = RandomNumberGenerator.new()
	startup.randomize()
	startup = startup.randf_range(0.4,1)
	$Rng1.wait_time = startup
	if countdown ==0:
		$Rng1.start() # Game starts
		$Timer.start()
		if progressive ==true || sv_mode ==true:
			$Progress.start()
	$Timer/TimerViz.text = str(timer)
	
	#The game starts with the blob at top left
	topl = true
	$Blob1.position = Vector2(843,392)
	if hidden ==false:
		tile1.texture = load(tile_normal)
		tile2.texture = load(tile_normal)
		tile3.texture = load(tile_normal)
		tile4.texture = load(tile_normal)
	elif hidden ==true: # Mods
		tile1.texture = load(tile_broken)
		tile2.texture = load(tile_broken)
		tile3.texture = load(tile_broken)
		tile4.texture = load(tile_broken)
	
	$Slowdown.hide()
	
	# Lives viz update
	if lives <10:
		$Lives.text = "0" + str(lives)
	else:
		$Lives.text = str(lives)
	if lives ==1 && sv_mode ==false && countdown ==0 && full_reset ==false:
		$Animation.play("OneLife")
	
	
	is_progressive()
	
	# "Swap" mod
	if swap ==true:
		normal =true
		swapped =false
		normal_mode()
		$Swap.start()
	if hidden ==true:
		$Status_normal.hide()
	
	# Turns viz update + Status update (For the swap mod) + Perfect dodge
	if General.autolang == "en":
		$Turns.text = str(init_turn-turn) + "/" + str(init_turn) + " turns cleared"
		$Status_dizzy.text = "Dizzy..."
		$Perfect.text = "Perfect dodge!"
	elif General.autolang == "fr":
		$Turns.text = str(init_turn-turn) + "/" + str(init_turn) + " tours passés"
		$Status_dizzy.text = "Étourdi..."
		$Perfect.text = "Esquive parfaite!"
	if sv_mode ==true:
		$Turns.hide()
		$Lives.hide()
	
	
	$Perfect.hide()
	boosting = false
	
	blob.texture = load(blob_normal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed(right2):
		if delayed ==false:
			goto_right()
		else:
			if action_right ==false:
				$Righted.start()
				action_right =true
	
	if Input.is_action_just_pressed(left2):
		if delayed ==false:
			goto_left()
		else:
			if action_left ==false:
				$Lefted.start()
				action_left =true
	
	if Input.is_action_just_pressed(down2):
		if delayed ==false:
			goto_down()
		else:
			if action_down ==false:
				$Downed.start()
				action_down =true
	
	if Input.is_action_just_pressed(up2):
		if delayed ==false:
			goto_up()
		else:
			if action_up ==false:
				$Upped.start()
				action_up =true
	
	
	if Input.is_action_just_pressed("confirm"):
		if retry_shortcut ==true && exiting ==false:
			if auto_hover ==false:
				_on_retry_mouse_entered()
			else:
				if full_reset ==false:
					_on_retry_button_up()
	
	if Input.is_action_just_pressed("Esc"):
		if forfeiting ==false:
			Pause_Resume()
		else:
			_on_nosure_button_up()


func Pause_Resume():
	if pause ==false && countdown ==0 && moving ==false && dead ==false && trueover ==false:
		Pause_init()
		pause =true
		$Animation.play("PauseIn")
		
		rng_wait1_paused = $Rng1.time_left
		$Rng1.stop()
		rng_wait2_paused = $Rng2.time_left
		$Rng2.stop()
		
		timer_paused = $Timer.time_left
		$Timer.stop()
		
		if halt_timer ==true:
			halt_timer_paused = $Halter.time_left
			$Halter.stop()
		
		if progressive ==true || sv_mode ==true:
			progr_timer_paused = $Progress.time_left
			print("progr pauesd")
			$Progress.stop()
		
		if delayed ==true:
			if action_up ==true:
				upped_paused = $Upped.time_left
				$Upped.stop()
			if action_down ==true:
				downed_paused = $Downed.time_left
				$Downed.stop()
			if action_left ==true:
				lefted_paused = $Lefted.time_left
				$Lefted.stop()
			if action_right ==true:
				righted_paused = $Righted.time_left
				$Righted.stop()
	
	elif pause ==true:
		$Animation.play("PauseOut")


func goto_right():
	if (topl ==true || botl ==true) && moving ==false && dead ==false && over ==false && halt ==false && pause ==false && forfeited ==false:
		$Blob1.position += Vector2(unit,0)
		trajectory +=60
		$delay.start()
		if topl ==true:
			topl = false
			ex_topl =true
		elif botl ==true:
			botl =false
			ex_botl =true
		moving =true
		right =true
		if prescore !=0:
			score = prescore
		if countdown ==0:
			tot_moves +=1
			score += move_multiplicator
			score_mod_boost()
			prescore = score
			score_mod_nerf()
			if sv_mode ==false:
				if score > old_high_score:
					high_score = score
					if beaten ==false:
						beaten = true
			else:
				if score > old_high_score_sv:
					high_score_sv = score
					if beaten_sv ==false:
						beaten_sv = true
		Score_viz_update()
		
		if nohalt ==false && countdown ==0:
			# Mashing detector
			if moves[0] ==false:
				moves[0] =true
			elif moves[0] ==true:
				for ct in range (0,move_nb-1):
					if moves[ct] ==true && moves[ct+1] ==false:
						moves[ct+1] =true
						break
			if halt_timer ==false:
				$Halter.start()
				halt_timer =true
			elif halt_timer ==true:
				stop_moving()

func goto_left():
	if (topr ==true || botr ==true) && moving ==false && dead ==false && over ==false && halt ==false && pause ==false && forfeited ==false:
		$Blob1.position -= Vector2(unit,0)
		trajectory +=60
		$delay.start()
		if topr ==true:
			topr = false
			ex_topr =true
		elif botr ==true:
			botr =false
			ex_botr =true
		moving =true
		left =true
		if prescore !=0:
			score = prescore
		if countdown ==0:
			tot_moves +=1
			score += move_multiplicator
			score_mod_boost()
			prescore = score
			score_mod_nerf()
			if sv_mode ==false:
				if score > old_high_score:
					high_score = score
					if beaten ==false:
						beaten = true
			else:
				if score > old_high_score_sv:
					high_score_sv = score
					if beaten_sv ==false:
						beaten_sv = true
		Score_viz_update()
		
		if nohalt ==false && countdown ==0:
			# Mashing detector
			if moves[0] ==false:
				moves[0] =true
			elif moves[0] ==true:
				for ct in range (0,move_nb-1):
					if moves[ct] ==true && moves[ct+1] ==false:
						moves[ct+1] =true
						break
			if halt_timer ==false:
				$Halter.start()
				halt_timer =true
			elif halt_timer ==true:
				stop_moving()

func goto_down():
	if (topl ==true || topr ==true) && moving ==false && dead ==false && over ==false && halt ==false && pause ==false && forfeited ==false:
		$Blob1.position += Vector2(0,unit)
		trajectory +=60
		$delay.start()
		if topl ==true:
			topl =false
			ex_topl =true
		elif topr ==true:
			topr =false
			ex_topr =true
		moving =true
		down =true
		if prescore !=0:
			score = prescore
		if countdown ==0:
			tot_moves +=1
			score += move_multiplicator
			score_mod_boost()
			prescore = score
			score_mod_nerf()
			if sv_mode ==false:
				if score > old_high_score:
					high_score = score
					if beaten ==false:
						beaten = true
			else:
				if score > old_high_score_sv:
					high_score_sv = score
					if beaten_sv ==false:
						beaten_sv = true
		Score_viz_update()
		
		if nohalt ==false && countdown ==0:
			# Mashing detector
			if moves[0] ==false:
				moves[0] =true
			elif moves[0] ==true:
				for ct in range (0,move_nb-1):
					if moves[ct] ==true && moves[ct+1] ==false:
						moves[ct+1] =true
						break
			if halt_timer ==false:
				$Halter.start()
				halt_timer =true
			if moves[move_nb-1] ==true:
				stop_moving()

func goto_up():
	if (botl ==true || botr ==true) && moving ==false && dead ==false && over ==false && halt ==false && pause ==false && forfeited ==false:
		$Blob1.position -= Vector2(0,unit)
		trajectory +=60
		$delay.start()
		if botl ==true:
			botl =false
			ex_botl =true
		elif botr ==true:
			botr =false
			ex_botr =true
		moving =true
		up =true
		if prescore !=0:
			score = prescore
		if countdown ==0:
			tot_moves +=1
			score += move_multiplicator
			score_mod_boost()
			prescore = score
			score_mod_nerf()
			if sv_mode ==false:
				if score > old_high_score:
					high_score = score
					if beaten ==false:
						beaten = true
			else:
				if score > old_high_score_sv:
					high_score_sv = score
					if beaten_sv ==false:
						beaten_sv = true
		Score_viz_update()
		
		if nohalt ==false && countdown ==0:
			# Mashing detector
			if moves[0] ==false:
				moves[0] =true
			elif moves[0] ==true:
				for ct in range (0,move_nb-1):
					if moves[ct] ==true && moves[ct+1] ==false:
						moves[ct+1] =true
						break
			if halt_timer ==false:
				$Halter.start()
				halt_timer =true
			if moves[move_nb-1] ==true:
				stop_moving()


#For the mine placer (the computer itself in this game mode)
func target(tile, mark: bool, hit: bool, loc_blob, blobposition: bool): #(tile1, trap_topl, bomb_topl, blob, topl) for example
	if hit ==false:
		if mark ==false && ammo >0:
			$Target.play()
			mark =true
			ammo -=1 # Losing an ammo by "targetting" a tile. 
			if hidden ==false:
				tile.texture = load(tile_target)
			if blobposition ==true:
				loc_blob.texture = load(blob_danger)
		elif mark ==true:
			hit =true
			if hidden ==false:
				th_texture = RandomNumberGenerator.new()
				th_texture.randomize()
				th_texture = randi_range(1,4)
				tile.texture = load(tile_hits[th_texture-1])
			if blobposition ==true:
				dead =true
				$Dead.play()
				lives -=1 # One life lost
				$Timer.stop()
				if swap ==true:
					$Swap.stop()
				loc_blob.texture = load(blob_hit)
				if progressive ==true:
					$Progress.stop()
				if last_chance ==false:
					@warning_ignore("integer_division")
					lost_score += (score/10)*(init_timer/5)
					@warning_ignore("integer_division")
					score -= (score/10)*(init_timer/5) # Score diminishes
				else:
					if lives ==1 && timer !=0:
						lost_score += score-(score/(timer*10))
						score /= timer*10 # Score diminishes
					elif lives ==0:
						lost_score += timer*2
						score -= timer*2
				lost_score_ct = lost_score-100
				if lost_score_ct <0:
					lost_score_ct =0
				if score < final_score_turn:
					final_score_turn -= final_score_turn*0.05
					score = final_score_turn
				prescore = score
				if sv_mode ==false:
					if score > old_high_score:
						high_score = score
						if beaten ==false:
							beaten = true
					else:
						high_score = old_high_score
						if beaten ==true:
							beaten = false
				else:
					if score > old_high_score_sv:
						high_score_sv = score
						if beaten ==false:
							beaten = true
					else:
						high_score_sv = old_high_score_sv
						if beaten ==true:
							beaten = false
				Score_viz_update()
				$Over.start() # "Loading" animation for final score.
				if halt ==true:
					die_halt +=1
					if General.autolang == "en":
						en_die_pick = RandomNumberGenerator.new()
						en_die_pick.randomize()
						en_die_pick = en_die_pick.randi_range(1,3)
						$Slowdown.text = en_die[en_die_pick-1]
					elif General.autolang == "fr":
						fr_die_pick = RandomNumberGenerator.new()
						fr_die_pick.randomize()
						fr_die_pick = fr_die_pick.randi_range(1,3)
						$Slowdown.text = fr_die[fr_die_pick-1]
			else:
				if cd1 ==false:
					$Cooldown1.start()
					cd1 =true
				elif cd2 ==false:
					$Cooldown2.start()
					cd2 =true
				elif cd3 ==false:
					$Cooldown3.start()
					cd3 =true
				elif cd4 ==false:
					$Cooldown4.start()
					cd4 =true
	
	return [mark, hit]

func blob_state(loc_blob, mark: bool): #(blob1, trap_topl) for example
	if mark ==false:
		loc_blob.texture = load(blob_normal)
	elif mark ==true:
		loc_blob.texture = load(blob_danger)


func _on_cooldown_1_timeout():
	reset_tile(blob)
	cd1 =false
func _on_cooldown_2_timeout():
	reset_tile(blob)
	cd2 =false
func _on_cooldown_3_timeout():
	reset_tile(blob)
	cd3 =false
func _on_cooldown_4_timeout():
	reset_tile(blob)
	cd4 =false


func reset_tile(loc_blob):
	if bomb_topl ==true:
		bomb_topl =false
		trap_topl =false
		if dead ==false:
			if hidden ==false:
				tile1.texture = load(tile_normal)
			elif hidden ==true:
				tile1.texture = load(tile_broken)
			if topl ==true:
				loc_blob.texture = load(blob_normal)
	elif bomb_topr ==true:
		bomb_topr =false
		trap_topr =false
		if dead ==false:
			if hidden ==false:
				tile2.texture = load(tile_normal)
			elif hidden ==true:
				tile2.texture = load(tile_broken)
			if topr ==true:
				loc_blob.texture = load(blob_normal)
	elif bomb_botl ==true:
		bomb_botl =false
		trap_botl =false
		if dead ==false:
			if hidden ==false:
				tile3.texture = load(tile_normal)
			elif hidden ==true:
				tile3.texture = load(tile_broken)
			if botl ==true:
				loc_blob.texture = load(blob_normal)
	elif bomb_botr ==true:
		bomb_botr =false
		trap_botr =false
		if dead ==false:
			if hidden ==false:
				tile4.texture = load(tile_normal)
			elif hidden ==true:
				tile4.texture = load(tile_broken)
			if botr ==true:
				loc_blob.texture = load(blob_normal)
	ammo +=1 #Delete this for multiplayer game mode.
	#Multiplayer-only feature
	#if tot_ammo >0:
		#ammo +=1
		#tot_ammo -=1
		#print("Ammo reloaded: ", ammo, " but total ammo is: ", tot_ammo)
	if all_in_one ==true || only_one ==true:
		$Rng1.wait_time = rng_wait/1.25
		$Rng1.start()
	dodge_frame_counter =1


# The "teste" functions are the one triggered when the Rng timers are on_timeout. Currently too lazy to rename them to something more normal.
func teste():
	rng_allinone() # For the all in one mod
	if dead ==false && over ==false:
		rng = RandomNumberGenerator.new()
		rng.randomize()
		if all_in_one ==false:
			rndtile = rng.randi_range(1, 4)
			rng_action()
		elif all_in_one ==true:
			for ct in range (0,3): # Doesn't work as intended with 0-2. I don't understand why it works with 3 sooo...
				rndtile = rng_multiple[ct]
				rng_action()
		$Rng2.wait_time = rng_wait
		$Rng2.start()
		rng2_started =true
		# Multiplayer-only feature
		#if test2 ==false:
			#test2 =true
			#$Timer2.start()
func teste2():
	if dead ==false && over ==false:
		rng = RandomNumberGenerator.new()
		rng.randomize()
		if all_in_one ==false && only_one ==false:
			rndtile = rng.randi_range(1, 4)
			rng_action()
			$Rng1.wait_time = rng_wait
			$Rng1.start()
		elif all_in_one ==true:
			for ct in range (0,3):
				rndtile = rng_multiple[ct]
				rng_action()
		elif only_one ==true:
			rng_action()
		# Multiplayer-only feature
		#if test2 ==false:
			#test2 =true
			#$Timer2.start()
func rng_action():
	var result
	if rndtile ==1:
		result = target(tile1, trap_topl, bomb_topl, blob, topl)
		trap_topl = result[0]
		bomb_topl = result[1]
	elif rndtile ==2:
		result = target(tile2, trap_topr, bomb_topr, blob, topr)
		trap_topr = result[0]
		bomb_topr = result[1]
	elif rndtile ==3:
		result = target(tile3, trap_botl, bomb_botl, blob, botl)
		trap_botl = result[0]
		bomb_botl = result[1]
	elif rndtile ==4:
		result = target(tile4, trap_botr, bomb_botr, blob, botr)
		trap_botr = result[0]
		bomb_botr = result[1]
# For the all_in_one mod
func rng_allinone():
	rng_multiple.clear()  # Vider le tableau
	var available_tiles = [1, 2, 3, 4]  # Tiles (pour cette fonction)

	for i in range(3):  # Changer pour 3 itérations
		var random_index = randi_range(0, available_tiles.size() - 1)
		rng_multiple.append(available_tiles[random_index])
		available_tiles.erase(available_tiles[random_index])  # Supprimer l'élément sélectionné



func _on_delay_timeout():
	if right ==true:
		if trajectory <=228:
			$Blob1.position += Vector2(unit,0)
			trajectory +=60
			if ((ex_topl ==true && bomb_topl ==true) || (ex_botl ==true && bomb_botl ==true)) && (dodged ==false && dodge_frame_counter !=0):
				dodged =true
				dodge_success()
			else:
				if dodge_frame_counter ==1:
					dodge_frame_counter -=1
			$delay.start()
		else:
			if ex_topl ==true:
				topr =true
				ex_topl =false
				blob_state(blob, trap_topr)
			elif ex_botl ==true:
				botr =true
				ex_botl =false
				blob_state(blob, trap_botr)
			moving =false
			right =false
			trajectory =1

	elif left ==true:
		if trajectory <=228:
			$Blob1.position -= Vector2(unit,0)
			trajectory +=60
			if ((ex_topr ==true && bomb_topr ==true) || (ex_botr ==true && bomb_botr ==true)) && (dodged ==false && dodge_frame_counter !=0):
				dodged =true
				dodge_success()
			else:
				if dodge_frame_counter ==1:
					dodge_frame_counter -=1
			$delay.start()
		else:
			if ex_topr ==true:
				topl =true
				ex_topr =false
				blob_state(blob, trap_topl)
			elif ex_botr ==true:
				botl =true
				ex_botr =false
				blob_state(blob, trap_botl)
			moving =false
			left =false
			trajectory =1
	
	elif down ==true:
		if trajectory <=200:
			$Blob1.position += Vector2(0,unit)
			trajectory +=60
			if ((ex_topl ==true && bomb_topl ==true) || (ex_topr ==true && bomb_topr ==true)) && (dodged ==false && dodge_frame_counter !=0):
				dodged =true
				dodge_success()
			else:
				if dodge_frame_counter ==1:
					dodge_frame_counter -=1
			$delay.start()
		else:
			if ex_topl ==true:
				botl =true
				ex_topl =false
				blob_state(blob, trap_botl)
			elif ex_topr ==true:
				botr =true
				ex_topr =false
				blob_state(blob, trap_botr)
			moving =false
			down =false
			trajectory =1
			dodged =false
	
	elif up ==true:
		if trajectory <=200:
			$Blob1.position -= Vector2(0,unit)
			trajectory +=60
			if ((ex_botl ==true && bomb_botl ==true) || (ex_botr ==true && bomb_botr ==true)) && (dodged ==false && dodge_frame_counter !=0):
				dodged =true
				dodge_success()
			else:
				if dodge_frame_counter ==1:
					dodge_frame_counter -=1
			$delay.start()
		else:
			if ex_botl ==true:
				topl =true
				ex_botl =false
				blob_state(blob, trap_topl)
			elif ex_botr ==true:
				topr =true
				ex_botr =false
				blob_state(blob, trap_topr)
			moving =false
			up =false
			trajectory =1
			dodged =false

func dodge_success():
	if boosting ==false:
		dodge_count +=1 # Stats
		if nododge_sound ==false:
			$Dodge.play()
		preboost = score
		if prescore !=0:
			score = prescore
		score += dodge_score_booster
		score_mod_boost()
		prescore = score
		score_mod_nerf()
		boosting =true
		$Incrementing.start() # "Incrementing" was my other idea for the current "boosting"
	$Perfect/Bonus.text = "+"+str(score-preboost)
	if sv_mode ==false:
		if score > old_high_score:
			high_score = score
			if beaten ==false:
				beaten = true
	else:
		if score > old_high_score_sv:
			high_score_sv = score
			if beaten_sv ==false:
				beaten_sv = true
	Score_viz_update()
	$Perfect.position = Vector2(96,704)
	$Perfect.show()
	$Animation.play("Dodged")
	$Perfect/Disappear.start()
	

func _on_disappear_timeout():
	$Perfect.hide()


func _on_timer_timeout():
	if sv_mode ==false:
		timer_limit =1
	else:
		timer_limit =0
		if pretimer ==true:
			timer =1 # For survival mode to actually work
	if timer >timer_limit:
		if sv_mode ==false:
			timer -=1
		else:
			if timer ==1 && pretimer ==true:
				timer =0
				pretimer =false
			timer +=1
		$Timer/TimerViz.text = str(timer)
		$Timer.wait_time = 1
		$Timer.start()
		if prescore !=0:
			score = prescore
		if sv_mode ==true:
			score += timer
		score += int((1.0/rng_wait + 25)*nbtiles_multiplicator)
		# the "int" forces the division being a float before converting the final result to an int. That is because the variables were declared as int, so all the operations between those ints are basically int's as well, which is unwanted in this case.

		score_mod_boost()
		prescore = score
		score_mod_nerf()
		if sv_mode ==false:
			if score > old_high_score:
				high_score = score
				if beaten ==false:
					beaten = true
		else:
			if score > old_high_score_sv:
				high_score_sv = score
				if beaten_sv ==false:
					beaten_sv = true
	elif timer ==1 && sv_mode ==false:
		over =true
		@warning_ignore("narrowing_conversion")
		if prescore !=0:
			score = prescore
		score += int(((1.0/lives)/rng_wait)*(500/init_turn) + (7200/init_timer)) # Lower remaining lives -> greater bonus, Higher initial timer -> greater bonus
		final_score_turn = score
		score_mod_boost()
		prescore = score
		score_mod_nerf()
		if score > old_high_score:
			high_score = score
			if beaten ==false:
				beaten = true
		if progressive ==true:
			$Progress.stop()
		if turn >0:
			turn -=1
		if General.autolang == "en":
			$Timer/TimerViz.text = "GREAT!"
			$Turns.text = str(init_turn-turn) + "/" + str(init_turn) + " turns cleared"
		elif General.autolang == "fr":
			$Timer/TimerViz.text = "BIEN!"
			$Turns.text = str(init_turn-turn) + "/" + str(init_turn) + " tours passés"
		if swap ==true:
			$Swap.stop()
		$Over.start()
	Score_viz_update()
	tot_time +=1

func save_high(hi: int):
	if forfeited ==false:
		var config = ConfigFile.new()
		# Charger les paramètres existants dans le fichier
		var file = config.load("user://settings.cfg")
		
		if file != OK:
			config = ConfigFile.new()  # Create new save file if corrupted
		# Saving the new high score
		config.set_value("settings", "high_score", hi)
		config.save("user://settings.cfg")

func save_high_sv(hi: int): # Survival mode
	if forfeited ==false:
		var config = ConfigFile.new()
		# Charger les paramètres existants dans le fichier
		var file = config.load("user://settings.cfg")
		
		if file != OK:
			config = ConfigFile.new()  # Create new save file if corrupted
		# Saving the new high score
		config.set_value("settings", "high_score_sv", hi)
		config.save("user://settings.cfg")


func _on_halter_timeout():
	if halt ==true:
		halt =false
		if dead ==false && over ==false:
			$Slowdown.hide()
			survival_halt +=1
			if prescore !=0:
				score = prescore
			@warning_ignore("integer_division")
			score += int((score/5)*(1.0/rng_wait))
			score_mod_boost()
			prescore = score
			score_mod_nerf()
			if sv_mode ==false:
				if score > old_high_score:
					high_score = score
					if beaten ==false:
						beaten = true
			else:
				if score > old_high_score_sv:
					high_score_sv = score
					if beaten_sv ==false:
						beaten_sv = true
			Score_viz_update()
	for ct in range (0, move_nb):
		moves[ct] =false
	moves[move_nb-1] =false
	halt_timer =false

func stop_moving():
	if moves[move_nb-1] ==true && halt ==false:
		halt =true
		$Halter.stop()
		$Halter.start()
		if General.autolang == "en":
			$Slowdown.text = "Hey! Slow down!"
		elif General.autolang == "fr":
			$Slowdown.text = "Hey! Doucement!"
		$Slowdown.show()
	else:
		tot_moves +=1


func _on_over_timeout():
	if trueover ==true || lives ==0:
		if beaten ==true && forfeited ==false:
			$Animation.play("HighScoreBeaten")
			if sv_mode ==false:
				save_high(high_score)
			else:
				save_high_sv(high_score_sv)
		else:
			$Animation.play("FinalScore")
			if forfeited ==true:
				if General.autolang == "en":
					if sv_mode ==false:
						$High.text = "High Score: " + str(old_high_score)
					else:
						$High.text = "High Score: " + str(old_high_score_sv)
				elif General.autolang == "fr":
					if sv_mode ==false:
						$High.text = "Meilleur Score: " + str(old_high_score)
					else:
						$High.text = "Meilleur Score: " + str(old_high_score_sv)
		$Lives.text = "0" + str(lives)
		if lives ==0 && forfeited ==false:
			defeated =true
		else:
			victory =true
		$PreResults.start()
	else:
		if turn >0:
			Reset()
		else:
			trueover =true
			_on_over_timeout()

func Reset():
	_on_halter_timeout()
	_on_cooldown_1_timeout()
	_on_cooldown_2_timeout()
	_on_cooldown_3_timeout()
	_on_cooldown_4_timeout()
	$Rng1.stop()
	$Rng2.stop()
	$Progress.stop()
	dead = false
	over = false
	trap_botl =false
	trap_botr =false
	trap_topl =false
	trap_topr =false
	topr =false
	botl =false
	botr =false
	forfeited = false
	halt = false
	if sv_mode ==true && last_chance ==true:
		init_timer = timer
	is_progressive()
	multiplicators()
	_ready()

# Swap mod
func _on_swap_timeout():
	if normal ==true:
		normal =false
		swapped =true
		swapped_mode()
		swap_catcher =1
		$Status_normal.hide()
		$Status_dizzy.show()
		$Animation.play("DizzyMode")
	elif swapped ==true:
		swapped =false
		normal =true
		normal_mode()
		swap_catcher =0
		$Status_normal.show()
		$Status_dizzy.hide()
		$Animation.play("NormalMode")
	if blob.texture != load(blob_danger):
		blob.texture = load(blob_normal)
	if dead ==false && over ==false:
		$Swap.start()

func _on_progress_timeout():
	if rng_wait >=0.1:
		if progressive ==true && sv_mode ==false:
			if rng_wait >0.1:
				rng_wait -= rng_wait_reducer
		else:
			if rng_wait >0.1:
				rng_wait -= 0.1
			else:
				rng_wait = 0.01
		$Rng1.wait_time = rng_wait
		$Rng2.wait_time = rng_wait
		# Score booster by perfect dodge
		dodge_score_booster = (1/rng_wait)*2500
		$Progress.start()
		multiplicators()
		Halter_wait_time()

func _on_lefted_timeout():
	goto_left()
	action_left =false

func _on_righted_timeout():
	goto_right()
	action_right =false

func _on_upped_timeout():
	goto_up()
	action_up =false

func _on_downed_timeout():
	goto_down()
	action_down =false


@warning_ignore("unused_parameter")
func hide_after_anim(anim_name):
	if anim_name == "NormalMode" || anim_name == "DizzyMode":
		if hidden ==true:
			$Status_dizzy.hide()
			$Status_normal.hide()
	elif anim_name == "GameOver":
		$Statistics/Retry.show()
		$Statistics/Exit.show()
		retry_shortcut =true
	elif anim_name == "Retry":
		full_reset =false
		$Animation.play("RESET")
	elif anim_name == "GameStarts":
		$Transition.hide()
		$Animation.play("Countdown")
		$Countdown.start()
	elif anim_name == "PauseOut": # So that the game does not immediately resume when exiting the pause menu
		pause =false
		if forfeited ==false:
			$Rng1.start(rng_wait1_paused)
			
			if rng2_started ==true:
				$Rng2.start(rng_wait2_paused)
			
			$Timer.start(timer_paused)
			
			if halt_timer ==true:
				$Halter.start(halt_timer_paused)
			
			if progressive ==true || sv_mode ==true:
				$Progress.start(progr_timer_paused)
			
			if delayed ==true:
				if action_up ==true:
					$Upped.start(upped_paused)
				if action_down ==true:
					$Downed.start(downed_paused)
				if action_left ==true:
					$Lefted.start(lefted_paused)
				if action_right ==true:
					$Righted.start(righted_paused)
		else:
			_on_over_timeout()
	
	elif anim_name == "RESET":
		settings_loaded =false
		rng_wait = rng_wait_backup
		initialization()
		if lives <10:
			$Lives.text = "0" + str(lives)
		else:
			$Lives.text = str(lives)
		if General.autolang == "en":
			$Turns.text = str(init_turn-turn) + "/" + str(init_turn) + " turns cleared"
			$Status_dizzy.text = "Dizzy..."
			$Perfect.text = "Perfect dodge!"
		elif General.autolang == "fr":
			$Turns.text = str(init_turn-turn) + "/" + str(init_turn) + " tours passés"
			$Status_dizzy.text = "Étourdi..."
			$Perfect.text = "Esquive parfaite!"
		$Animation.play("Countdown")


func _on_countdown_timeout():
	if countdown >1:
		countdown -=1
		$Countdown/Ctd_viz.text = str(countdown)
		$Countdown.start()
	else:
		countdown =0
		$Timer.start()
		$Countdown/Ctd_viz.hide()
		$Rng1.start()
		if progressive ==true || sv_mode ==true:
			$Progress.start()


func _on_incrementing_timeout():
	boosting = false

func result_screen():
	$Animation.play("GameOver")
	$Calcul.start()

func stats_calculation():
	calculating =false
	if victory ==true && forfeited ==false:
		$Statistics/Victory.show()
	elif defeated ==true && sv_mode ==false:
		$Statistics/Defeat.show()
	elif sv_mode ==true || forfeited ==true:
		$Statistics/GameOver.show()
	
	if tot_moves_ct < tot_moves:
		tot_moves_ct +=1
		calculating =true
	$Statistics/Moves/Value.text = str(tot_moves_ct)
	if tot_time_ct < tot_time && tot_time_ctsec <60: # To respect the format 00min 00sec
		tot_time_ct +=1
		tot_time_ctsec +=1
		calculating =true
	elif tot_time_ct < tot_time && tot_time_ctsec ==60:
		tot_time_ct +=1
		tot_time_ctsec =0
		tot_time_ctmin +=1
		calculating =true
	if tot_time_ctsec <10:
		$Statistics/Time/Value.text = str(tot_time_ctmin)+"min 0"+str(tot_time_ctsec)+"s"
	else:
		$Statistics/Time/Value.text = str(tot_time_ctmin)+"min "+str(tot_time_ctsec)+"s"
	if die_halt_ct < die_halt:
		die_halt_ct +=1
		calculating =true
	$Statistics/DeathHalt/Value.text = str(die_halt_ct)
	if survival_halt_ct < survival_halt:
		survival_halt_ct +=1
		calculating =true
	$Statistics/Rescapee/Value.text = str(survival_halt_ct)
	if dodge_count_ct < dodge_count:
		dodge_count_ct +=1
		calculating =true
	if progressive ==false:
		$Statistics/PfDodges/Value.text = str(dodge_count_ct) + " (x" + str(int(dodge_score_booster)) + ")"
	elif progressive == true || sv_mode ==true:
		$Statistics/PfDodges/Value.text = str(dodge_count_ct) # In progressive mode, there is not a fixed score boost since the rng_wait constantly changes
	if lost_score_ct < lost_score:
		lost_score_ct +=1
		calculating =true
	$Statistics/LostSc/Value.text = str(lost_score_ct)
	if cons_ct < consecutives:
		cons_ct +=1
		calculating =true
	$Statistics/Sessions/Value.text = str(cons_ct)
	
	if nohalt ==true:
		if General.autolang == "en":
			$Statistics/DeathHalt/Value.text += " (NoHalt was on)"
			$Statistics/Rescapee/Value.text += " (NoHalt was on)"
		elif General.autolang == "fr":
			$Statistics/DeathHalt/Value.text += " (NoHalt était actif)"
			$Statistics/Rescapee/Value.text += " (NoHalt était actif)"
	
	if calculating ==true:
		$Calcul.start()


func _on_retry_mouse_entered():
	$Animation.play("RetryHover")
	auto_hover =true
	sure = false
	$Statistics/Sure.hide()

func _on_retry_mouse_exited():
	$Animation.play("RetryLeft")
	auto_hover =false

func _on_retry_button_up():
	sure =false
	$Statistics/Sure.hide()
	$Animation.stop()
	$Statistics/Retry.hide()
	$Statistics/Exit.hide()
	consecutives +=1
	countdown =3
	Reset()
	full_reset =true
	$Animation.play("Retry")



func score_submit():
	var input_name = $Statistics/Register/user.text
	player_name = input_name
	#Saving the score online!
	SilentWolf.Scores.save_score(player_name, score)
	get_tree().change_scene_to_packed(lb_scores)


func _on_exit_button_up():
	_on_retry_mouse_exited()
	if sure ==false:
		sure =true
		$Statistics/Sure.show()
	else:
		exiting =true
		if General.autolang == "en":
			$Statistics/Sure.text = "Alright. See you soon!"
		elif General.autolang == "fr":
			$Statistics/Sure.text = "D'accord. À plus tard !"
		$Fade.show()
		$Animation.play("Exit")


func _on_resume_mouse_entered():
	$Pause/bg/Resume/expl.show()
	$Pause/bg/Forfeit/expl.hide()
func _on_resume_mouse_exited():
	$Pause/bg/Resume/expl.hide()
	$Pause/bg/Forfeit/expl.hide()

func _on_forfeit_mouse_entered():
	$Pause/bg/Forfeit/expl.show()
	$Pause/bg/Resume/expl.hide()
func _on_forfeit_mouse_exited():
	$Pause/bg/Forfeit/expl.hide()
	$Pause/bg/Resume/expl.hide()


# Paus menu buttons
func _on_resume_button_up():
	Pause_Resume()
func _on_forfeit_button_up():
	forfeiting = true
	$Pause/sure.show()

func _on_nosure_button_up():
	$Pause/sure.hide()
	forfeiting =false
func _on_yessure_button_up():
	forfeited =true
	_on_nosure_button_up()
	_on_resume_button_up()
	lives =0

func _on_pause_button():
	Pause_Resume()
