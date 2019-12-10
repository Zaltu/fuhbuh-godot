extends Control


const STANCES = ['Offense', 'Defense', 'Kick']
const QNAMES = ['1st', '2nd', '3rd', '4th', 'END']

var clock = ['1st', 720]
# warning-ignore:unused_class_variable
var simplePriorityLow = ['+', '-']
var score = [0, 0] # (Me, Them)
var localstance = "Defense"
var yard = 40
var firstdown = 50
var down = 1
var boob = false
var TD = false
var end = false

var team = {}
var enemy = {}

var defplay = ""
var offplay = ""

var numProbTable = {}



const FUMBLE_CHANCE_FIELD = "FUMBLE_CHANCE"
# Ugly wrappers cause GDScript doesn't have proper lambda equivalents
func _penaltytrue(roll):
	penalty(roll, true)
func _penaltyfalse(roll):
	penalty(roll, false)
# warning-ignore:unused_argument
func _QT(dummy):
	customKey("QT", "QT")
# warning-ignore:unused_argument
func _breakaway(dummy):
	customKey("Breakaway", "Breakaway")

onready var PLAYMAP = {
	'+': funcref(self, "softs"),
	'-': funcref(self, "softs"),
	':': funcref(self, "hard"),
	'OFF': funcref(self, "_penaltyfalse"),
	'DEF': funcref(self, "_penaltytrue"),
	'PI': funcref(self, "_penaltytrue"),
	'INC': funcref(self, "incomplete"),
	'QT': funcref(self, "_QT"),
	'INT': funcref(self, "interception"),
	'F': funcref(self, "fumble"),
	'BK': funcref(self, "fumble"),
	'B': funcref(self, "_breakaway")
}

onready var printer = get_node("Playfield/Label")  # import from Label
onready var ball = get_node("Playfield/Field/football")

onready var action = get_node("ActionButton")
onready var actionbutton = get_node("ActionButton/ButtonTexture")
onready var actiontext = get_node("ActionButton/Text")

static func slicejoin(my_list, from, to, delimiter=""):
	var newl = []
	for i in range(from, to):
		newl.append(my_list[i])
	var news = ""
	for s in newl:
		news += delimiter + s
	return news


static func randint(limit):
	randomize()
	return randi()%limit + 1


func setActionButton(text, meth):
	self.printer.set_visible(false)
	self.action.set_visible(true)
	self.actiontext.set_text(text)
	self.actionbutton.connect("pressed", self, "_activate_action", [meth])

func _activate_action(meth):
	self.action.set_visible(false)
	self.printer.set_visible(true)
	# Meth is passed as a array as required by "connect",
	# but is only given to us as a single value here for some reason
	call(meth)


func weightedRoll(stance, perc):
	for sheetRoll in self.numProbTable[stance]:
		if self.numProbTable[stance][numProbTable[stance].find(sheetRoll)] >= perc:
			#print(sheetRoll, numProbTable[stance].index(sheetRoll))
			return numProbTable[stance].find(sheetRoll)


func switchYardSide():
	self.yard = 100 - self.yard


func getAbsoluteYardage():
	if self.localstance == "Offense":
		return self.yard
	else:
		return 100 - self.yard


func toggleStance():
	if self.localstance == "Offense" or self.localstance == "Kick":
		self.localstance = "Defense"
	else:
		self.localstance = "Offense"
	self.switchYardSide()
	self.down = 1
	self.firstdown = self.yard+10
	# View
	if self.localstance == "Offense":
		#get_node("Defense").set_visible(false)
		get_node("Offense").set_visible(true)
	elif self.localstance == "Defense":
		get_node("Offense").set_visible(false)
		#get_node("Defense").set_visible(true)


func turnOver():
	self.printer.setText("Switched sides!")  # Only for CMD mode
	self.down = 1
	self.toggleStance()
	self.printer.setText("Offense is now on the %s yard line." % self.yard)  # Only for CMD mode


