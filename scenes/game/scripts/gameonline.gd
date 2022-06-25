extends Control

signal done_displaying

const QNAMES = ['1st', '2nd', '3rd', '4th', 'END']
const TEMP_OFF_PLAYS = ["Line Plunge", "Off Tackle", "End Run", "Draw", "Screen", "Short", "Medium", "Long", "Sideline"]  # 9 TODO
const TEMP_DEF_PLAYS = ["Standard", "Short Yardage", "Spread", "Pass Prevent Short", "Pass Prevent Long", "Blitz"]  # 6 TODO

var DISPLAYQ = []
var clock = ['1st', 900]
var score = [0, 0] # (Me, Them)
var localstance = "Defense"
var yard = 40
var firstdown = 50
var down = 1
var end = false

onready var printer = get_node("Playfield/Label")  # import from Label
onready var ball = get_node("Playfield/Field/football")

onready var action = get_node("ActionButton")
onready var actionbutton = get_node("ActionButton/ButtonTexture")
onready var actiontext = get_node("ActionButton/Text")
onready var offense_gui = get_node("Offense")
onready var defense_gui = get_node("Defense")

static func slicejoin(my_list, from, to, delimiter=""):
	var newl = []
	for i in range(from, to):
		newl.append(my_list[i])
	var news = ""
	for s in newl:
		news += delimiter + s
	return news


func addToDisplayQueue(text):
	self.DISPLAYQ.append([text, self.getAbsoluteYardage()])


func wait_for_display():
	for textelement in self.DISPLAYQ:
		self.ball.set_new_position(textelement[1])
		self.printer.delayed_display(textelement[0])
		yield(self.printer, "sleep_done")
	self.DISPLAYQ.clear()
	get_node("Score/homeScore").set_text(str(self.score[0]))
	get_node("Score/awayScore").set_text(str(self.score[1]))
	if self.end:
		get_node("GameOverButton/homeScore").set_text(str(self.score[0]))
		get_node("GameOverButton/awayScore").set_text(str(self.score[1]))
		get_node("Score/Seconds").set_text("00")
		get_node("Score/Minutes").set_text("00")
		get_node("GameOverButton").set_visible(true)
		emit_signal("done_displaying")
		return
	get_node("Score/Seconds").set_text("%02d" % (int(self.clock[1]) % 60))
	get_node("Score/Minutes").set_text(str(int(self.clock[1]/60)))
	get_node("Score/Qst").set_text(self.clock[0])
	emit_signal("done_displaying")


func setActionButton(text, call):
	self.printer.set_visible(false)
	self.offense_gui.set_visible(false)
	self.offense_gui.disable(true)
	self.defense_gui.set_visible(false)
	self.defense_gui.disable(true)
	#self.defense_gui.set_process_input(false)
	self.action.set_visible(true)
	if self.actionbutton.is_connected("pressed", self, "_activate_action"):
		self.actionbutton.disconnect("pressed", self, "_activate_action")
	self.actiontext.set_text(text)
	self.actionbutton.connect("pressed", self, "_activate_action", [call])

func _activate_action(call):
	self.action.set_visible(false)
	self.printer.set_visible(true)
	# Meth is passed as a array as required by "connect",
	# but is only given to us as a single value here for some reason
	global.send_packet(call)


func switchYardSide():
	self.yard = 100 - self.yard


func getAbsoluteYardage(customYard=self.yard, offset=true):
	if not offset:  # Don't offset the position to account for tip-based render
		customYard = customYard + 5
	if self.localstance == "Offense":
		return customYard - 5
	else:
		return 105 - customYard


func upToWait(message):
	#self.yard = message["yard"]
	#self.down = message["down"]
	self.clock = message["clock"]
	if message["offplayer"] == global.nameid:
		self.score = message["score"]
		self.localstance = "Offense"
	else:
		self.score = [message["score"][1], message["score"][0]]
		self.localstance = "Defense"
	if message["TD"]:
		if message["offplayer"] == global.nameid:
			self.setActionButton("Kickoff!", "Kickoff")
			self.ball.set_new_position(self.getAbsoluteYardage())
		else:
			# WAITING
			pass
		return
	self.DISPLAYQ.append([message["message"], message["yard"]])

	if self.localstance == "Offense":
		self.defense_gui.set_visible(false)
		self.offense_gui.set_visible(true)
		self.offense_gui.disable(false)
	elif self.localstance == "Defense":
		self.offense_gui.set_visible(false)
		self.defense_gui.set_visible(true)
		self.defense_gui.disable(false)


func set_defplay(play):
	global.send_packet(play)
	self.defense_gui.disable(true)
	self.defense_gui.set_visible(false)

func set_offplay(play):
	global.send_packet(play)
	self.offense_gui.disable(true)
	self.offense_gui.set_visible(false)


func _on_system_message():
	var packet = global._client.get_peer(1).get_packet().get_string_from_utf8()
	if packet is String and packet == "WAITING":
		# WAITING
		print("Waiting for opponent")
		return
	packet = JSON.parse(packet).result
	if packet["message"] is String and packet["message"] == "READY":
		# show updates and less go
		wait_for_display()
		return
	upToWait(packet["message"])


# Called when the node enters the scene tree for the first time.
func _ready():
	global._client.connect("data_received", self, "_on_system_message")
	# Set team icons
	var homeaway = global.get_params()
	get_node("Score/homeLogoSlot").set_child_texture(homeaway[0])
	get_node("Score/awayLogoSlot").set_child_texture(homeaway[1])
	
	_on_system_message()
