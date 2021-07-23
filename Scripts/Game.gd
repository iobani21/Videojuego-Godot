extends Node2D

# Actual level tiles
var level_grid
var muros =[ Vector2(0,-1),Vector2(1,-1),Vector2(2,-1),Vector2(3,-1),Vector2(4,-1) ,Vector2(-1,0),Vector2(-1,1),Vector2(-1,2), Vector2(0,3),Vector2(1,3),Vector2(2,3),Vector2(3,3),Vector2(3,4),Vector2(5,0),Vector2(5,1),Vector2(5,2)]
# Customizable level data
export (int) var grid_width = 5
export (int) var grid_height = 3
export (int) var x_start = 90
export (int) var y_start = 90
export (int) var x_off = 150
export (int) var y_off = 150
var inicioxplayer=4
var inicioyplayer=0
var inicioxboss=0
var inicioyboss=0
# Keep up with the player tile
var player
var boss
# Loading the tiles that will be used
var tiles = [
	preload("res://Scenes/Scenes-Pisos/Piso.tscn"),
	preload("res://Scenes/Scenes-Personajes/Jugador1.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the grid to all default tiles
	level_grid = []
	for i in range(grid_width):
		level_grid.append([])
		for j in range(grid_height):
			level_grid[i].append(0)
			
	# This function will do more when there are more tile types
	draw_level()

	# Initialize the player object
	player = tiles[1].instance()
	boss=tiles[1].instance()
	# Add the player to the game
	add_child(player)
	add_child(boss)

	# Set position and player variables
	var player_position = grid_to_pixel(inicioxplayer, inicioyplayer)
	player.position = Vector2(player_position[0], player_position[1])
	player.grid_x = inicioxplayer
	player.grid_y = inicioyplayer

	var boss_position= grid_to_pixel(inicioxboss,inicioyboss)
	boss.position = Vector2(boss_position[0], boss_position[1])
	boss.grid_x = inicioxboss
	boss.grid_y = inicioyboss

# Check for input every frame
func _process(delta):
	check_input()
	var boss_grafo=Generar_grafo_planificador(muros) #Devuelve  el nodo donde esta boss y el grafo ya esta mapeado por el metodo onda
	var lista_movimientos=[]
	Busqueda_Profundidad(boss_grafo,lista_movimientos)
	print("Debes hacer estos movimientos para encontrarlo")
	for i in lista_movimientos:
		print("x[",i.x,"]"," y[",i.y,"]")
		#turno(nueva_posicion)
# Convert grid coordinates to pixel values
func grid_to_pixel(x, y): #Donde voy a estar ubicado
	return Vector2(x * x_off + x_start, y * y_off + y_start)
		
# Draw each tile in the level grid
func draw_level():
	for i in range(grid_width):
		for j in range(grid_height):
			if (level_grid[i][j] == 0):
				var tile = tiles[0].instance()
				add_child(tile)
				var pos = grid_to_pixel(i, j)
				tile.position = Vector2(pos[0], pos[1])
				#print(tile.position)
func check_input():
	# Calculate the direction the player is trying to go
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
		var target = Vector2(boss.grid_x + dir[0], boss.grid_y + dir[1])
		var band=false
		for i in muros:
			if i==target:
				band=true
				print("No puedo moverme ahi")
		if band==false:
			boss.position = grid_to_pixel(target[0], target[1])
			boss.grid_x = target[0]
			boss.grid_y = target[1]
			
	# Set direction back to nothing
	dir = Vector2(0, 0)

func turno (nueva_posicion):
	# Calculate the direction the player is trying to go
	var dir = Vector2(0, 0)
	dir[0]=nueva_posicion.x
	dir[1]=nueva_posicion.y
	
	
	# Move the player to the new position
	if (dir != Vector2(0, 0)):
		var target = Vector2(boss.grid_x + dir[0], boss.grid_y + dir[1])
		var band=false
		for i in muros:
			if i==target:
				band=true
				print("No puedo moverme ahi")
		if band==false:
			boss.position = grid_to_pixel(target[0], target[1])
			boss.grid_x = target[0]
			boss.grid_y = target[1]
			
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
		var distanciamatt= sqrt((restax+restay))
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
	pl.asignar_valor(player.grid_x,player.grid_y,-1,null)
	lista.append(pl)
	#print(player.grid_x,player.grid_y)
	#print("actual:",boss.grid_x," ",boss.grid_y)
	var boss_grafo=_recorre_cola_atencion(boss.grid_x,boss.grid_y,lista,nodos_visitados,muros)
	var restax = player.grid_x-boss_grafo.x
	var restay = player.grid_y-boss_grafo.y
	#restax=pow(restax,2)
	#restay=pow(restay,2)
	#var distanciamatt= sqrt((restax+restay))
	#distanciamatt= int(round(distanciamatt))
	return boss_grafo
	#print("Visite : ", len(nodos_visitados),"nodos ")
	#print("muevete hacia : ",camino.x ,",",camino.y)



#Funciones de algoritmo en profundidad
func Busqueda_Profundidad(boss_grafo,lista_movimientos):
	var menor=null 
	for i in boss_grafo.vecinos:
		if menor==null:
			menor=i
		if menor.distancia>i.distancia:
			menor=i
	lista_movimientos.append(menor)
	if menor.distancia<1:
		return 
	Busqueda_Profundidad(menor,lista_movimientos)
	