func fclock(star):
	self.clock[1] -= 30 if not star else 10
	if self.clock[1] <= 0:
		self.printer.setText("Changing quarters")  # Only for CMD mode
		self.changeQuarters()
	self.boob = false


func changeQuarters():
	self.clock[0] = self.QNAMES[self.QNAMES.find(self.clock[0])+1]
	if self.clock[0] == 'END':
		self.gameOver()
	self.clock[1] = 720
	if self.clock[0] == self.QNAMES[2]:
		self.printer.setText("Halftime!")
		if self.startingstance == "Offense" && self.localstance == "Offense":
			self.toggleStance()
		self.kickoff()


func gameOver():
	self.printer.setText("Game over")  # Only for CMD mode
	self.printer.setText("Final score: %s to %s" % [self.score[0], self.score[1]])  # Only for CMD mode
	self.end = true


func handleFluff():
	self.ball.set_new_position(self.getAbsoluteYardage())
	if self.firstdown >= 100:
		self.printer.setText("%s and goal on the %s" % [self.QNAMES[self.down-1], self.yard])
	else:
		self.printer.setText("%s and %s on the %s" % [self.QNAMES[self.down-1], self.firstdown-self.yard, self.yard])
	#self.printer.setText("Game time: %s : %s" % self.clock) update clock values


func handleFluffCall():
	self.printer.setText("Offense callout: %s -> %s" % [self.offplay, self.rolls['Offense']])
	self.printer.setText("Defense callout: %s -> %s" % [self.defplay, self.rolls['Defense']])

	
func handleTD():
	if self.yard >= 100:
		self.printer.setText("TOUCHDOWN!")  # Only for CMD mode
		self.handleScore()
		self.TD = true


func handleScore():
	if self.localstance == "Offense":
		self.score[0] += 7
	else:
		self.score[1] += 7


func handleDowns():
	if self.yard >= 100:  # TD
		return
	if self.yard >= self.firstdown:
		self.printer.setText("First Down!")  # Only for CMD mode
		self.down = 1
		self.firstdown = self.yard + 10
	else:
		self.down += 1
	if self.down == 5:
		self.turnOver()


func fullTurn():
	self.handleFluff()  # Only for CMD mode
	var isoffenseplay = self.offplay if self.localstance == "Defense" else null
	self.roll(self.callout, isoffenseplay)
	self.handleFluffCall()  # Only for CMD mode
	self.processPlay()
	self.handleDowns()
	self.handleTD()
	self.fclock(self.boob)


func kickoff():
	self.TD = false
	self.yard = 40
	self.customKey('Kickoff', 'Kickoff')
	yield(self.printer, "sleep_done")
	self.ball.set_new_position(self.getAbsoluteYardage())
	self.printer.setText("Kicked to the %s yard line!" % self.yard)
	yield(self.printer, "sleep_done")
	self.toggleStance()
	self.customKey('Kickoff Return', 'Kickoff Return')
	yield(self.printer, "sleep_done")
	self.ball.set_new_position(self.getAbsoluteYardage())
	self.printer.setText("Returned to the %s yard line!" % self.yard)
	yield(self.printer, "sleep_done")
	self.firstdown = self.yard + 10
	self.down = 1
	self.handleFluff()


func punt():
	self.customKey('Punt', 'Punt')
	self.toggleStance()
	self.customKey('Punt Return', 'Punt Return')
	self.firstdown = self.yard + 10
	self.down = 1
	self.handleFluff()







func roll(callout, offensePlay=null): # eg roll('Line Plunge')
	var stats = self.team[self.localstance]
	var numRoll = randint(100)
	#print(stats)
	#print(callout)
	#print(offensePlay)
	if offensePlay == null:
		self.rolls[self.localstance] = stats[callout][self.weightedRoll(self.localstance, numRoll)]
	else:
		self.rolls[self.localstance] = stats[callout][offensePlay][self.weightedRoll(self.localstance, numRoll)]

