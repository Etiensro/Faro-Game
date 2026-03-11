extends Control

# --- REFERENCIAS A LOS NODOS ---
@onready var vista_acertijo = $VistaAcertijo
@onready var vista_teclado = $VistaTeclado
@onready var pantalla_teclado = $VistaTeclado/PantallaNumero
@onready var pantalla_negra = $PantallaNegra
@onready var video_final = $VideoFinal
@onready var video_felicidades = $VideoFelicidades

# --- CONFIGURACIÓN ---
var SOLUCION_FINAL = "1132" 
var respuesta_usuario = ""

func _ready() -> void:
	# Todo empieza oculto y la pantalla negra transparente
	vista_acertijo.visible = false
	vista_teclado.visible = false
	video_final.visible = false
	video_felicidades.visible = false
	pantalla_teclado.text = ""
	pantalla_negra.modulate.a = 0.0
	
	# Conectamos el final del primer video al segundo por seguridad
	video_final.finished.connect(_on_video_final_terminado)

# --- LÓGICA DE GANAR ---

func ganar_nivel():
	pantalla_teclado.text = "OK"
	
	# 1. Detenemos el tiempo en la Viñeta Global
	if has_node("/root/VinetaGlobal"):
		get_node("/root/VinetaGlobal").detener_reloj()
	
	# 2. Transición al primer video (Acción)
	# Aquí corregí el nombre de la variable para que no te dé error
	var tween_final = create_tween()
	
	# Fundido a negro
	tween_final.tween_property(pantalla_negra, "modulate:a", 1.0, 1.0)
	
	# Cambios en la oscuridad
	tween_final.tween_callback(func():
		vista_teclado.visible = false
		video_final.visible = true
		video_final.play()
	)
	
	# Revelar el video
	tween_final.tween_property(pantalla_negra, "modulate:a", 0.0, 1.0)

# --- SECUENCIA DEL SEGUNDO VIDEO (FELICIDADES) ---

func _on_video_final_terminado():
	# Transición rápida entre videos
	var tween_cambio = create_tween()
	tween_cambio.tween_property(pantalla_negra, "modulate:a", 1.0, 0.5)
	
	tween_cambio.tween_callback(func():
		video_final.visible = false
		video_felicidades.visible = true
		video_felicidades.play()
	)
	
	tween_cambio.tween_property(pantalla_negra, "modulate:a", 0.0, 0.5)

# --- NAVEGACIÓN Y BOTONES ---

func hacer_transicion(panel_destino: Control, mostrar: bool) -> void:
	var tween_fade = create_tween()
	tween_fade.tween_property(pantalla_negra, "modulate:a", 1.0, 0.6)
	tween_fade.tween_callback(func(): panel_destino.visible = mostrar)
	tween_fade.tween_property(pantalla_negra, "modulate:a", 0.0, 0.6)

func registrar_numero(num: String):
	if respuesta_usuario.length() < 8:
		respuesta_usuario += num
		pantalla_teclado.text = respuesta_usuario

func _on_boton_enter_pressed():
	if respuesta_usuario == SOLUCION_FINAL:
		ganar_nivel()
	else:
		pantalla_teclado.text = "ERROR"
		respuesta_usuario = ""
		await get_tree().create_timer(1.0).timeout
		pantalla_teclado.text = ""

# --- SEÑALES DE BOTONES (Asegúrate de conectarlas en el editor) ---
func _on_boton_acertijo_pressed(): hacer_transicion(vista_acertijo, true)
func _on_boton_teclado_pressed(): hacer_transicion(vista_teclado, true)
func _on_boton_cerrar_acertijo_pressed(): hacer_transicion(vista_acertijo, false)
func _on_boton_cerrar_teclado_pressed():
	hacer_transicion(vista_teclado, false)
	respuesta_usuario = ""
	pantalla_teclado.text = ""

# Botones numéricos
func _on_boton_0_pressed(): registrar_numero("0")
func _on_boton_1_pressed(): registrar_numero("1")
func _on_boton_2_pressed(): registrar_numero("2")
func _on_boton_3_pressed(): registrar_numero("3")
func _on_boton_4_pressed(): registrar_numero("4")
func _on_boton_5_pressed(): registrar_numero("5")
func _on_boton_6_pressed(): registrar_numero("6")
func _on_boton_7_pressed(): registrar_numero("7")
func _on_boton_8_pressed(): registrar_numero("8")
func _on_boton_9_pressed(): registrar_numero("9")
