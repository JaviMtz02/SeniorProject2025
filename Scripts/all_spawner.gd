extends MultiplayerSpawner

## 1.0 is 100%
@export var chance_to_spawn: float = 1.0

func _ready() -> void:
	MultiplayerManager.start_spawning.connect(start_spawning)
	for node in get_children():
		if node is Spawnable:
			# Get the scene path for the Spawner to sync that type of scene
			var scene_path = node.object_to_spawn.resource_path
			# Remove nodes from clients as not to interfere with server spawning stuff in
			if scene_path:	
				add_spawnable_scene(scene_path)
			if not is_multiplayer_authority():
				node.queue_free()

func start_spawning():
	for node in get_children():
		# Spawnable class is Marker2D with PackedScene attached
		if node is Spawnable:
			if node.object_to_spawn:
				# Add chance
				if chance_to_spawn >= randf():
					# Only the server has to spawn stuff in
					var object = node.object_to_spawn.instantiate()
					object.position = node.position
					add_child(object, true)
				# We don't need the Marker2D anymore
				node.queue_free()
			else:
				print("Error: [" + name + "] Spawnable has no assigned PackedScene")
