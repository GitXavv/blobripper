extends Control

var mainpage: bool
var login_page: bool
var signin_page: bool
var sign_laststep: bool
var backup_page: bool
var setting_new_password: bool

var banned_words = [
	"fuck",
	"bitch",
	"asshole",
	"nigger",
	"nigga",
	"faggot",
	"cunt",
	"pussy",
	"motherfucker",
	"whore",
	"retard",
	"hitler",
	"nazi",
	"kike",
	"coon",
	"slut",
	"rape",
	"dick",
	"cock",
	"cum",
	"spic",
	"chink",
	"beaner",
	"wetback",
	"dyke",
	"gook",
	"negro",
	"jizz",
	"bollocks",
	"arse",
	"bollok",
	"fag",
	"pedo",
	"molest",
	"incest",
	"suicide",
	"kys",
	"killyourself",
	"penis",
	"onlyfans",
	"satan",
	"vagina",
	"anal",
	"masturbate",
	"hentai",
	"kill yourself",
	"porn",
	
	"putain",
	"salope",
	"connard",
	"con",
	"enculé",
	"nique",
	"couille",
	"pute",
	"zizi",
	"bordel",
	"fils de pute",
	"cul",
	"batard",
	"fdp",
	"pd",
	"enculer",
	"pédé",
	"bite",
	"foutre",
	"nique",
	"enfoiré",
	"baise"
]

var pending_username: String
var pending_password: String
var pending_qconfirm: String
var pending_aconfirm: String

# Texts
var inappropriate_name: String
var character_max: String
var strong_pass: String
var already_exists: String
var already_exists_caught_late: String # If a player's nickname somehow changes when another player is creating an account with that exact nicknameS
var not_found: String
var bad_password: String
var incomplete: String
var logintext: String
var loginsubtext: String
var signintext: String
var signinsubtext: String
var orText: String
var loginbutton: String
var signinbutton: String

var nicknameText: String
var nicknameDescLog: String
var nicknameDescSign: String

var passwordText: String
var passwordDescLog: String
var passwordDescSign: String

var extra: String

# Login: Next Step
var almost: String
var give_correct: String
var give_coorect_desc: String
var user_question: String # User's confirmation question got in the database
var answer_text: String
var answer_desc: String

var bad_answer: String
var empty_answer: String
var profile_corrupted: String
var server_error: String

var corrupted: bool
var success: bool
var caught_late: bool

# Signin: Next Step
var setup_question: String
var setup_question_desc: String
var setup_question_plholder: String
var unique_answer: String
var unique_answer_desc: String
var unique_answer_plholder: String

# Signin: Last Step
var laststep: String
var beware: String
var case_sensitive: String
var ans1: String
var ans2: String
var ans3: String
var sign_for_real: String
var hold_ctrl: String
var char_max_2: String

# Backup
var updating: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	mainpage = true
	login_page = false
	signin_page = false
	sign_laststep = false
	backup_page = false
	setting_new_password = false
	
	corrupted = false
	success = false
	caught_late = false
	updating = false
	
	pending_reset()
	translations()
	load_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("LeftCtrl"):
		if mainpage ==true:
			$MainPage/LoginSpace/Password/input.secret = false
			$MainPage/SigninSpace/Password/input.secret = false
		elif signin_page ==true:
			$SigninStep2/LoginSpace/Answer/input.secret = false
		elif sign_laststep ==true:
			$SigninFinalStep/SigninSpace/Q_A1/A1/input.secret = false
			$SigninFinalStep/SigninSpace/Q_A2/A2/input.secret = false
			$SigninFinalStep/SigninSpace/Q_A3/A3/input.secret = false
		elif backup_page == true:
			$ForgotPassword/LoginSpace/Q_A1/A1/input.secret = false
			$ForgotPassword/LoginSpace/Q_A2/A2/input.secret = false
			$ForgotPassword/LoginSpace/Q_A3/A3/input.secret = false
		elif setting_new_password == true:
			$Backup1/LoginSpace/Password/input.secret = false
	if Input.is_action_just_released("LeftCtrl"):
		if mainpage ==true:
			$MainPage/LoginSpace/Password/input.secret = true
			$MainPage/SigninSpace/Password/input.secret = true
		elif signin_page ==true:
			$SigninStep2/LoginSpace/Answer/input.secret = true
		elif sign_laststep ==true:
			$SigninFinalStep/SigninSpace/Q_A1/A1/input.secret = true
			$SigninFinalStep/SigninSpace/Q_A2/A2/input.secret = true
			$SigninFinalStep/SigninSpace/Q_A3/A3/input.secret = true
		elif backup_page == true:
			$ForgotPassword/LoginSpace/Q_A1/A1/input.secret = true
			$ForgotPassword/LoginSpace/Q_A2/A2/input.secret = true
			$ForgotPassword/LoginSpace/Q_A3/A3/input.secret = true
		elif setting_new_password == true:
			$Backup1/LoginSpace/Password/input.secret = true


