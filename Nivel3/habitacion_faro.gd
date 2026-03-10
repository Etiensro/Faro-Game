extends Control

# --- REFERENCIAS A LOS NODOS ---
@onready var vista_acertijo = $VistaAcertijo
@onready var vista_teclado = $VistaTeclado
@onready var pantalla = $VistaTeclado/PantallaNumero 

# --- CONFIGURACIÓN DEL JUEGO ---
var SOLUCION_FINAL = "150" 
var respuesta_usuario = ""

func _ready():
	vista_acertijo.visible = false
	vista_teclado.visible = false
	pantalla.text = ""

# --- LÓGICA DEL TECLADO ---

func registrar_numero(num):
	if respuesta_usuario.length() < 8:
		respuesta_usuario += num
		pantalla.text = respuesta_usuario

func _on_boton_enter_pressed():
	if respuesta_usuario == SOLUCION_FINAL:
		ganar_nivel()
	else:
		pantalla.text = "ERROR"
		respuesta_usuario = ""
		await get_tree().create_timer(1.0).timeout
		pantalla.text = ""

# --- EFECTO DE VICTORIA ---

func ganar_nivel():
	pantalla.text = "OK"
	var capa_blanca = ColorRect.new()
	capa_blanca.color = Color.WHITE
	capa_blanca.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	capa_blanca.modulate.a = 0 
	add_child(capa_blanca)
	
	var tween = create_tween()
	tween.tween_property(capa_blanca, "modulate:a", 1.0, 3.0)
	await tween.finished

# --- BOTONES NUMÉRICOS ---
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

# --- NAVEGACIÓN (ABRIR VISTAS) ---

func _on_boton_acertijo_pressed():
	vista_acertijo.visible = true

func _on_boton_teclado_pressed():
	vista_teclado.visible = true

# --- NUEVOS BOTONES PARA CERRAR (REGRESAR) ---

func _on_boton_cerrar_acertijo_pressed():
	vista_acertijo.visible = false

func _on_boton_cerrar_teclado_pressed():
	vista_teclado.visible = false
	# Limpiamos lo que escribió por si quiere empezar de cero al volver
	respuesta_usuario = ""
	pantalla.text = ""

# Mantener clic derecho como opción extra para cerrar
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		_on_boton_cerrar_acertijo_pressed()
		_on_boton_cerrar_teclado_pressed()
