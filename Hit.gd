extends RefCounted
class_name Hit


var _damage : float = 0
var _hit_chance : float

func _init(damage : int, hit_chance : float = 100.0):
	_damage = damage
	_hit_chance = hit_chance
	
	
func does_hit() -> bool:
	return randf() * 100.0 < _hit_chance