func translations():
	if General.autolang == "en":
		inappropriate_name = "That nickname contains an inappropriate term. Please avoid slurs and adult terms in your username."
		character_max = "25 characters maximum, spaces included"
		strong_pass = "Put something strong, hard to guess"
		already_exists = "Another player already has this nickname. You can make yours more unique by adding some digits and special characters."
		already_exists_caught_late = "Hmm?! It appears that another player already uses the same nickname as yours, which was not the case earlier. Either someone else was also creating their account at the same time as you with the exact same nickname as you but was faster than you or something even stranger happened. Unfortunately, you will have to start all over with a different nickname."
		not_found = "There is no Blobsweeper profile with this nickname. Make sure you spelt it right. Oh and no, you do not have to worry about case sensitivity."
		bad_password = "Hmm.. incorrect password. Make sure you wrote it right. Note that the password is case sensitive."
		incomplete = "You did not fill all the fields. Fill them all before continuing."
		
		logintext = "Log in"
		loginsubtext = "if you already have an account"
		signintext = "Sign in"
		signinsubtext = "to join the Blobsweeper online scene"
		
		orText = "or"
		
		loginbutton = "Log in"
		signinbutton = "Sign in"
		
		nicknameText = "Nickname"
		nicknameDescLog = "The name of your account"
		nicknameDescSign = "Think of a memorable nickname unique to you"
		
		passwordText = "Password"
		passwordDescLog = "Hold Ctrl to show what you are typing"
		passwordDescSign = "Remember very well this password if you plan to play often"
		
		#----------------------LOG IN
		almost = "You're almost there!"
		give_correct = "Give the correct answer"
		give_coorect_desc = "to this question to gain access to " # + username
		answer_text = "Answer"
		answer_desc = "Note that the answer is case sensitive"
		
		bad_answer = "Wrong answer. Make sure you spelt the answer right."
		empty_answer = "You did not put any answer. You have to answer the question in order to log in successfully."
		profile_corrupted = "Something strange just happened to the account you are trying to connect to. You will be redirected to the Log In window."
		server_error = "An error server-side occured. It is not your fault, it is mine..."
		
		#----------------------SIGN IN
		setup_question = "Set up the question"
		setup_question_desc = "to answer when logging in to this account next time"
		setup_question_plholder = "Think about a unique question only you can answer." + '\nExample: "What is my favourite food?"'
		
		unique_answer = "The unique ans."
		unique_answer_desc = "to your unique question. The answer is case sensitive! Hold Ctrl to reveal it. 80 characters maximum."
		unique_answer_plholder = 'Example: "Any kind of Bakery" which is different from "any kind of bakery"'
		
		#----------------------LAST STEP
		laststep = "It's the last step!"
		beware = "Now you are going to configure your backup questions. If you ever forget your password or your Log in answer, the backup method to recover your account will be to answer correctly this series of 3 questions set by yourself. Be careful and focused at this part as there will be no other way to recover your account if you don't remember even 1 answer of your backup questions!"
		ans1 = "Answer 1"
		ans2 = "Answer 2"
		ans3 = "Answer 3"
		case_sensitive = "The answer is case sensitive!"
		sign_for_real = "Sign in (for real this time)"
		hold_ctrl = "Hold Ctrl to reveal all the answers"
		char_max_2 = "80 characters maximum"
		
	elif General.autolang == "fr":
		inappropriate_name = "Ce pseudo a un terme inapproprié. S'il te plait évite les insultes et les termes adultes dans ton pseudo."
		character_max = "25 caractères maximum, espaces inclus"
		strong_pass = "Met quelque chose de difficile à deviner"
		already_exists = "Un autre joueur utilise déjà ce pseudo. Tu peux rendre le tien plus unique en ajoutant quelques chiffres et caractères spéciaux."
		already_exists_caught_late = "Hmm ?! Apparemment, un autre joueur a le même pseudo que toi, ce qui n'était pas le cas plus tôt. Soit la personne était aussi en train de créer son compte au même moment que toi avec le même pseudo que toi mais a été plus rapide que toi, soit quelque chose d'encore plus étrange s'est passé. Malheureusement, tu vas devoir tout recommencer, avec un pseudo différent."
		not_found = "Aucun profil Blobsweeper n'utilise ce pseudo. Vérifie que tu l'as bien écrit. Au fait, tu n'as pas à t'inquiéter pour la casse."
		bad_password = "Le mot de passe ne correspond pas. Vérifie que tu l'as bien écrit. Le mot de passe est sensible à la casse."
		incomplete = "Tu n'as pas rempli tous les champs. Remplis-les tous avant de continuer."

		logintext = "Connecte-toi"
		loginsubtext = "si tu as déjà un compte"
		signintext = "Inscris-toi"
		signinsubtext = "pour rejoindre la scène en ligne"
		
		orText = "ou"
		
		loginbutton = "Connexion"
		signinbutton = "Inscription"
		
		nicknameText = "Pseudo"
		nicknameDescLog = "Le nom de ton compte"
		nicknameDescSign = "Pense à un nom vraiment unique à toi"
		
		passwordText = "MDP"
		passwordDescLog = "Maintiens Ctrl pour afficher ce que tu tapes"
		passwordDescSign = '"Mot De Passe". Retiens-le très bien'
		
		#----------------------LOG IN
		almost = "Tu y es presque !"
		give_correct = "Donne la réponse exacte"
		give_coorect_desc = "pour avoir accès au compte " # + username
		answer_text = "Réponse"
		answer_desc = "Note que la réponse est sensible à la casse"
		
		bad_answer = "Mauvaise réponse. Vérifie que tu l'as bien écrite."
		empty_answer = "Tu n'as mis aucune réponse. Tu dois répondre à la question pour pouvoir être effectivement connecté à ton compte."
		profile_corrupted = "Quelque chose d'étrange vient d'arriver au compte auquel tu essayes de te connecter. Tu vas devoir recommencer la connexion à zéro."
		server_error = "Une erreur côté serveur est survenue. Ce n'est pas de ta faute, c'est la mienne..."
		
		#----------------------SIGN IN
		setup_question = "Choisis la question"
		setup_question_desc = "à laquelle répondre en essayant de se connecter à ce compte la prochaine fois"
		setup_question_plholder = "Pense à une question spéciale à laquelle toi et toi seul(e) peut répondre." + '\nExemple: "Comment s\'appelle le chat que j\'avais à mes 9-13 ans?"'
		
		unique_answer = "La rép. unique"
		unique_answer_desc = "à ta question unique. La réponse est sensible à la casse ! Maintiens Ctrl pour l'afficher. 80 caractères maximum."
		unique_answer_plholder = 'Exemple: "Bobert" qui est différent de "bobert"'
		
		#----------------------LAST STEP
		laststep = "C'est la dernière étape !"
		beware = "Là tu t'apprêtes à configurer tes questions de récupération. Si jamais tu oublies ton mot de passe ou bien ta réponse de connexion à ton compte, la seule façon de récupérer ton compte sera de répondre à cette série de 3 questions que tu auras configurée toi-même. Fais attention et soit concentré(e) à cette partie-ci parce que tu n'auras plus aucun autre moeyn de récupérer ton compte si jamais tu oublies une seule des réponses !"
		ans1 = "Réponse 1"
		ans2 = "Réponse 2"
		ans3 = "Réponse 3"
		case_sensitive = "La réponse est sensible à la casse !"
		sign_for_real = "Inscription (pour de vrai cette fois)"
		hold_ctrl = "Maintiens Ctrl pour afficher toutes les réponses"
		char_max_2 = "80 caractères maximum"


