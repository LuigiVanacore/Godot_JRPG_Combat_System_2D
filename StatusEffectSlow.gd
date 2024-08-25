extends StatusEffect
class_name StatusEffectSlow


var speed_reduction : float = 0.0 : set = set_speed_rate

var _stat_modifier_id : int = -1


func _init(target : Battler, data : StatusEffectData):
	super._init(target, data)
	id = "slow"
	speed_reduction = data.effect_rate
	
func _start():
	_stat_modifier_id = _target.add_modifier(BattlerStats.UPGRADABLE_STATS.SPEED, -1.0 * speed_reduction * _target.stats.speed)


func _expire():
	_target.stats.remove_modifier(BattlerStats.UPGRADABLE_STATS.SPEED, _stat_modifier_id)
	queue_free()
	
func set_speed_rate(value : float):
	speed_reduction = clamp(value, 0.01, 0.99)
