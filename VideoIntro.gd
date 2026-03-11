extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _ready() -> void:
	# 1. Nos aseguramos de que la pantalla negra sea invisible al arrancar
	$PantallaNegra.modulate.a = 0.0
	
	# 2. Le damos Play al video
	$VideoStreamPlayer.play()
	
	# 3. Pausamos el script hasta que el video termine por sí solo
	await $VideoStreamPlayer.finished
	
	# 4. Hacemos el fundido a negro suave
	var tween_fade = create_tween()
	tween_fade.tween_property($PantallaNegra, "modulate:a", 1.0, 0.8)
	await tween_fade.finished
	
	# 5. Pasamos al Nivel 1 (¡Cambia esto por tu ruta real!)
	get_tree().change_scene_to_file("res://Nivel1.tscn")