func load_text():
	$MainPage/Top/LoginText.text = logintext
	$MainPage/Top/LoginText/LoginSubText.text = loginsubtext
	
	$MainPage/Top/SigninText.text = signintext
	$MainPage/Top/SigninText/SigninSubText.text = signinsubtext
	
	$MainPage/or.text = orText
	
	$MainPage/LoginSpace/NextStep.text = loginbutton
	$MainPage/SigninSpace/NextStep.text = signinbutton
	
	$MainPage/LoginSpace/Nickname.text = nicknameText
	$MainPage/SigninSpace/Nickname.text = nicknameText
	$MainPage/LoginSpace/Nickname/desc.text = nicknameDescLog
	$MainPage/SigninSpace/Nickname/desc.text = nicknameDescSign
	
	$MainPage/LoginSpace/Password.text = passwordText
	$MainPage/SigninSpace/Password.text = passwordText
	$MainPage/LoginSpace/Password/desc.text = passwordDescLog
	$MainPage/SigninSpace/Password/desc.text = passwordDescSign
	
	$MainPage/SigninSpace/Nickname/input.placeholder_text = character_max
	$MainPage/SigninSpace/Password/input.placeholder_text = strong_pass
	
	$LoginStep2/Top/LoginText/Almost.text = almost
	$LoginStep2/LoginSpace/GiveCorrAns.text = give_correct
	$LoginStep2/LoginSpace/GiveCorrAns/desc.text = give_coorect_desc
	$LoginStep2/LoginSpace/Answer.text = answer_text
	$LoginStep2/LoginSpace/Answer/desc.text = answer_desc
	$LoginStep2/LoginSpace/LoginButton.text = loginbutton
	$LoginStep2/Top/LoginText.text = logintext

	$SigninStep2/Top/SigninText.text = signintext
	$SigninStep2/Top/SigninText/Almost.text = almost
	$SigninStep2/LoginSpace/SetQuestion.text = setup_question
	$SigninStep2/LoginSpace/SetQuestion/desc.text = setup_question_desc
	$SigninStep2/LoginSpace/SetQuestion/Question.placeholder_text = setup_question_plholder
	$SigninStep2/LoginSpace/Answer.text = unique_answer
	$SigninStep2/LoginSpace/Answer/desc.text = unique_answer_desc
	$SigninStep2/LoginSpace/Answer/input.placeholder_text = unique_answer_plholder
	$SigninStep2/LoginSpace/FinalStep.text = signinbutton
	
	$SigninFinalStep/Top/SigninText.text = signintext
	$SigninFinalStep/Top/SigninText/Almost.text = laststep
	$SigninFinalStep/SigninSpace/Beware.text = beware
	$SigninFinalStep/SigninSpace/Q_A1/A1.text = ans1
	$SigninFinalStep/SigninSpace/Q_A2/A2.text = ans2
	$SigninFinalStep/SigninSpace/Q_A3/A3.text = ans3
	
	$SigninFinalStep/SigninSpace/Q_A1/Q1/input.placeholder_text = char_max_2
	$SigninFinalStep/SigninSpace/Q_A2/Q2/input.placeholder_text = char_max_2
	$SigninFinalStep/SigninSpace/Q_A3/Q3/input.placeholder_text = char_max_2
	
	$SigninFinalStep/SigninSpace/Q_A1/A1/input.placeholder_text = case_sensitive
	$SigninFinalStep/SigninSpace/Q_A2/A2/input.placeholder_text = case_sensitive
	$SigninFinalStep/SigninSpace/Q_A3/A3/input.placeholder_text = case_sensitive
	
	$SigninFinalStep/SigninSpace/SignIn.text = sign_for_real
	$SigninFinalStep/SigninSpace/Hold.text = hold_ctrl

