extends Node2D

var acertijo_resuelto = false
var tiene_llave = false

func _ready() -> void:
	pass

#Abrir y cerrar el zoom grande
func _on_button_1_microscopio_pressed() -> void:
	$CapaUI/ZoomMicroscopio.visible = true
	
func _on_button_cerrar_micro_pressed() -> void:
	$CapaUI/ZoomMicroscopio.visible = false

	#Abrir y cerrar el visor 
func _on_button_visor_pressed() -> void:
	print("¡Clic en el visor! Abriendo pista...") 
	$CapaUI/ZoomMicroscopio/VistaInternaMicro.visible = true

func _on_button_cerrar_vista_micro_pressed() -> void:
	print("Cerrando pista...")
	$CapaUI/ZoomMicroscopio/VistaInternaMicro.visible = false

#Pizarron
func _on_button_1_pizarron_pressed() -> void:
	print("Abriendo el pizarron...")
	$CapaUI/ZoomPizarron.visible = true


func _on_button_cerrar_pizarron_pressed() -> void:
	$CapaUI/ZoomPizarron.visible = false


func _on_button_comprobar_pressed() -> void:
	#Guardar lo que el jugador escribio en una variable
	var respuesta_jugador = $CapaUI/ZoomPizarron/LineEdit.text.strip_edges()
	
	if respuesta_jugador == "100": 
		#Acerto!
		print("¡Respuesta correcta!")
		$CapaUI/ZoomPizarron/LabelMensaje.text = "¡Correcto!"
		acertijo_resuelto = true
	else:
		print("¡Respuesta incorrecta!")
		$CapaUI/ZoomPizarron/LabelMensaje.text = "Número incorrecto"
		
		

#Cofre
func _on_button_1_cofre_cerrado_pressed() -> void:
	if acertijo_resuelto == true:
		print("¡El cofre se abre!")
		$CapaUI/ZoomCofre.visible = true
	else:
		print("El cofre está bloqueado. Falta resolver la susesión. ")
		

#Llave
func _on_button_llave_pequena_pressed() -> void:
	print("Mostrando la llave grande")
	$CapaUI/ZoomCofre/Llave.visible = true
	$CapaUI/ZoomCofre/ButtonTomarLlave.visible = true


func _on_button_tomar_llave_pressed() -> void:
	print("¡Llave guardada!")
	# 1. Activamos el 'post-it' de memoria: el jugador ya tiene la llave
	tiene_llave = true 
	
	# 2. Escondemos la llave grande y el botón de tomar
	$CapaUI/ZoomCofre/Llave.visible = false
	$CapaUI/ZoomCofre/ButtonTomarLlave.visible = false
	
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


func _on_boton_perilla_pressed() -> void:
	print("¡Puerta abierta! ¡Libertad!")
	# 1. Mostramos el mensaje de victoria
	$CapaUI/ZoomPuerta/Label.visible = true
	
	# 2. Opcional: Escondemos el botón de la parrilla 
	# para que no pueda darle clic otra vez
	$CapaUI/ZoomPuerta/BotonPerilla.visible = false
