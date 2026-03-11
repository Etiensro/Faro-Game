extends Node2D

# Aquí guardaremos lo que el jugador vaya tecleando
var secuencia_actual: Array = []

var puzzle_fuente_resuelto: bool = false
var llave_recolectada: bool = false

# La respuesta correcta según tu diseño
var secuencia_correcta: Array = ["corona", "estrella", "craneo", "caliz"]

# Prerrequisito: Precarga de las imágenes de fondo
var img_fuente_cerrada = preload("res://Assets/Escenas/FuenteZoom.png")
var img_fuente_abierta = preload("res://Assets/Escenas/CapsulaAbierta.jpeg")
var img_fuente_sin_llave = preload("res://Assets/Escenas/CapsulaAbierta_SinLlave.jpeg") 
var img_llave_png = preload("res://Assets/UI/Llave.png") 

# Variables para cargar las imágenes de tus PNGs
var img_corona = preload("res://Assets/UI/Corona.png")
var img_estrella = preload("res://Assets/UI/Estrella.png")
var img_craneo = preload("res://Assets/UI/Craneo.png")
var img_caliz = preload("res://Assets/UI/Caliz.png")
var img_guadana = preload("res://Assets/UI/Guadana.png")
var img_triquete = preload("res://Assets/UI/Triqueta.png")
var img_rayo = preload("res://Assets/UI/Rayo.png")
var img_poligono = preload("res://Assets/UI/Poligono.png")
var img_espiral = preload("res://Assets/UI/Espiral.png")
var img_ojo = preload("res://Assets/UI/Ojo.png")

func agregar_simbolo(nombre_simbolo: String, textura: Texture2D) -> void:
	$CapaUI/FondoZoomPanel/MensajePantalla.text = ""
	
	if secuencia_actual.size() < 4:
		secuencia_actual.append(nombre_simbolo)
		var numero_casilla = secuencia_actual.size()
		var ruta_casilla = "CapaUI/FondoZoomPanel/HBoxContainer/Casilla" + str(numero_casilla)
		get_node(ruta_casilla).texture = textura

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

# Método para transiciones (Ahora usa siempre EfectosSecundarios)
func hacer_transicion(panel_destino: Control, mostrar: bool) -> void:
	var tween_fade = create_tween()
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 1.0, 0.6)
	tween_fade.tween_callback(func(): panel_destino.visible = mostrar)
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 0.0, 0.6)


func _on_tb_faro_pressed() -> void:	
	if llave_recolectada:
		# Si ya tenemos la llave, iniciamos la película final
		pasar_al_nivel_2()
	else:
		# Si no tenemos la llave, solo hacemos zoom a la puerta como siempre
		hacer_transicion($CapaUI/FondoZoomPuerta, true)

# --- NUEVA FUNCIÓN PARA LA TRANSICIÓN FINAL ---
func pasar_al_nivel_2() -> void:
	var tween_fade = create_tween()
	
	# 1. Fundido a negro para salir del patio
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 1.0, 0.6)
	await tween_fade.finished 
	
	# 2. Encendemos el video y le damos Play
	$EfectosSecundarios/VideoTransicion.visible = true
	$EfectosSecundarios/VideoTransicion.play()
	
	# 3. Quitamos la pantalla negra para revelar el video
	tween_fade = create_tween()
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 0.0, 0.6)
	
	# 4. Esperamos automáticamente a que el video termine
	await $EfectosSecundarios/VideoTransicion.finished
	
	# 5. Fundido a negro final para tapar el final del video
	tween_fade = create_tween()
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 1.0, 0.6)
	await tween_fade.finished
	
	# 6. Cambiamos de escena (¡Cambia el nombre por el de tu escena real!)
	get_tree().change_scene_to_file("res://Nivel2/nivel_2.tscn")

func _on_btn_cerrar_puerta_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomPuerta,false)

func _on_tb_estatua_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomEstatua,true)

func _on_btn_cerrar_estatua_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomEstatua,false)


func _on_tb_fuente_pressed() -> void:
	var tween_fade = create_tween()
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 1.0, 0.6)
	
	tween_fade.tween_callback(func():
		$CapaUI/FondoZoomFuente.visible = true
		
		if llave_recolectada:
			$CapaUI/FondoZoomFuente/ImagenFuente.texture = img_fuente_sin_llave
			# Ocultamos la cápsula cerrada y el botón del panel para que no se encimen
			$CapaUI/FondoZoomFuente/ImagenFuente/CapsulaCerrada.visible = false
			$CapaUI/FondoZoomFuente/ImagenFuente/TBAparatoFuente.visible = false
			$CapaUI/FondoZoomFuente/LlaveClickable.disabled = true
			$CapaUI/FondoZoomFuente/LlaveClickable.visible = false
			
		elif puzzle_fuente_resuelto:
			$CapaUI/FondoZoomFuente/ImagenFuente.texture = img_fuente_abierta
			# Ocultamos la cápsula cerrada y el botón del panel para que no se encimen
			$CapaUI/FondoZoomFuente/ImagenFuente/CapsulaCerrada.visible = false
			$CapaUI/FondoZoomFuente/ImagenFuente/TBAparatoFuente.visible = false
			$CapaUI/FondoZoomFuente/LlaveClickable.disabled = false
			$CapaUI/FondoZoomFuente/LlaveClickable.visible = true
			
		else:
			$CapaUI/FondoZoomFuente/ImagenFuente.texture = img_fuente_cerrada
			# Mostramos la cápsula cerrada y el botón del panel
			$CapaUI/FondoZoomFuente/ImagenFuente/CapsulaCerrada.visible = true
			$CapaUI/FondoZoomFuente/ImagenFuente/TBAparatoFuente.visible = true
			$CapaUI/FondoZoomFuente/LlaveClickable.disabled = true
			$CapaUI/FondoZoomFuente/LlaveClickable.visible = false
	)
	
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 0.0, 0.6)

