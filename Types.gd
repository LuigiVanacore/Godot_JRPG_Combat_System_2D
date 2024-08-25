extends RefCounted
class_name Types

enum ELEMENTS { NONE, CODE, DESIGN, ART, BUG }


const WEAKNESS_MAPPING = {
	ELEMENTS.NONE: -1,
	ELEMENTS.CODE: ELEMENTS.ART,
	ELEMENTS.ART: ELEMENTS.DESIGN,
	ELEMENTS.DESIGN: ELEMENTS.CODE,
	ELEMENTS.BUG: -1,
}

#array of elements against which the battler is weak
@export var weaknesses : Array = []
#battler's elemental affinity. give bonuses with related actions
@export var affinity : int = Types.ELEMENTS.NONE
