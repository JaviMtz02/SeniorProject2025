extends Node2D


@export var excluded_scenes: Array[String] = []
@export var included_scenes: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	$Music.play()
	get_tree().connect("node_added",Callable(self, "_on_node_added"))

func _on_node_added(node) -> void:
	if node == get_tree().current_scene:
		_check_scene_name(node.name)

func _check_scene_name(scene_name: String) -> void:
	for scene in excluded_scenes:
		if scene_name == scene:
			if $Music.playing:
				$Music.stop()
	for scene in included_scenes:
		if scene_name == scene:
			if not $Music.playing:
				$Music.play()
	
