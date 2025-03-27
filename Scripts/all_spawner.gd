extends MultiplayerSpawner

func _ready() -> void:
	for node in get_children():
		# Spawnable class is Marker2D with PackedScene attached
		if node is Spawnable:
			if node.object_to_spawn:
				# Get the scene path for the Spawner to sync that type of scene
				var scene_path = node.object_to_spawn.resource_path
				if scene_path:
					add_spawnable_scene(scene_path)
				# Only the server needs to spawn stuff in
				if is_multiplayer_authority():
					# Instantiate the object
					var object = node.object_to_spawn.instantiate()
					object.global_position = node.global_position
					add_child(object, true)
				# We don't need the Marker2D anymore
				node.queue_free()
			else:
				print("Error: [" + name + "] Spawnable has no assigned PackedScene")
