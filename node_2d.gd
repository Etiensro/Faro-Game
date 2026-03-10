extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Método para transiciones
func hacer_transicion(panel_destino: Control, mostrar: bool) -> void:
	var tween_fade = create_tween()
	
	# 1. Fundido a negro
	tween_fade.tween_property($CapaUI/PantallaNegra, "modulate:a", 1.0, 0.6)
	
	# 2. Callback con función anónima para aplicar el parámetro
	tween_fade.tween_callback(func(): panel_destino.visible = mostrar)
	
	# 3. Fundido a transparente
	tween_fade.tween_property($CapaUI/PantallaNegra, "modulate:a", 0.0, 0.6)


func _on_tb_faro_pressed() -> void:	
	hacer_transicion($CapaUI/FondoZoomPuerta,true)

func _on_btn_cerrar_puerta_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomPuerta,false)


func _on_tb_estatua_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomEstatua,true)

func _on_btn_cerrar_estatua_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomEstatua,false)


func _on_tb_fuente_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomFuente,true)

func _on_btn_cerrar_fuente_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomFuente,false)

func _on_tb_pared_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomPared,true)

func _on_btn_cerrar_pared_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomPared,false)
