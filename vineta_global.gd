extends CanvasLayer

# --- REFERENCIAS A LOS NODOS ---
@onready var etiqueta_tiempo = $EtiquetaTiempo
@onready var timer = $Timer
@onready var video_game_over = $VideoGameOver # Tu VideoStreamPlayer de derrota

# --- CONFIGURACIÓN ---
var tiempo_restante = 650 # Tiempo inicial en segundos
var detenido = false

func _ready() -> void:
	# Al inicio, el video debe estar oculto
	video_game_over.visible = false
	actualizar_texto_reloj()
	
	# Configuración del Timer
	if timer:
		timer.wait_time = 1.0
		timer.one_shot = false
		if not timer.timeout.is_connected(_on_timer_timeout):
			timer.timeout.connect(_on_timer_timeout)
		timer.start()

# --- LÓGICA DEL RELOJ ---

func _on_timer_timeout() -> void:
	if not detenido:
		if tiempo_restante > 0:
			tiempo_restante -= 1
			actualizar_texto_reloj()
		else:
			ejecutar_game_over()

func actualizar_texto_reloj() -> void:
	# El int() y el 60.0 son para evitar el aviso de división de enteros
	var mins = int(tiempo_restante / 60.0)
	var segs = tiempo_restante % 60
	etiqueta_tiempo.text = "%02d:%02d" % [mins, segs]

# --- LÓGICA DE DERROTA (SOLO VIDEO) ---

func ejecutar_game_over() -> void:
	detenido = true
	if timer:
		timer.stop()
	
	# 1. Ocultamos el reloj para que no estorbe
	etiqueta_tiempo.visible = false
	
	# 2. Mostramos y reproducimos el video de derrota
	video_game_over.visible = true
	video_game_over.play()
	
	print("Tiempo agotado. Mostrando video de derrota final.")
	# El video se queda ahí y no se reinicia la escena.

# --- FUNCIÓN PARA DETENER DESDE OTROS NIVELES ---

func detener_reloj() -> void:
	detenido = true
	if timer:
		timer.stop()
	print("Reloj detenido externamente.")
