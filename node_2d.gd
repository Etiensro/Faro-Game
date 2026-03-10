extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tb_faro_pressed() -> void:	
	# 1. Crear la secuencia de animación (Tween)
	# create_tween() crea el animador invisible para esta acción.
	var tween_fade = create_tween()
	tween_fade.tween_property($CapaUI/PantallaNegra, "modulate:a", 1.0, 0.8)
	tween_fade.tween_callback(_cambiar_a_zoom_puerta)
	tween_fade.tween_property($CapaUI/PantallaNegra, "modulate:a", 0.0, 0.8)
	
func _cambiar_a_zoom_puerta():
	$CapaUI/FondoZoomPuerta.visible = true
	
func _on_tb_estatua_pressed() -> void:
	$CapaUI/FondoZoomEstatua.visible = true


func _on_tb_fuente_pressed() -> void:
	$CapaUI/FondoZoomFuente.visible = true


func _on_tb_pared_pressed() -> void:
	$CapaUI/FondoZoomPared.visible = true
