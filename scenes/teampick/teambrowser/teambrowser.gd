extends Control


# Declare member variables here. Examples:
var teamicons = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get all available teams
	var availableTeams = File.new()
	availableTeams.open("res://assets/data/teams.json", availableTeams.READ)
	var teams = JSON.parse(availableTeams.get_as_text()).result
	availableTeams.close()
	# For each team, generate a teamicon in the scrollbar.
	var teamiconscene = load("res://scenes/teampick/teamicon/teamicon.tscn")
	for team in teams:
		self.teamicons[team] = teamiconscene.instance()
		self.teamicons[team].init(team)
		add_child(self.teamicons[team])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
