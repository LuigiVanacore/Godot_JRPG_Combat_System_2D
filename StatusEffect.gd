extends Node
class_name StatusEffect


var time_scale : float = 1.0
#duration of the effect in second
var duration_seconds : float = 0.0 : set = set_duration_seconds
#if true the effect applies once every ticking_interval
var is_ticking : bool = false
#duration between ticks in seconds
var ticking_interval : float = 1.0
#if true the effect is active and is applying. 
var is_active : bool = true : set = set_is_active
#string to reference the effect and instatiate it
var id : String = "base_effect"

#time left in seconds until the effect expires
var _time_left : float = -INF
#time left in current tick, if the effect is ticking
var _ticking_clock : float = 0.0
#if true this effect can stuck
var _can_stack : bool = false
#reference to the battler to whom the effect is applied
var _target : Battler


func _init(target : Battler, data : StatusEffectData):
	_target = target
	duration_seconds = data.duration_seconds
	
	#if the effect is ticking initialize the corresponding variables
	is_ticking = data.is_ticking
	ticking_interval = data.ticking_interval
	_ticking_clock = ticking_interval
	
func set_is_active(value : bool):
	is_active = value
	set_process(is_active)

func set_duration_seconds(value : float):
	duration_seconds = value
	_time_left = duration_seconds
	

# Status effect is node tat get into effect when added inside
# battler's statusEffectContainer node
# _start is a virtual method overrided in derived class
func _ready():
	_start() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_time_left -= delta * time_scale
	
	if is_ticking:
		var old_clock = _ticking_clock
		
		_ticking_clock = wrapf(_ticking_clock - delta * time_scale, 0.0, ticking_interval)
		
		if _ticking_clock > old_clock:
			_apply()
			
	if _time_left < 0.0:
		set_process(false) 
		
		_expire()
	
func can_stack() -> bool:
	return _can_stack
	
func get_time_left() -> float:
	return _time_left

func expire():
	_expire()
	
func _start():
	pass
	
func _apply():
	pass
	
func _expire():
	queue_free()
	
