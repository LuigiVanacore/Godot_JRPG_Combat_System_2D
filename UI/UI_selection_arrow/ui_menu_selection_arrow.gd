extends Node2D


var _tween : Tween






#The UI_action_list can use this function to move the arrow
func move_to(target : Vector2):
	#If it's already moving, we stop and restart the tween
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "position", target, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.play()
