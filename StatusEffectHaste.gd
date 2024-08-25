extends StatusEffect
class_name StatusEffectHaste


var speed_bonus : int = 0

var _stat_modifier_id : int = -1

func _init(target : Battler, data : StatusEffectData):
	super._init(target, data)
	id = "haste"
	speed_bonus = data.effect_power
	
	
func _start():
	#initialize the effect by adding a stat modifier to the target battler
	_stat_modifier_id = _target.stats._add_modifier(BattlerStats.UPGRADABLE_STATS.SPEED, speed_bonus)
	
func _expire():
	#remove the stat modifier when the effect expires
	_target.stats.remove_modifier(BattlerStats.UPGRADABLE_STATS.SPEED, _stat_modifier_id)
	queue_free()
