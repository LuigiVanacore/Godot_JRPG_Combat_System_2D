extends Node
class_name ActiveTurnQueue


#emitted when a player-controlled battler finished playing a turn
signal player_turn_finished

@export var time_out_per_turn : float = 0.7
#if true the player is currently playing a turn
var _is_player_playing : bool = false
#stack of player-controlled battlers that have to take turns
var _queue_player : Array[Battler] = []




#allows pausing the turn queue when needed
@export var is_active : bool = false: set = set_is_active
#multiplier for the global pace of battle, to slow down time while the player
#is making decisions. This is meant for accessibility and to control
#difficulty
var time_scale : float = 1.0 : set = set_time_scale

@onready var battlers : Array : get = get_battlers
var current_turn_index : int = 0


func get_battlers() -> Array:
	return get_children()

func set_is_active(value : bool ) -> void:
	is_active = value
	for battler in battlers:
		battler.is_active = is_active
		
func set_time_scale(value : float):
	time_scale = value
	for battler in battlers:
		battler.time_scale = time_scale

func get_opponents() -> Array:
	var opponents : Array
	for battler in battlers:
		if not battler.is_party_member:
			opponents.append(battler)
	return opponents

func get_party() -> Array:
	var party : Array
	for battler in battlers:
		if battler.is_party_member:
			party.append(battler)
	return party
	
# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.subriscribe(self, "start_battle", start_turns)
	player_turn_finished.connect(_on_player_turn_finished)
	battlers = sort_battlers(battlers)
	while true:
		for battler in battlers:
			await play_next_turn(battler)
			await get_tree().create_timer(time_out_per_turn).timeout


func play_next_turn(battler):
	await battler.take_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_Battler_ready_to_act(battler : Battler):
	#if the battler is controlled by the player but another 
	#player-controlled battler is in the middle of a turn
	#we add this one to the queue
	if battler.is_player_controlled() and _is_player_playing:
		_queue_player.append(battler)
	else:
		_play_turn()

func start_turns():
	is_active = true

func play_turns():
	while is_active:
		_play_turn()
		_next_turn()

		
	
func _play_turn():
	#var action_data : ActionData
	#var targets : Array[Battler] = []
	#
	#battler.stats.energy += 1
	#battler.is_selected = true
	#
	#var potential_targets := []
	#var opponents : Array = _opponents if battler.is_party_member else _party_members
	#for opponent in opponents:
		#if opponent.is_selectable:
			#potential_targets.append(opponent)
		#
	#if battler.is_player_controlled():
		#battler.is_selected = true
		#set_time_scale(0.05)
		#_is_player_playing = true
		#
		#var is_selection_complete := false
		#while not is_selection_complete:
			#action_data = await _player_select_action_async(battler)
			#if action_data.is_targeting_self:
				#targets = [battler]
			#else: 
				#targets = await _player_select_targets_async(action_data, potential_targets)
			#is_selection_complete = action_data != null && targets != []
		#set_time_scale(1.0)
		#battler.is_selected = false
	#else:
		#action_data = battler.actions[0].get_action_data()
		#targets = [potential_targets[0]]
	#
	#var action = AttackAction.new(action_data, battler, targets)
	#battler.act(action)
	#await battler.action_finished
	#
	#if battler.is_player_controlled():
		#player_turn_finished.emit()
	await battlers[current_turn_index].take_turn()

func _player_select_action_async(battler : Battler) -> ActionData:
	await battler.current_action_selected
	return battler.current_action.get_action_data()
	
func _player_select_targets_async(_action : ActionData, opponents : Array[Battler]) -> Array[Battler]:
	#var targets = await battler.targets_selected
	return opponents
	
func _on_player_turn_finished():
	if _queue_player.is_empty():
		_is_player_playing = false
	else:
		_play_turn()

func _next_turn():
	current_turn_index += 1
	if current_turn_index >= get_child_count():
		current_turn_index = 0
		

func sort_battlers_by_speed(battler_1 : Battler, battler_2 : Battler):
	if battler_1.stats.base_speed > battler_2.stats.base_speed:
		return true
	return  false

func sort_battlers(array : Array) -> Array:
	array.sort_custom(sort_battlers_by_speed)
	for node in get_children():
		remove_child(node)

	for node in array:
		add_child(node)
	return array