func is_username_clean(username):
	var uname_lower = username.to_lower()
	for word in banned_words:
		if word in uname_lower:
			$errorBG/error.text = inappropriate_name
			$errorBG.show()
			$MainPage/SigninSpace/Nickname/input.text = ""
			return

	check_username_exists(username) # Sign in


func check_username_exists(username):
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_check_username_response)

	var url = "http://localhost/blobsweeper/check_username.php"
	var body = "username=%s" % username.uri_encode()
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	var error = http.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Erreur requête :", error)

func _on_check_username_response(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	print("Réponse brute :", response_text)

	if response_text != "":
		var json = JSON.new()
		if json.parse(response_text) == OK:
			var data = json.get_data()
			match data["status"]:
				"exists":
					if updating == false:
						$errorBG/error.text = already_exists
						$errorBG.show()
					else:
						mainpage = false
						setting_new_password = false
						signin_page = true
						if updating ==false:
							pending_username = $MainPage/SigninSpace/Nickname/input.text
							pending_password = $MainPage/SigninSpace/Password/input.text
						else:
							pending_password = $Backup1/LoginSpace/Password/input.text
						$MainPage.hide()
						$Backup1.hide()
						$SigninStep2.show()
				"available":
					mainpage = false
					setting_new_password = false
					signin_page = true
					if updating ==false:
						pending_username = $MainPage/SigninSpace/Nickname/input.text
						pending_password = $MainPage/SigninSpace/Password/input.text
					else:
						pending_password = $Backup1/LoginSpace/Password/input.text
					$MainPage.hide()
					$Backup1.hide()
					$SigninStep2.show()
				_:
					print("Réponse inconnue :", data)
					$errorBG/error.text = server_error
					$errorBG.show()
		else:
			print("Erreur parsing JSON")
			$errorBG/error.text = server_error
			$errorBG.show()
	else:
		print("Réponse vide")
		$errorBG/error.text = server_error
		$errorBG.show()




func _on_sign_in_button_up():
	if $MainPage/SigninSpace/Nickname/input.text == "" || $MainPage/SigninSpace/Password/input.text == "":
		$errorBG/error.text = incomplete
		$errorBG.show()
	is_username_clean($MainPage/SigninSpace/Nickname/input.text)

func _on_login_button_up():
	if $MainPage/LoginSpace/Nickname/input.text == "" || $MainPage/LoginSpace/Password/input.text == "":
		$errorBG/error.text = incomplete
		$errorBG.show()
	else:
		if updating == false:
			LoginProcess()
		else:
			is_username_clean(pending_username)


func _on_ok_button_up():
	$errorBG.hide()
	$errorBG/extra.hide()
	if corrupted == true:
		back_first_step()
	if caught_late == true:
		back_second_step()
		back_first_step()

func back_first_step():
	$LoginStep2/LoginSpace/Answer/input.text = ""
	$LoginStep2/LoginSpace/GiveCorrAns/Question.text = ""
	
	$SigninStep2/LoginSpace/Answer/input.text = ""
	$SigninStep2/LoginSpace/SetQuestion/Question.text = ""
	
	$MainPage/LoginSpace/Password/input.text = ""
	$MainPage/SigninSpace/Password/input.text = ""
	
	$SigninStep2/LoginSpace/Answer/input.text = ""
	
	$LoginStep2.hide()
	$SigninStep2.hide()
	pending_reset()
	login_page = false
	signin_page = false
	mainpage = true
	$MainPage.show()

func pending_reset():
	pending_username = ""
	pending_password = ""

func back_second_step():
	$SigninFinalStep/SigninSpace/Q_A1/A1/input.text = ""
	$SigninFinalStep/SigninSpace/Q_A2/A2/input.text = ""
	$SigninFinalStep/SigninSpace/Q_A3/A3/input.text = ""
	pending_qconfirm = ""
	pending_aconfirm = ""
	sign_laststep = false
	signin_page = true
	$SigninFinalStep.hide()
	$SigninStep2.show()


func LoginProcess():
	var username = $MainPage/LoginSpace/Nickname/input.text
	var password = $MainPage/LoginSpace/Password/input.text

	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)

	var url = "http://localhost/blobsweeper/login.php"
	var body = "username=%s&password=%s" % [
		username.uri_encode(),
		password.uri_encode()
	]


	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	var error = http.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Erreur requête :", error)

