extends Node

# !!!!!!!!!!!!!
# Expected packet structure is:
# {
#	 "user_name":<id>,
#	 "message": <callout_str>
# }

signal connection_confirmed
signal both_players_ready

const SERVERIP = "ws://127.0.0.1:5000"
const PORT = 5000

const connectionpacket = {"data":"User Connected"}

var nameid = "DEFAULT"
var teams = []


var _autoload_params = null


# Our WebSocketClient instance
var _client = WebSocketClient.new()

func _ready():
	if OS.has_environment("USERNAME"):
		nameid = OS.get_environment("USERNAME")
	
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_server_validation")


func connect_to_server():
	# Initiate connection to the given URL.
	var err = _client.connect_to_url(SERVERIP)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(_proto = ""):
	# This is called on connection
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	_client.get_peer(1).put_packet(JSON.print(connectionpacket).to_utf8())

func _on_server_validation():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	if _client.get_peer(1).get_packet().get_string_from_utf8() == "SERVER VALIDATION":
		print("Connection confirmed")
		_client.disconnect("data_received", self, "_on_server_validation")
		emit_signal("connection_confirmed")
		_client.connect("data_received", self, "_pending_teams_packet")

func _pending_teams_packet():
	# Receiver function for the original game packet, the teams.
	var packet = _client.get_peer(1).get_packet().get_string_from_utf8()
	packet = JSON.parse(packet).result
	if packet["message"] is String and packet["message"] == "WAITING":
		print("Waiting for opponent")
		return
	print("Teams received")
	_client.disconnect("data_received", self, "_pending_teams_packet")
	emit_signal("both_players_ready", packet["message"])

func send_packet(packet):
	_client.get_peer(1).put_packet(JSON.print(
		{
			"user_name": nameid,
			"message": packet
		}).to_utf8())


func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()

###
# For Single-player
###
func set_params(params):
	_autoload_params = params

func get_params():
	var params = _autoload_params
	_autoload_params = null
	return params
