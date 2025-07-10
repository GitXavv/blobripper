extends Control

@onready var tree = $ScoresTree

var frequency_translations = {
	"Slow": "Lent",
	"Average": "Normal",
	"Fast": "Rapide",
	"Very fast": "Très rapide",
	"Crazy": "Démentiel",
	"Unknown": "Inconnu"
}

# Column titles. To be translated depending on the selected language
var col0: String
var col1: String
var col2: String
var col3: String
var col4: String
var col5: String

func _ready():
	if General.autolang == "en":
		$MenuText_PlaceHolder/Title.text = "lEADERBOARD"
		$TestPhase.text = "Due to the game still being in a test phase, the leaderboard may be reset often."
	elif General.autolang == "fr":
		$MenuText_PlaceHolder/Title.text = "CLASSEMENT"
		$TestPhase.text = "Puisque le jeu est encore en phase de test, le classement risque de souvent être réinitialisé."
	col_titles()
	load_scores()

func load_scores():
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_scores_received)

	var url = "http://localhost/blobsweeper/get_scores.php"
	var error = http.request(url)
	if error != OK:
		server_error()
		if General.autolang == "en":
			$ScoresTree/details.text = "Error details: " + str(error)
		elif General.autolang == "fr":
			$ScoresTree/details.text = "Détails sur l'erreur: " + str(error)
		print("Erreur requête :", error)

func _on_scores_received(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()

	if response_text != "":
		var json = JSON.new()
		if json.parse(response_text) == OK:
			var data = json.get_data()
			if data["status"] == "success":
				if data["scores"].size() == 0:
					if General.autolang == "en":
						if Connection.username != "":
							$ScoresTree/error.text = "It looks like no one has joined the online scene yet. Beat your high score and become the very first to appear in the leaderboard."
						else:
							$ScoresTree/error.text = "It looks like no one has joined the online scene yet. Log in to an account and be the very first to appear in the leaderboard by beating your high score."
					elif General.autolang == "fr":
						if Connection.username != "":
							$ScoresTree/error.text = "On dirait que personne n'a encore osé rejoindre la scène publique du jeu. Bat ton meilleur score et devient le tout premier à figurer sur le tableau d'honneur."
						else:
							$ScoresTree/error.text = "On dirait que personne n'a encore osé rejoindre la scène publique du jeu. Connecte-toi à ton compte et devient le tout premier à figurer sur le tableau d'honneur avec un nouveau meilleur score."
				else:
					populate_tree(data["scores"])
			else:
				server_error()
				if General.autolang == "en":
					$ScoresTree/details.text = "Error details: " + data["message"]
				elif General.autolang == "fr":
					$ScoresTree/details.text = "Détails sur l'erreur: " + data["message"]
				print("Erreur serveur :", data["message"])
		else:
			server_error()
			if General.autolang == "en":
				$ScoresTree/details.text = "Error details: JSON parsing error"
			elif General.autolang == "fr":
				$ScoresTree/details.text = "Détails sur l'erreur: Erreur parsing JSON"
			print("Erreur parsing JSON")
	else:
		server_error()
		if General.autolang == "en":
			$ScoresTree/details.text = "Error details: Empty return"
		elif General.autolang == "fr":
			$ScoresTree/details.text = "Détails sur l'erreur: Réponse vide"
		print("Réponse vide")

func server_error(): # Display an eroor message in game
	if General.autolang == "en":
		$ScoresTree/error.text = "An error server-side has occured. It is not your fault, it is mine.."
	elif General.autolang == "fr":
		$ScoresTree/error.text = "Une erreur côté serveur est survenue. Ce n'est pas de ta faute, c'est la mienne.."

func col_titles():
	if General.autolang == "en":
		col0 = "Rank"
		col1 = "Nickname"
		col2 = "Score"
		col3 = "Frequency"
		col4 = "Mods"
		col5 = "Date"
	elif General.autolang == "fr":
		col0 = "Rang"
		col1 = "Pseudo"
		col2 = "Score"
		col3 = "Fréquence"
		col4 = "Mods"
		col5 = "Date"

func populate_tree(scores):
	tree.clear()

	# Crée les colonnes
	tree.create_item()
	tree.set_column_titles_visible(true)
	tree.set_column_title(0, col0)
	tree.set_column_title(1, col1)
	tree.set_column_title(2, col2)
	tree.set_column_title(3, col3)
	tree.set_column_title(4, col4)
	tree.set_column_title(5, col5)

	# Remplit les lignes
	for i in range(scores.size()):
		var rank = i + 1
		var row = scores[i]
		var freq = row["frequency"]

		if General.autolang == "fr":
			freq = frequency_translations.get(freq, freq)

		var item = tree.create_item()
		item.set_text(0, "            "+str(rank))
		item.set_text(1, "            "+row["user"])
		item.set_text(2, "            "+str(row["score"]))
		item.set_text(3, "            "+freq)
		item.set_text(4, "            "+row["mods"])
		item.set_text(5, "            "+row["date"])
		
		# To highlight the logged in player:
		if row["user"] == Connection.username:
			for col in range(6):
				item.set_custom_bg_color(col, Color(0.576, 0.133, 0.443, 0.823)) # Pink
			if General.autolang == "en":
				$MenuText_PlaceHolder/Info.text = "Your rank is highlighted in pink"
			elif General.autolang == "fr":
				$MenuText_PlaceHolder/Info.text = "Ta position est surlignée en rose"
		elif $MenuText_PlaceHolder/Info.text == "":
			if Connection.username != "":
				if General.autolang == "en":
					$MenuText_PlaceHolder/Info.text = "It looks like you are not in this glorious leaderboard yet"
				elif General.autolang == "fr":
					$MenuText_PlaceHolder/Info.text = "On dirait que tu n'es pas encore dans le tableau d'honneur"
			else:
				if General.autolang == "en":
					$MenuText_PlaceHolder/Info.text = "Log in to have a chance to appear in the leaderboard"
				elif General.autolang == "fr":
					$MenuText_PlaceHolder/Info.text = "Connecte-toi pour avoir une chance d'apparaître dans le classement"