func _on_request_completed(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	print("Réponse brute :", response_text)

	if response_text != "":
		var json = JSON.new()
		if json.parse(response_text) == OK:
			var data = json.get_data()
			match data["status"]:
				"not_found":
					$errorBG/error.text = not_found
					$errorBG.show()
				"wrong_password":
					$errorBG/error.text = bad_password
					if General.autolang == "en":
						extra = "I forgot my password"
					elif General.autolang == "fr":
						extra = "J'ai oublié mon mot de passe"
					$errorBG/extra.text = extra
					$errorBG/extra.show()
					$errorBG.show()
				"need_confirmation":
					$MainPage.hide()
					mainpage = false
					setting_new_password = false
					pending_username = data["username_cased"]
					pending_password = $MainPage/LoginSpace/Password/input.text
					$LoginStep2/LoginSpace/GiveCorrAns/Question.text = data["question"]
					$LoginStep2/LoginSpace/GiveCorrAns/desc.text = give_coorect_desc + pending_username
					login_page = true
					$LoginStep2.show()
		else:
			print("Erreur parsing JSON")
			$errorBG/error.text = server_error
			$errorBG.show()
	else:
		print("Réponse vide")
		$errorBG/error.text = server_error
		$errorBG.show()


func submit_answer():
	var answer = $LoginStep2/LoginSpace/Answer/input.text
	
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_answer_response)
	
	var url = "http://localhost/blobsweeper/confirm_answer.php"
	var body = "username=%s&password=%s&answer=%s" % [
		pending_username.uri_encode(),
		pending_password.uri_encode(),
		answer.uri_encode()
	]
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	
	var error = http.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Erreur requête :", error)

