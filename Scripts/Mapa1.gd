extends Node2D

# Colisiones
var level_grid
var muros =[ 
Vector2(0,-1),Vector2(1,-1),Vector2(2,-1),Vector2(3,-1),Vector2(4,-1) ,Vector2(5,-1) , Vector2(6,-1),Vector2(7,-1),Vector2(8,-1),Vector2(9,-1),Vector2(-1,-1), #Muro Superior
Vector2(-1,0),Vector2(-1,1),Vector2(-1,2), Vector2(-1,3),Vector2(-1,4),Vector2(-1,5),Vector2(-1,6),Vector2(-1,7), #Muro Izquierda
Vector2(0,8),Vector2(1,8),Vector2(2,8),Vector2(3,8),Vector2(4,8),Vector2(5,8),Vector2(6,8),Vector2(7,8) ,Vector2(8,8),Vector2(9,8),Vector2(-1,8), #Muro inferior
Vector2(10,8),Vector2(10,7),Vector2(10,6),Vector2(10,5),Vector2(10,4),Vector2(10,3),Vector2(10,2),Vector2(10,1),Vector2(10,0),Vector2(10,-1), #Muro Derecho
#Obstaculos
Vector2(1,0),Vector2(1,1),Vector2(1,2),Vector2(2,2),Vector2(3,2),Vector2(4,2),Vector2(5,2),
Vector2(6,2),Vector2(6,1),Vector2(6,3),Vector2(6,4),Vector2(5,4),Vector2(4,4),Vector2(3,4),
Vector2(2,4),Vector2(1,4),Vector2(1,7),Vector2(1,6),Vector2(3,5),Vector2(3,6),Vector2(5,6),
Vector2(6,6),Vector2(7,6),Vector2(8,6),Vector2(8,5),Vector2(8,4),Vector2(8,3),Vector2(8,2),
Vector2(8,1)
]
# Valores Iniciales
export (int) var grid_width = 10
export (int) var grid_height = 8
export (int) var x_start = -300
export (int) var y_start = -550
export (int) var x_off = 150
export (int) var y_off = 150
#Variables de inicio 
var an=false
var inicioxsalida=4
var inicioysalida=0
var inicioxrobot=0
var inicioyrobot=0
var inicioxgandalf=0
var inicioygandalf=7
var inicioxanillo=8
var inicioyanillo=7
# Objetos
var frodo
var enemigo
var gandalf
var anillo
# Cargar Tiles
var tiles = [
	preload("res://Scenes/Scenes-Pisos/Piso-1.tscn"),
	preload("res://Scenes/Scenes-Personajes/Enemigo.tscn"),
	preload("res://Scenes/Scenes-Muros/Muro-1.tscn"),
	preload("res://Scenes/Scenes-Personajes/Jugador1.tscn"),
	preload("res://Scenes/Scenes-Personajes/Gandalf.tscn"),
	preload("res://Scenes/Scenes-Personajes/Anillo.tscn")
	
]


func _ready():
	level_grid = []
	for i in range(grid_width):
		level_grid.append([])
		for j in range(grid_height):
			level_grid[i].append(0)
			
	draw_level()

	#Creacion de los Nodos
	frodo = tiles[3].instance()
	enemigo=tiles[1].instance()
	gandalf=tiles[4].instance()
	anillo= tiles[5].instance()
	# Agregarlos al mapa
	add_child(frodo)
	add_child(enemigo)
	add_child(gandalf)
	add_child(anillo)

	# Posicion de los Objetos
	var frodo_position = grid_to_pixel(inicioxsalida, inicioysalida)
	frodo.position = Vector2(frodo_position[0], frodo_position[1])
	frodo.grid_x = inicioxsalida
	frodo.grid_y = inicioysalida

	var enemigo_position= grid_to_pixel(inicioxrobot,inicioyrobot)
	enemigo.position = Vector2(enemigo_position[0], enemigo_position[1])
	enemigo.grid_x = inicioxrobot
	enemigo.grid_y = inicioyrobot

	var gandalf_position= grid_to_pixel(inicioxgandalf,inicioygandalf)
	gandalf.position = Vector2(gandalf_position[0], gandalf_position[1])
	gandalf.grid_x = inicioxgandalf
	gandalf.grid_y = inicioygandalf
	
	var anillo_position= grid_to_pixel(inicioxanillo,inicioyanillo)
	anillo.position = Vector2(anillo_position[0], anillo_position[1])
	anillo.grid_x = inicioxanillo
	anillo.grid_y = inicioyanillo
func _process(delta):
	if anillo.grid_x==frodo.grid_x and anillo.grid_y==frodo.grid_y:
		print("anillo recogido")
		anillo.hide()
		$VBoxContainer/CheckBox.pressed=true
		an=true
	#print("bar esta en : ",enemigo.grid_x,enemigo.grid_y)
	if (gandalf.grid_x==frodo.grid_x and gandalf.grid_y==frodo.grid_y) and an==true:
		print("te salvaste")
		$VBoxContainer/CheckBox2.pressed=true
		enemigo.hide()
		get_tree().change_scene("res://Scenes/Menu.tscn")
		return 
	if   enemigo.grid_x==frodo.grid_x and enemigo.grid_y==frodo.grid_y:
		print("Lo atrape")
		frodo.hide()
		get_tree().change_scene("res://Scenes/Menu.tscn")
	else:
		var boss_grafo=Generar_grafo_planificador(muros) #Devuelve  el nodo donde esta boss y el grafo ya esta mapeado por el metodo onda
		var menor=null
		for i in boss_grafo.vecinos:
			if menor==null:
				menor=i
			if menor.distancia>i.distancia:
				menor=i
	#print("muevete hacia :" , menor.x, menor.y)
	#print("Estamos en : ", robot.grid_x,robot.grid_y)
		var dir=Vector2(0,0)
		dir.x=menor.x-enemigo.grid_x
		dir.y=menor.y-enemigo.grid_y
		#print("Te moveras a ",dir)
		turno(dir)

