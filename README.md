# Blobripper
Here you are witnessing the birth of a video game testing your reactivity, precision and control.

# Current state of the project:
Gameplay already okay. Mods all okay and functional. Online leaderboard almost all set. Pause menu 100% functinoal, lack of music. Some sound effects already added but the game needs more. The main menu is being built: a tab panel has already been made and is 100% functional.

# Online Leaderboard
The game will have an online leaderboard feature. Players will be able to create an account and when they are logged in, their new high score will be automatically saved in a database hosted in a free distant server for now (I do not have the equipment and resources needed to host one myself)
blobsweeper_http_requests.rar contains the PHP files for each HTTP request needed. At the current state of the project, everything is done locally. A local server is needed in order for the online features to work. wampserver3.3.0_x64 is the one I used for tests. The folder in the Archive file has to be placed in ...\wamp64\www.
The online leaderboard is about 80% done. Only things that are left to do are: translations in the Account creation scene in Godot, some adjustements on submitting scores (make the game check if the user exists in the database before submitting the score) and a replication of the score submission from the time mode to sv_mode. There may be some more adjustments to do that I can't think about yet.