func _on_answer_response(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	
	if response_text != "":
		var json = JSON.new()
		if json.parse(response_text) == OK:
			var data = json.get_data()
			match data["status"]:
				"success":
					print("Connexion validée !")
					Connection.username = data["username_cased"]
					Connection.password = $MainPage/LoginSpace/Password/input.text
					# Ici tu peux naviguer vers le menu principal
				"wrong_answer":
					$errorBG/error.text = bad_answer
					if General.autolang == "en":
						extra = "I forgot the answer"
					elif General.autolang == "fr":
						extra = "J'ai oublié la réponse"
					$errorBG/extra.text = extra
					$errorBG/extra.show()
					$errorBG.show()
				"not_found":
					$errorBG/error.text = profile_corrupted
					corrupted = true
					$errorBG.show()
				_:
					print("Réponse inconnue :", data)
					$errorBG/error.text = server_error
					$errorBG.show()
		else:
			print("Erreur parsing JSON")
			$errorBG/error.text = server_error
			$errorBG.show()
	else:
		print("Réponse vide")
		$errorBG/error.text = server_error
		$errorBG.show()

func _on_login_final_button_up():
	if $LoginStep2/LoginSpace/Answer/input.text == "":
		$errorBG/error.text = empty_answer
		$errorBG.show()
	else:
		submit_answer()


func _on_back_1st_step_button_up():
	back_first_step()

func _on_back_2nd_step_button_up():
	back_second_step()

func _on_final_step_button_up():
	if $SigninStep2/LoginSpace/SetQuestion/Question.text == "" || $SigninStep2/LoginSpace/Answer/input.text == "":
		$errorBG/error.text = incomplete
		$errorBG.show()
	else:
		pending_qconfirm = $SigninStep2/LoginSpace/SetQuestion/Question.text
		pending_aconfirm = $SigninStep2/LoginSpace/Answer/input.text
		signin_page = false
		sign_laststep = true
		$SigninStep2.hide()
		if updating == true:
			if General.autolang == "en":
				sign_for_real = "Update account"
			elif General.autolang == "fr":
				sign_for_real = "Mettre à jour compte"
		$SigninFinalStep.show()

# SIGNING UP
func finalize_registration():
	# On récupère les 3 questions et 3 réponses
	var q1 = $SigninFinalStep/SigninSpace/Q_A1/Q1/input.text
	var a1 = $SigninFinalStep/SigninSpace/Q_A1/A1/input.text
	var q2 = $SigninFinalStep/SigninSpace/Q_A2/Q2/input.text
	var a2 = $SigninFinalStep/SigninSpace/Q_A2/A2/input.text
	var q3 = $SigninFinalStep/SigninSpace/Q_A3/Q3/input.text
	var a3 = $SigninFinalStep/SigninSpace/Q_A3/A3/input.text

	# Vérifie qu'aucun champ n'est vide
	if q1 == "" or a1 == "" or q2 == "" or a2 == "" or q3 == "" or a3 == "":
		$errorBG/error.text = incomplete
		$errorBG.show()
		return

	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_registration_response)

	var url = "http://localhost/blobsweeper/register.php"
	if updating == true:
		url = "http://localhost/blobsweeper/update_account.php"
	var body = "username=%s&password=%s&q_confirm=%s&a_confirm=%s&q1=%s&a1=%s&q2=%s&a2=%s&q3=%s&a3=%s" % [
		pending_username.uri_encode(),
		pending_password.uri_encode(),
		pending_qconfirm.uri_encode(),
		pending_aconfirm.uri_encode(),
		q1.uri_encode(),
		a1.uri_encode(),
		q2.uri_encode(),
		a2.uri_encode(),
		q3.uri_encode(),
		a3.uri_encode()
	]
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	var error = http.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Erreur requête :", error)