func turno(dir):
	Mover_Personajes(dir)
	

# Convertir los pixeles a cordenadas 
func grid_to_pixel(x, y): #Donde voy a estar ubicado
	return Vector2(x * x_off + x_start, y * y_off + y_start)
		
# Dibujar grid
func draw_level():
	for i in range(grid_width):
		for j in range(grid_height):
			if (level_grid[i][j] == 0):
				var tile = tiles[0].instance()
				add_child(tile)
				var pos = grid_to_pixel(i, j)
				tile.position = Vector2(pos[0], pos[1])
				#print(tile.position)
	for i in muros:
		var tile=tiles[2].instance()
		add_child(tile)
		var coordenadas= grid_to_pixel(i.x,i.y)
		tile.position=Vector2(coordenadas[0], coordenadas[1])
func Mover_robot(dir):
	# Mover Robot a la siguiente posicion
	if (dir != Vector2(0, 0)):
		var target = Vector2(enemigo.grid_x + dir[0], enemigo.grid_y + dir[1])
		var band=false
		for i in muros:
			if i==target:
				band=true
				print("No puedo moverme ahi")
		if band==false:
			enemigo.position = grid_to_pixel(target[0], target[1])
			enemigo.grid_x = target[0]
			enemigo.grid_y = target[1]
			
	dir = Vector2(0, 0)
func Mover_Personajes(dir2):
	var dir = Vector2(0, 0)
	
	if (Input.is_action_just_pressed("ui_right")):
		dir = Vector2(1, 0)
	elif (Input.is_action_just_pressed("ui_left")):
		dir = Vector2(-1, 0)
	elif (Input.is_action_just_pressed("ui_up")):
		dir = Vector2(0, -1)
	elif (Input.is_action_just_pressed("ui_down")):
		dir = Vector2(0, 1)
	
	# Move the player to the new position
	if (dir != Vector2(0, 0)):
		var target = Vector2(frodo.grid_x + dir[0], frodo.grid_y + dir[1])
		var band=false
		for i in muros:
			if i==target:
				band=true
				print("No puedo moverme ahi")
		if band==false:
			frodo.position = grid_to_pixel(target[0], target[1])
			frodo.grid_x = target[0]
			frodo.grid_y = target[1]
			Mover_robot(dir2)
	# Set direction back to nothing
	dir = Vector2(0, 0)
class NodoGrafo:
	var x
	var y
	var padre
	var distancia
	var vecinos=[]
	func asignar_valor(x,y,distancia,padre):
		self.x=x
		self.y=y
		self.padre=padre
		if distancia==-1:
			self.distancia=0 
		else:
			self.distancia=distancia+1
	func esvisitado(nodosvisitados):
		for i in nodosvisitados:
			if (i.x==self.x) and (i.y==self.y):
				return true
		return false
		
	func Verificar_muros(muros,vec):
		for i in muros:
			if i==vec:
				#print("Es un muro ")
				return true
		return false
		
	func verificar(nodosvisitados):
		for i in nodosvisitados:
			if (i.x==self.x) and (i.y==self.y):
				return i
		return null
	func crear_vecino(nuevox,nuevoy,muros,lista,nodosvisitados):
		var aux=Vector2(nuevox,nuevoy)
		var band=Verificar_muros(muros,aux)
		var aux2
		if band==false:
			var nodo = NodoGrafo.new()
			nodo.asignar_valor(nuevox,nuevoy,self.distancia,self)
			aux2=nodo.verificar(nodosvisitados)
			if aux2==null:
					lista.append(nodo)
					self.vecinos.append(nodo)
			else:
				self.vecinos.append(aux2)
	func generar_vecinos(xmeta,ymeta,lista,nodosvisitados,muros):
		var restax = xmeta-self.x
		var restay = xmeta-self.y
		restax=pow(restax,2)
		restay=pow(restay,2)
		var distancia= sqrt((restax+restay))
		distancia=int(distancia)
		if self.esvisitado(nodosvisitados)==true:
			return null
		#Expandiendo arriba
		crear_vecino(self.x,self.y-1,muros,lista,nodosvisitados)
		#Expandiendo abajo
		crear_vecino(self.x,self.y+1,muros,lista,nodosvisitados)
		#Expandiendo izquierda
		crear_vecino(self.x-1,self.y,muros,lista,nodosvisitados)
		#Expandiendo derecha
		crear_vecino(self.x+1,self.y,muros,lista,nodosvisitados)
		if (self.x==xmeta and self.y==ymeta):
			return self
		nodosvisitados.append(self)
		return null
func _recorre_cola_atencion(xmeta,ymeta,lista,nodosvisitados,muros):
	while(len(lista)!=0):
		var actual=lista.pop_front()
		var camino=actual.generar_vecinos(xmeta,ymeta,lista,nodosvisitados,muros)
		if camino!=null:
			return camino 
			
func Generar_grafo_planificador(muros):
	var lista=[]
	var nodos_visitados=[]
	var pl= NodoGrafo.new()
	pl.asignar_valor(frodo.grid_x,frodo.grid_y,-1,null)
	lista.append(pl)
	var robot_grafo=_recorre_cola_atencion(enemigo.grid_x,enemigo.grid_y,lista,nodos_visitados,muros)
	var restax = frodo.grid_x-robot_grafo.x
	var restay = frodo.grid_y-robot_grafo.y
	return robot_grafo




	


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")
