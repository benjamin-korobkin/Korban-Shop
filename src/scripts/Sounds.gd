extends Node2D


onready var soundsNode

#resource is taken from gameResources, stream player is the name of the stream player you want to add to and play

# both case sensitive
func play_sound(resource : String,streamPlayer : String):
	soundsNode.get_node(streamPlayer).stream = GameResources.soundsDict[resource]
	soundsNode.get_node(streamPlayer).play()
