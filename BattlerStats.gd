extends Resource
class_name BattlerStats


enum UPGRADABLE_STATS { MAX_HEALTH, MAX_ENERGY, ATTACK, DEFENSE, SPEED, HIT_CHANCE, EVASION }
#emitted when a character have no healt 
signal health_depleted
#emitted every time the value health changes
signal health_changed(old_value, new_value)
#emitted every time the value energy changes
signal energy_changed(old_value, new_value)

@export var max_health : float = 100.0
@export var max_energy : int = 6

@export var base_attack : float = 10.0 : set = set_base_attack
@export var base_defense : float = 10.0 : set = set_base_defense
@export var base_speed : float = 70.0 : set = set_base_speed
@export var base_hit_chance : float = 100.0 : set = set_base_hit_chance
@export var base_evasion : float = 0.0 : set = set_base_evasion

var health : float = max_health : set = set_health
var energy : int = 0 : set = set_energy

var attack : float = base_attack
var defense : float = base_defense
var speed : float = base_speed
var hit_chance : float = base_hit_chance
var evasion : float = base_evasion

#the property below stores a list of modifiers for each property listed in
#UPGRADABLE_STATS
#the value of modiifier can be any floating point value, positive or negative
var _modifiers := {}

func reinitialize():
	set_health(max_health)
	
func _init():
	for stat in UPGRADABLE_STATS:
		#for each stat, we create an empty dictionary
		#each upgrade will be a unique key-value pair
		_modifiers[stat] = {
			value = {},
			rate = {}
		}
		
		
# Calculates the final value of a single stat, its based value with all modifiers applied.
func _recalculate_and_update(stat : UPGRADABLE_STATS):
	#get string from enum
	var stat_name : String = UPGRADABLE_STATS.keys()[stat]
	var stat_name_lower = stat_name.to_lower()
	var value : float = get("base_" + stat_name_lower)
	var modifiers_multiplier : Array = _modifiers[stat_name]["rate"].values()
	var multiplier : float = 1.0
	for modifier in modifiers_multiplier:
		multiplier += modifier
	
	if not is_equal_approx(multiplier, 1.0):
		value *= multiplier
		
	var modifiers_value : Array = _modifiers[stat_name]["value"].values()
	for modifier in modifiers_value:
		value += modifier
		
	#ensure value cannot be negative
	value = round(max(value, 0.0))
	
	set(stat_name, value)
	
func _add_modifier(stat : UPGRADABLE_STATS, value : float, rate : float = 0.0) -> int:
	var id : int = -1
	
	if not is_equal_approx(value, 0.0):
		id = _generate_unique_id(stat, true)
		_modifiers[stat]["value"][id] = value
	if not is_equal_approx(rate, 0.0):
		id = _generate_unique_id(stat, false)
		_modifiers[stat]["rate"][id] = rate
	
	_recalculate_and_update(stat)
	return id
	
func remove_modifier(stat : UPGRADABLE_STATS, id : int):
	_modifiers[stat].erase(id)
	_recalculate_and_update(stat)
	
func _generate_unique_id(stat : UPGRADABLE_STATS, is_value_modifier : bool) -> int:
	var type := "value" if is_value_modifier else "rate"
	var keys : Array = _modifiers[stat][type].keys()
	
	if keys.is_empty():
		return 0
	else:
		return keys.back() + 1
	
func set_health(value : float):
	var health_previous : float = health
	health = clamp(value, 0.0, max_health)
	health_changed.emit(health_previous, health)
	if is_equal_approx(health, 0.0):
		health_depleted.emit()
		
func set_energy(value : int):
	var energy_previous : int = energy
	energy = int(clamp(value, 0.0, max_energy))
	energy_changed.emit(energy_previous, energy)
	
func set_base_attack(value : float):
	base_attack = value
	_recalculate_and_update(UPGRADABLE_STATS.ATTACK)
	
func set_base_defense(value : float):
	base_defense = value
	_recalculate_and_update(UPGRADABLE_STATS.DEFENSE)
	
func set_base_speed(value : float):
	base_speed = value
	_recalculate_and_update(UPGRADABLE_STATS.SPEED)
	
func set_base_hit_chance(value : float):
	base_defense = value
	_recalculate_and_update(UPGRADABLE_STATS.HIT_CHANCE)
	
func set_base_evasion(value : float):
	base_evasion = value
	_recalculate_and_update(UPGRADABLE_STATS.EVASION)
	
	
func add_value_modifier(stat: UPGRADABLE_STATS , value : float):
	_add_modifier(stat, value, 0.0)
	
func add_rate_modifier(stat : UPGRADABLE_STATS, rate : float):
	_add_modifier(stat, 0.0, rate)
	
