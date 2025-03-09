extends HBoxContainer

var player_joined = [false,false,false,false]

func _process(delta: float):
	for player in PlayerManager.player_data:
		player_joined[player] = true
	if player_joined[0]:
		$Player1/Label.add_theme_color_override("font_color", Color("green"))
	if player_joined[1]:
		$Player2/Label.add_theme_color_override("font_color", Color("green"))
	if player_joined[2]:
		$Player3/Label.add_theme_color_override("font_color", Color("green"))
	if player_joined[3]:
		$Player4/Label.add_theme_color_override("font_color", Color("green"))