func _on_btn_cerrar_fuente_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomFuente,false)

func _on_tb_pared_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomPared,true)

func _on_btn_cerrar_pared_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomPared,false)


func _on_tb_aparato_fuente_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomPanel,true)

func _on_btn_cerrar_fuente_2_pressed() -> void:
	hacer_transicion($CapaUI/FondoZoomPanel,false)


# --- BOTONES DE SÍMBOLOS ---
func _on_tb_guadana_pressed() -> void:
	agregar_simbolo("guadana", img_guadana)

func _on_tb_triqueta_pressed() -> void:
	agregar_simbolo("triquete", img_triquete)

func _on_tb_corona_pressed() -> void:
	agregar_simbolo("corona", img_corona)

func _on_tb_caliz_pressed() -> void:
	agregar_simbolo("caliz", img_caliz)

func _on_tb_rayo_pressed() -> void:
	agregar_simbolo("rayo", img_rayo)

func _on_tb_craneo_pressed() -> void:
	agregar_simbolo("craneo", img_craneo)

func _on_tb_poligono_pressed() -> void:
	agregar_simbolo("poligono", img_poligono)

func _on_tb_espiral_pressed() -> void:
	agregar_simbolo("espiral", img_espiral)

func _on_tb_ojo_pressed() -> void:
	agregar_simbolo("ojo", img_ojo)

func _on_tb_estrella_pressed() -> void:
	agregar_simbolo("estrella", img_estrella)
# ---------------------------

func _on_tb_ok_pressed() -> void:
	var etiqueta_mensaje = $CapaUI/FondoZoomPanel/MensajePantalla
	
	if secuencia_actual == secuencia_correcta:
		limpiar_casillas()
		etiqueta_mensaje.text = "CORRECTO"
		etiqueta_mensaje.modulate = Color(0, 1, 0) 
		
		puzzle_fuente_resuelto = true
		
		var tween_fade = create_tween()
		tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 1.0, 0.6)
		
		tween_fade.tween_callback(func():
			$CapaUI/FondoZoomPanel.visible = false
			$CapaUI/FondoZoomFuente.visible = true
			
			$CapaUI/FondoZoomFuente/ImagenFuente.texture = img_fuente_abierta
			# Escondemos el dibujo de la cápsula cerrada para evitar el acumulado
			$CapaUI/FondoZoomFuente/ImagenFuente/CapsulaCerrada.visible = false
			$CapaUI/FondoZoomFuente/ImagenFuente/TBAparatoFuente.visible = false
			
			$CapaUI/FondoZoomFuente/LlaveClickable.disabled = false
			$CapaUI/FondoZoomFuente/LlaveClickable.visible = true
		)
		
		tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 0.0, 0.6)
		
	else:
		limpiar_casillas() 
		etiqueta_mensaje.text = "ERROR"
		etiqueta_mensaje.modulate = Color(1, 0, 0) 
		secuencia_actual.clear() 

func limpiar_casillas() -> void:
	$CapaUI/FondoZoomPanel/HBoxContainer/Casilla1.texture = null
	$CapaUI/FondoZoomPanel/HBoxContainer/Casilla2.texture = null
	$CapaUI/FondoZoomPanel/HBoxContainer/Casilla3.texture = null
	$CapaUI/FondoZoomPanel/HBoxContainer/Casilla4.texture = null

func _on_llave_clickable_pressed() -> void:
	recolectar_llave_sequence()

func recolectar_llave_sequence() -> void:
	var tween_fade = create_tween()
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 1.0, 0.6)
	await tween_fade.finished 
	
	$CapaUI/FondoZoomFuente.visible = false 
	$EfectosSecundarios/LlaveGrande.visible = true 
	
	tween_fade = create_tween()
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 0.0, 0.6)
	await tween_fade.finished 
	
	await get_tree().create_timer(1.0).timeout
	
	tween_fade = create_tween()
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 1.0, 0.6)
	await tween_fade.finished
	
	llave_recolectada = true
	
	$EfectosSecundarios/LlaveGrande.visible = false 
	$CapaUI/FondoZoomFuente/ImagenFuente.texture = img_fuente_sin_llave 
	$CapaUI/FondoZoomFuente/LlaveClickable.disabled = true 
	$CapaUI/FondoZoomFuente/LlaveClickable.visible = false
	$CapaUI/FondoZoomFuente.visible = true 
	
	tween_fade = create_tween()
	tween_fade.tween_property($EfectosSecundarios/PantallaNegra, "modulate:a", 0.0, 0.6)
