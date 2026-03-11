extends Node2D

var acertijo_resuelto = false
var tiene_llave = false

func _ready() -> void:
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


#Abrir y cerrar el zoom grande
func _on_button_1_microscopio_pressed() -> void:
	hacer_transicion($CapaUI/ZoomMicroscopio,true)
	
func _on_button_cerrar_micro_pressed() -> void:
	hacer_transicion($CapaUI/ZoomMicroscopio,false)

	#Abrir y cerrar el visor 
func _on_button_visor_pressed() -> void:
	hacer_transicion($CapaUI/ZoomMicroscopio/VistaInternaMicro,true)
	#$CapaUI/ZoomMicroscopio/VistaInternaMicro.visible = true

func _on_button_cerrar_vista_micro_pressed() -> void:
	hacer_transicion($CapaUI/ZoomMicroscopio/VistaInternaMicro,false)
	#$CapaUI/ZoomMicroscopio/VistaInternaMicro.visible = false

#Pizarron
func _on_button_1_pizarron_pressed() -> void:
	hacer_transicion($CapaUI/ZoomPizarron,true)
	#$CapaUI/ZoomPizarron.visible = true


func _on_button_cerrar_pizarron_pressed() -> void:
	hacer_transicion($CapaUI/ZoomPizarron,false)
	#$CapaUI/ZoomPizarron.visible = false
	# 2. Si el acertijo AÚN NO está resuelto, limpiamos la evidencia del error
	if not acertijo_resuelto:
		$CapaUI/ZoomPizarron/LineEdit.clear() # Borra el texto que escribió el jugador
		$CapaUI/ZoomPizarron/LabelMensaje.text = "" # Borra el mensaje en rojo


func _on_button_comprobar_pressed() -> void:
	# 1. BLOQUEO DE ESTADO: Si ya está resuelto, salimos de la función inmediatamente
	if acertijo_resuelto:
		return
		
	# Obtenemos el texto y le quitamos espacios en blanco a los lados
	var respuesta_jugador = $CapaUI/ZoomPizarron/LineEdit.text.strip_edges()
	
	# 2. VALIDACIÓN: ¿Está vacío?
	if respuesta_jugador.is_empty():
		$CapaUI/ZoomPizarron/LabelMensaje.text = "Ingresa un número."
		return 
		
	# 3. VALIDACIÓN: ¿Escribió letras o símbolos en lugar de números?
	if not respuesta_jugador.is_valid_int():
		$CapaUI/ZoomPizarron/LabelMensaje.text = "Usa solo números."
		$CapaUI/ZoomPizarron/LineEdit.clear() # Limpiamos el texto erróneo
		return 
		
	# 4. EVALUACIÓN LÓGICA: Comprobar la respuesta correcta
	if respuesta_jugador == "100": 
		print("¡Respuesta correcta!")
		$CapaUI/ZoomPizarron/LabelMensaje.text = "¡Correcto!"
		$CapaUI/ZoomPizarron/LabelMensaje.modulate = Color(0, 1, 0) # Pinta el texto de verde
		acertijo_resuelto = true
		
		# UX: Deshabilitamos la entrada de texto y el botón con TU nombre exacto de nodo
		$CapaUI/ZoomPizarron/LineEdit.editable = false
		$CapaUI/ZoomPizarron/ButtonComprobar.disabled = true
		
	else:
		print("¡Respuesta incorrecta!")
		$CapaUI/ZoomPizarron/LabelMensaje.text = "Número incorrecto."
		$CapaUI/ZoomPizarron/LabelMensaje.modulate = Color(1, 0, 0) # Pinta el texto de rojo
		$CapaUI/ZoomPizarron/LineEdit.clear() # Limpia la caja para un nuevo intento
		
		

#Cofre
func _on_button_1_cofre_cerrado_pressed() -> void:
	# 1. Primero verificamos si ya vació el cofre
	if tiene_llave:
		print("El cofre ya está vacío.")
		# Aquí podrías poner un Label en la pantalla principal que diga "Ya está vacío"
		
	# 2. Si no tiene la llave, pero ya resolvió el puzzle, lo abrimos
	elif acertijo_resuelto:
		print("¡El cofre se abre!")
		hacer_transicion($CapaUI/ZoomCofre, true)
		
	# 3. Si no ha resuelto el puzzle
	else:
		print("El cofre está bloqueado. Falta resolver la sucesión.")
		

#Llave
func _on_button_llave_pequena_pressed() -> void:
	hacer_transicion($CapaUI/ZoomCofre/Llave,true)
	print("Mostrando la llave grande")
	#$CapaUI/ZoomCofre/Llave.visible = true
	$CapaUI/ZoomCofre/ButtonTomarLlave.visible = true


func _on_button_tomar_llave_pressed() -> void:
	print("¡Llave guardada!")
	# 1. Activamos el 'post-it' de memoria: el jugador ya tiene la llave
	tiene_llave = true 
	
	# 2. Escondemos la llave grande y el botón de tomar
	hacer_transicion($CapaUI/ZoomCofre/Llave,false)
	#$CapaUI/ZoomCofre/Llave.visible = false
	hacer_transicion($CapaUI/ZoomCofre/ButtonTomarLlave,false)
	#$CapaUI/ZoomCofre/ButtonTomarLlave.visible = false
	
	# 3. Escondemos el botón invisible de la llave pequeña
	# (Así el jugador ya no podrá interactuar con el dibujo de la llave)
	$CapaUI/ZoomCofre/ButtonLlavePequena.visible = false
	$CapaUI/ZoomCofre.visible = false


func _on_button_1_puerta_pressed() -> void:
	if tiene_llave == true:
		print("Haciendo zoom a la puerta...")
		$CapaUI/ZoomPuerta.visible = true
	else:
		print("Está cerrada. Necesitas la llave.")


# Esta función se conecta a la señal pressed() de tu TextureButton
func _on_texture_button_pressed() -> void:
	print("Reproduciendo video de la puerta...")
	
	# 1. Ocultamos el botón para que el jugador no le dé clic varias veces
	$CapaUI/ZoomPuerta/TextureButton.visible = false
	
	# 2. Hacemos visible el reproductor de video
	$CapaUI/ZoomPuerta/VideoStreamPlayer.visible = true
	
	# 3. Le damos "Play" al video
	$CapaUI/ZoomPuerta/VideoStreamPlayer.play()
	
	# 4. Esperamos automáticamente a que el video termine
	await $CapaUI/ZoomPuerta/VideoStreamPlayer.finished
	
	# 5. Fundido a negro final para tapar el final del video
	var tween_fade = create_tween() # <-- ¡Agregamos 'var'!
	tween_fade.tween_property($CapaUI/PantallaNegra, "modulate:a", 1.0, 0.6) # <-- Apuntamos a la pantalla negra
	await tween_fade.finished
	
	# 6. Cambiamos de escena (¡Cambia el nombre por el de tu escena real!)
	get_tree().change_scene_to_file("res://Nivel3/habitacion_faro.tscn")

func _on_button_cerrar_cofre_pressed() -> void:
	hacer_transicion($CapaUI/ZoomCofre, false)