func processPlay():
	var finalStance = determinePriority()
	if finalStance:
		var fplay = self.PLAYMAP[_rolltype(self.rolls[finalStance])]
		fplay.call_func(self.rolls[finalStance])#call resolve
		self.boob = self.rolls[finalStance].split(" ")[-1] == "*" or self.boob
	else:
		soft()


func determinePriority():
	var defType = _rolltype(self.rolls['Defense'])
	var attType = _rolltype(self.rolls['Offense'])
	if not (defType in self.simplePriorityLow):
		return 'Defense'
	elif not (attType in self.simplePriorityLow):
		return 'Offense'
	else:
		return null


func _rolltype(rollRes, position=0):
	return rollRes.split(" ")[position]


"""
These represent all the different play types that can occur and their resolves.
"""
func soft():
	var mod1 = slicejoin(self.rolls["Defense"].split(" "), 0, 2)
	var mod2 = slicejoin(self.rolls["Offense"].split(" "), 0, 2)
	if mod2 == "+TD" or mod1 == "+TD":
		self.yard = 100
		self.TD = true
	else:
		self.yard += int(mod1)+int(mod2)
	if _rolltype(self.rolls['Offense'], -1) == "*" or _rolltype(self.rolls['Defense'], -1) == "*":
		self.boob = true


func softs(singlePlay):
	var mod = slicejoin(singlePlay.split(" "), 0, 2)
	if mod == "+TD":
		self.yard = 100
	else:
		self.yard += int(mod)
	if singlePlay[-1] == "*":
		self.boob = true


func hard(result):
	var mod = result.split(" ")[1]
	if mod == "+TD":
		self.yard = 100
		return
	self.yard += int(mod)


# warning-ignore:unused_argument
func incomplete(result):
	# Incomplete is always considered oob
	self.boob = true


func interception(result):
	self.yard += result.split(" ")[1]
	self.toggleStance()


func fumble(result):
	var fum = 0  # Must get overwritten
	if self.localstance == "Offense":
		fum = self.team[FUMBLE_CHANCE_FIELD]
	else:
		fum = self.enemy[FUMBLE_CHANCE_FIELD]
	self.yard += int(result.split(" ")[1])
	var roll = randint(100)
	if roll <= fum:
		self.printer.setText("Fumble recovered!")
		return
	self.printer.setText("Fumble lost!")
	self.toggleStance()
	self.down = 1


func penalty(result, gain):
	if not gain:
		self.yard -= int(result.split(" ")[1])
	else:
		self.yard += int(result.split(" ")[1])
	# No down change on penalties
	self.down -= 1
	# Penalties are always considered oob
	self.boob = true


func customKey(ctype, key):
	self.printer.setText(ctype + "!")
	yield(self.printer, "sleep_done")
	var line = {}  # Must get overwritten
	if self.localstance == 'Offense':
		line = self.team[key]
	else:
		line = self.enemy[key]
	#print(line)
	var newRoll = self.weightedRoll('Offense', randint(100))
	#print(newRoll)
	var newPlay = line[newRoll]
	print(ctype + " roll: %s" % newPlay)
	var newType = _rolltype(newPlay)
	print("new roll type: %s" % newType)
	var fplay = PLAYMAP[newType]
	fplay.call_func(newPlay)


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://assets/data/dice.json", file.READ)
	var dicetext = file.get_as_text()
	file.close()
	file.open("res://assets/data/teams/raiders.json", file.READ)
	var raiderstext = file.get_as_text()
	file.close()
	file.open("res://assets/data/teams/chargers.json", file.READ)
	var chargerstext = file.get_as_text()
	file.close()
	self.numProbTable = JSON.parse(dicetext).result
	self.team = JSON.parse(raiderstext).result
	self.enemy = JSON.parse(chargerstext).result
	
	# Test
	self.offplay = "End Run"
	self.setActionButton("Kickoff!", "kickoff")
	#self.kickoff()
	self.ball.set_new_position(self.getAbsoluteYardage())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
