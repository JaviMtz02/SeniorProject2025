extends TextureButton

@export var glow_material: ShaderMaterial
@export var normal_material: ShaderMaterial

signal tile_clicked(tile)

func _ready() -> void:
	self.material = normal_material
	connect("pressed", Callable(self, "_on_tile_pressed"))
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_tile_pressed() -> void:
	self.material = normal_material
	glow_material.set_shader_parameter("glow_strength", 0.0)
	tile_clicked.emit(self)

func _on_mouse_entered() -> void:
	self.material = glow_material
	glow_material.set_shader_parameter("glow_strength", 0.2)

func _on_mouse_exited() -> void:
	self.material = normal_material
	glow_material.set_shader_parameter("glow_strength", 0.0)
