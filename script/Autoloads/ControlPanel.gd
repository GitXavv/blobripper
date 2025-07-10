extends Control


var music_menu: bool
var settings_menu: bool
var play_menu: bool
var guide_menu: bool
var tips_menu: bool
var about_menu: bool
var panel = [music_menu, settings_menu, play_menu, guide_menu, tips_menu, about_menu]

var musicTab
var settingsTab
var playTab
var guideTab
var tipsTab
var aboutTab
var Tabs

var menuText0_fr = "Musique"
var menuText1_fr = "Paramètres de jeu"
var menuText2_fr = "Jouer"
var menuText3_fr = "Guide"
var menuText4_fr = "Astuces"
var menuText5_fr = "À propos"

var menuText0_en = "Music"
var menuText1_en = "Game settings"
var menuText2_en = "Play"
var menuText3_en = "Guide"
var menuText4_en = "Tips"
var menuText5_en = "About"


var menuInfos0_en = "Give your ears some pleasure."
var menuInfos1_en = "Customize the general behaviour of the game."
var menuInfos2_en = "Log in to be able to submit your top score online!"
var menuInfos3_en = "Learn the basics of this game."
var menuInfos4_en = "Information you must know in order to understand the game better and get better at it."
var menuInfos5_en = "Some more information about the game no one really cares about."

var menuInfos0_fr = "Donne à tes oreilles un peu de plaisir."
var menuInfos1_fr = "Personnalise le comportement général du jeu."
var menuInfos2_fr = "Connecte-toi pour pouvoir publier ton meilleur score!"
var menuInfos3_fr = "Apprends les bases du jeu."
var menuInfos4_fr = "Quelques informations utiles pour mieux comprendre le jeu et s'améliorer."
var menuInfos5_fr = "Quelques détails du jeu un peu moins intéressants."


var menuTexts = [menuText0_fr, menuText1_fr, menuText2_fr, menuText3_fr, menuText4_fr, menuText5_fr,
				 menuText0_en, menuText1_en, menuText2_en, menuText3_en, menuText4_en, menuText5_en]

var menuInfos = [menuInfos0_fr, menuInfos1_fr, menuInfos2_fr, menuInfos3_fr, menuInfos4_fr, menuInfos5_fr,
				menuInfos0_en, menuInfos1_en, menuInfos2_en, menuInfos3_en, menuInfos4_en, menuInfos5_en]

var switching: bool

var exitClicked: bool


func load_settings():
	var config = ConfigFile.new()
	var file = config.load("user://settings.cfg")
	if file == OK:
		# Language
		var lang = config.get_value("settings", "language", "en")
		if lang in ["en", "fr"]:  # Check if valid language
			General.autolang = lang
		else:
			General.autolang = "fr"


func _ready():
	load_settings()
	
	musicTab = $Music
	settingsTab = $Settings
	playTab = $Play
	guideTab = $Guide
	tipsTab = $Tips
	aboutTab = $About
	Tabs = [musicTab, settingsTab, playTab, guideTab, tipsTab, aboutTab]
	
	$Splashscreen.show()
	$Transitions.play("intro")
	
	init_panel()
	
	exitClicked = false
	
	sure_msg()

func sure_msg():
	if General.autolang == "fr":
		$sure/sureMsg.text = "Tu es sûr(e) de vouloir quitter maintenant ? Tu n'es pas obligé(e) de partir maintenant, tu sais ?"
		$sure/Yes.text = "OUI, JE SUIS TRÈS SÛR(E)"
		$sure/No.text = "BON JE VAIS RESTER ENCORE UN PEU"
	elif General.autolang == "en":
		$sure/sureMsg.text = "Are you sure you want to exit the game now? Nothing forces you to go, you know?"
		$sure/Yes.text = "YES PLEASE LET ME OUT"
		$sure/No.text = "I WILL STAY FOR A BIT LONGER"

func init_panel():
	_on_play_button_up()

func switch_menu(index: int):
	for i in range(0,6):
		panel[i] = false
		Tabs[i].position.y = -16
		Tabs[i].button_pressed = false
	if General.autolang == "fr":
		$MenuText_PlaceHolder/MenuText.text = menuTexts[index]
		$BottomPlaceholder/Text.text = menuInfos[index]
	elif General.autolang == "en":
		$MenuText_PlaceHolder/MenuText.text = menuTexts[index+6]
		$BottomPlaceholder/Text.text = menuInfos[index+6]
	panel[index] = true
	Tabs[index].position.y = 0
	Tabs[index].button_pressed = true
	
	# Hide the login, leaderboard and logout buttons when outside of the Play tab
	if index != 2:
		$BottomPlaceholder/Leaderboard.hide()
		$BottomPlaceholder/Login.hide()
		$BottomPlaceholder/Logout.hide()
	else:
		$BottomPlaceholder/Leaderboard.show()
		$BottomPlaceholder/Login.show()
		$BottomPlaceholder/Logout.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("msc"):
		_on_music_button_up()
	if Input.is_action_just_pressed("stg"):
		_on_settings_button_up()
	if Input.is_action_just_pressed("play"):
		_on_play_button_up()
	if Input.is_action_just_pressed("gde"):
		_on_guide_button_up()
	if Input.is_action_just_pressed("tip"):
		_on_tips_button_up()
	if Input.is_action_just_pressed("abt"):
		_on_about_button_up()
	if Input.is_action_just_pressed("Esc"):
		exitButton()
	if Input.is_action_just_pressed("confirm"):
		Exit_Game()


func _on_music_button_up():
	switch_menu(0)
func _on_settings_button_up():
	switch_menu(1)
func _on_play_button_up():
	switch_menu(2)
func _on_guide_button_up():
	switch_menu(3)
func _on_tips_button_up():
	switch_menu(4)
func _on_about_button_up():
	switch_menu(5)


func exitButton():
	if exitClicked ==false:
		$sure.show()
		exitClicked = true
	elif exitClicked ==true:
		$sure.hide()
		exitClicked = false

func Exit_Game():
	if exitClicked ==true:
		$Transitions.play("outro")


func _on_transitions_animation_finished(anim_name):
	if anim_name == "outro":
		get_tree().quit()
