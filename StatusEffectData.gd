extends RefCounted
class_name StatusEffectData

#id for the effect type
@export var effect : String = ""
#duration of the effect in seconds
@export var duration_seconds : float = 20.0
#modifier amout that the effect applies or removes to a character stat
@export var effect_rate : float = 0.5

#if true the effect applies once every ticking_interval
@export var is_ticking = false
#duration between ticks in seconds
@export var ticking_interval : float = 4.0
#damage inflicted by the effect every tick
@export var ticking_damage : int = 3

func calculate_total_damage() -> int:
	var damage : int = 0
	if is_ticking:
		damage += int(duration_seconds / ticking_interval * ticking_damage)
	return damage