func _on_registration_response(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	print("Réponse brute :", response_text)

	if response_text != "":
		var json = JSON.new()
		if json.parse(response_text) == OK:
			var data = json.get_data()
			match data["status"]:
				"success":
					print("Inscription réussie !")
					Connection.username = pending_username
					Connection.password = pending_password
					# Ici tu peux rediriger vers la page de connexion
				"updated":
					print("Mise à jour réussie !")
					Connection.username = pending_username
					Connection.password = pending_password
				"exists":
					print("Ce pseudo existe déjà.")
					$errorBG/error.text = already_exists_caught_late
					caught_late = true
					$errorBG.show()
				_:
					print("Réponse inconnue :", data)
					$errorBG/error.text = server_error
					$errorBG.show()
		else:
			print("Erreur parsing JSON")
			$errorBG/error.text = server_error
			$errorBG.show()
	else:
		print("Réponse vide")
		$errorBG/error.text = server_error
		$errorBG.show()


func actual_sign_in():
	finalize_registration()


func _on_extra_button_up():
	mainpage = false
	backup_page = true
	$MainPage.hide()
	pending_username = $MainPage/LoginSpace/Nickname/input.text
	load_recovery_questions()
	$errorBG.hide()
	$ForgotPassword.show()


# Recover the account
func _on_submit_answers_button_up():
	submit_recovery_answers()

func load_recovery_questions():
	pending_username = $MainPage/LoginSpace/Nickname/input.text

	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_recovery_questions_loaded)
	
	var url = "http://localhost/blobsweeper/get_recovery_questions.php"
	var body = "username=%s" % pending_username.uri_encode()
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	
	var error = http.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Erreur requête :", error)

func _on_recovery_questions_loaded(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	print("Réponse brute :", response_text)
	
	if response_text != "":
		var json = JSON.new()
		if json.parse(response_text) == OK:
			var data = json.get_data()
			match data["status"]:
				"success":
					# Remplir les LineEdit
					$ForgotPassword/LoginSpace/Q_A1/Q1/input.text = data["q1"]
					$ForgotPassword/LoginSpace/Q_A2/Q2/input.text = data["q2"]
					$ForgotPassword/LoginSpace/Q_A3/Q3/input.text = data["q3"]
					
				"not_found":
					$errorBG/error.text = "No account found with this username."
					$errorBG.show()
				_:
					$errorBG/error.text = "Unexpected server response."
					$errorBG.show()
		else:
			$errorBG/error.text = "Server error (JSON parsing)."
			$errorBG.show()
	else:
		$errorBG/error.text = "Empty server response."
		$errorBG.show()


func submit_recovery_answers():
	# Récupérer les 3 réponses entrées
	var ans1 = $ForgotPassword/LoginSpace/Q_A1/A1/input.text
	var ans2 = $ForgotPassword/LoginSpace/Q_A2/A2/input.text
	var ans3 = $ForgotPassword/LoginSpace/Q_A3/A3/input.text
	
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_recovery_answers_response)
	
	var url = "http://localhost/blobsweeper/check_recovery_answers.php"
	var body = "username=%s&a1=%s&a2=%s&a3=%s" % [
		pending_username.uri_encode(),
		ans1.uri_encode(),
		ans2.uri_encode(),
		ans3.uri_encode()
	]
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	
	var error = http.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Erreur requête :", error)

func _on_recovery_answers_response(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	print("Réponse brute :", response_text)
	
	if response_text != "":
		var json = JSON.new()
		if json.parse(response_text) == OK:
			var data = json.get_data()
			match data["status"]:
				"success":
					print("Les réponses sont correctes !")
					updating = true
					backup_page = false
					setting_new_password = true
					$ForgotPassword.hide()
					$Backup1/LoginSpace/Nickname/input.text = pending_username
					$Backup1.show()
				"wrong_answers":
					print("Une ou plusieurs réponses sont incorrectes.")
				"not_found":
					print("Aucun compte trouvé avec ce pseudo.")
				_:
					print("Réponse inconnue :", data)
		else:
			print("Erreur parsing JSON.")
	else:
		print("Réponse vide.")
