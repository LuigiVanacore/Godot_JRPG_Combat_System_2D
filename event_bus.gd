extends Node



class Event:
	var name : String
	signal signal_to_emit

var event_dictionary : Dictionary

func _ready():
	event_dictionary = {}

func publish(event_id : String, event_data):
	if event_dictionary.has(event_id):
		var currentObservers=event_dictionary[event_id].observers
		for i in currentObservers:
			var anObserver =  currentObservers[i]
			if anObserver.object.has_method(anObserver.action.get_method()):
				if !event_data:
					anObserver.object.call(anObserver.action.get_method())
				else:
					anObserver.object.call(anObserver.action.get_method(), event_data)

func subriscribe(observer,event_id,action):
	if not event_dictionary.has(event_id):
		event_dictionary[event_id]={
			"observers":{}
		}
	var currentObservers=event_dictionary[event_id].observers
	currentObservers[observer.get_instance_id()]={
		"object":observer,
		"action":action
	}



func remove_subscription(observer, event_id):
	if event_dictionary.has(event_id):
		var currentObservers=event_dictionary[event_id].observers
		if currentObservers.has(observer.get_instance_id()):
			currentObservers.erase(observer.get_instance_id())
