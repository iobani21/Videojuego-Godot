extends Node2D

# Colisiones
var level_grid
var muros =[ 
Vector2(0,-1),Vector2(1,-1),Vector2(2,-1),Vector2(3,-1),Vector2(4,-1) ,Vector2(5,-1) , Vector2(6,-1),Vector2(7,-1),Vector2(8,-1),Vector2(9,-1),Vector2(-1,-1),Vector2(10,-1),Vector2(11,-1),Vector2(12,-1), #Muro Superior
Vector2(-1,0),Vector2(-1,1),Vector2(-1,2), Vector2(-1,3),Vector2(-1,4),Vector2(-1,5),Vector2(-1,6),Vector2(-1,7),Vector2(-1,8),Vector2(-1,9),Vector2(-1,10),Vector2(-1,11),Vector2(-1,12),Vector2(-1,13), #Muro Izquierda
Vector2(0,13),Vector2(1,13),Vector2(2,13),Vector2(3,13),Vector2(4,13),Vector2(5,13),Vector2(6,13),Vector2(7,13) ,Vector2(8,13),Vector2(9,13),Vector2(-1,13),Vector2(10,13),Vector2(11,13), #Muro inferior
Vector2(12,8),Vector2(12,7),Vector2(12,6),Vector2(12,5),Vector2(12,4),Vector2(12,3),Vector2(12,2),Vector2(12,1),Vector2(12,0),Vector2(12,-1),Vector2(12,9),Vector2(12,10),Vector2(12,11),Vector2(12,12),Vector2(12,13), #Muro Derecho
#Obstaculos
Vector2(11,11),Vector2(10,11),Vector2(10,11),Vector2(9,11),Vector2(8,11),Vector2(7,11),Vector2(6,11),Vector2(5,11),Vector2(4,11),Vector2(3,11),Vector2(2,11),Vector2(1,11),
Vector2(1,0),Vector2(1,1),Vector2(1,3),Vector2(1,4),Vector2(1,5),Vector2(1,6),Vector2(1,7),Vector2(1,8),Vector2(1,9),Vector2(1,10),
Vector2(3,1),Vector2(4,1),Vector2(5,1),Vector2(7,1),Vector2(8,1),Vector2(9,1),Vector2(10,1),Vector2(2,1),
Vector2(5,3),Vector2(4,3),Vector2(3,3),
Vector2(3,4),Vector2(3,5),Vector2(3,6),Vector2(3,7),Vector2(3,8),Vector2(3,9),
Vector2(7,3),Vector2(8,3),Vector2(9,3),Vector2(10,3),Vector2(10,3),
Vector2(5,5),Vector2(6,5),Vector2(7,5),Vector2(8,5),Vector2(9,5),Vector2(10,5),Vector2(11,5),
Vector2(4,7),Vector2(5,7),Vector2(6,7),Vector2(7,7),Vector2(8,7),Vector2(9,7),Vector2(10,7),
Vector2(4,9),Vector2(5,9),Vector2(6,9),Vector2(7,9),Vector2(8,9),Vector2(8,9),Vector2(10,9)
]

# Valores Iniciales
export (int) var grid_width = 13
export (int) var grid_height = 14
export (int) var x_start = -300
export (int) var y_start = -950
export (int) var x_off = 150
export (int) var y_off = 150
#Variables de inicio 
var inicioxsalida=5
var inicioysalida=0
var inicioxrobot=0
var inicioyrobot=1
var inicioxsam=11
var inicioysam=12
var inicioxespada=9
var inicioyespada=9
var inicioxluz=11
var inicioyluz=4
var lu=false
var es=false
# Objetos
var frodo
var enemigo
var sam
var espada
var luz
# Cargar Tiles
var tiles = [
	preload("res://Scenes/Scenes-Pisos/Piso-2.tscn"),
	preload("res://Scenes/Scenes-Personajes/Enemigo-2.tscn"),
	preload("res://Scenes/Scenes-Muros/Muro-2.tscn"),
	preload("res://Scenes//Scenes-Personajes/Jugador1.tscn"),
	preload("res://Scenes//Scenes-Personajes/Sam.tscn"),
	preload("res://Scenes//Scenes-Personajes/Luz.tscn"),
	preload("res://Scenes//Scenes-Personajes/Espada.tscn")
]

var tiles2=[
	preload("res://Scenes/Scenes-Muros/Muro-2.tscn"),
	preload("res://Scenes/Scenes-Muros/Muro-2.tscn"),
	
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
	sam=tiles[4].instance()
	luz=tiles[5].instance()
	espada=tiles[6].instance()
	# Agregarlos al mapa
	add_child(frodo)
	add_child(enemigo)
	add_child(sam)
	add_child(luz)
	add_child(espada)
	# Posicion de los Objetos
	var frodo_position = grid_to_pixel(inicioxsalida, inicioysalida)
	frodo.position = Vector2(frodo_position[0], frodo_position[1])
	frodo.grid_x = inicioxsalida
	frodo.grid_y = inicioysalida

	var enemigo_position= grid_to_pixel(inicioxrobot,inicioyrobot)
	enemigo.position = Vector2(enemigo_position[0], enemigo_position[1])
	enemigo.grid_x = inicioxrobot
	enemigo.grid_y = inicioyrobot

	var sam_position= grid_to_pixel(inicioxsam,inicioysam)
	sam.position = Vector2(sam_position[0], sam_position[1])
	sam.grid_x = inicioxsam
	sam.grid_y = inicioysam
	
	var luz_position= grid_to_pixel(inicioxluz,inicioyluz)
	luz.position = Vector2(luz_position[0], luz_position[1])
	luz.grid_x = inicioxluz
	luz.grid_y = inicioyluz

	var espada_position= grid_to_pixel(inicioxespada,inicioyespada)
	espada.position = Vector2(espada_position[0], espada_position[1])
	espada.grid_x = inicioxespada
	espada.grid_y = inicioyespada
	


func _process(delta):
	#print("bar esta en : ",enemigo.grid_x,enemigo.grid_y)
	if luz.grid_x==frodo.grid_x and luz.grid_y==frodo.grid_y:
		print("luz recogida")
		luz.hide()
		$VBoxContainer/CheckBox.pressed=true
		lu=true
	if espada.grid_x==frodo.grid_x and espada.grid_y==frodo.grid_y:
		print("espada recogida")
		espada.hide()
		$VBoxContainer/CheckBox2.pressed=true
		es=true
	if sam.grid_x==frodo.grid_x and sam.grid_y==frodo.grid_y and es==true and lu==true:
		print("te salvaste")
		enemigo.hide()
		get_tree().change_scene("res://Scenes/Menu.tscn")
		return 
	if   enemigo.grid_x==frodo.grid_x and enemigo.grid_y==frodo.grid_y:
		print("Lo atrape")
		frodo.hide()
		get_tree().change_scene("res://Scenes/Menu.tscn")
	else:
		var boss_siguiente=Algoritmo_profundidad(muros) #Devuelve  el nodo donde esta boss y el grafo ya esta mapeado por el metodo onda
	#print("muevete hacia :" , menor.x, menor.y)
	#print("Estamos en : ", robot.grid_x,robot.grid_y)
		var dir=Vector2(0,0)
		dir.x=boss_siguiente.x-enemigo.grid_x
		dir.y=boss_siguiente.y-enemigo.grid_y
		#print("Te moveras a ",dir)
		turno(dir)
func turno(dir):
	Mover_Personajes(dir)
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
	var x
	for i in muros:
		x=randi()%2+0
		var tile2=tiles2[x].instance()
		add_child(tile2)
		var coordenadas= grid_to_pixel(i.x,i.y)
		tile2.position=Vector2(coordenadas[0], coordenadas[1])

func euristica(x,y):
	var restax = x-frodo.grid_x
	var restay = y-frodo.grid_y
	restax=pow(restax,2)
	restay=pow(restay,2)
	var distanciamatt= sqrt((restax+restay))
	#print(distanciamatt)
	return distanciamatt
class Nodo_Arbol:
	var x
	var y
	var padre
	var euristica #Distancia 
	var hijos=[]
	func asignar_valor(x,y,euristica,padre):
		self.x=x
		self.y=y
		self.padre=padre
		self.euristica=euristica
	func esvisitado(nodosvisitados):
		for i in nodosvisitados:
			if (i.x==self.x) and (i.y==self.y):
				return true
		return false
	func Ordenar_nodos():
		var num = len(self.hijos)
		var i = 0
		while i < num:
			var j = i
			while j < num:
				if self.hijos[i].euristica> self.hijos[j].euristica:
					var aux = self.hijos[i]
					self.hijos[i] = self.hijos[j]
					self.hijos[j] = aux
				j = j + 1
			i = i + 1
	func Verificar_muros(muros,vec):
		for i in muros:
			if i==vec:
				#print("Es un muro ")
				return true
		return false
		
	func Verificar(nodosvisitados,vector):
		for i in nodosvisitados:
			if (i.x==vector.x) and (i.y==vector.y):
				return true
		return false
	
	func crear_hijo(nuevox,nuevoy,muros,nodosvisitados,xfrodo,yfrodo):
		var aux=Vector2(nuevox,nuevoy)
		var band=Verificar_muros(muros,aux)
		var band2=self.Verificar(nodosvisitados,aux)
		var aux2
		if band==false  and band2==false:
			var nodo = Nodo_Arbol.new()
			#print(nuevox,nuevoy)
			var restax =nuevox-xfrodo
			var restay = nuevoy-yfrodo
			restax=pow(restax,2)
			restay=pow(restay,2)
			var distanciamatt= sqrt((restax+restay))
			nodo.asignar_valor(nuevox,nuevoy,distanciamatt,self)
			self.hijos.append(nodo)
	func expandir(muros,nodosvisitados,xfrodo,yfrodo):

		#Expandiendo arriba
		crear_hijo(self.x,self.y-1,muros,nodosvisitados,xfrodo,yfrodo)
		#Expandiendo abajo
		crear_hijo(self.x,self.y+1,muros,nodosvisitados,xfrodo,yfrodo)
		#Expandiendo izquierda
		crear_hijo(self.x-1,self.y,muros,nodosvisitados,xfrodo,yfrodo)
		#Expandiendo derecha
		crear_hijo(self.x+1,self.y,muros,nodosvisitados,xfrodo,yfrodo)
		nodosvisitados.append(self)
		
#Funciones de algoritmo en profundidad
func Movimiento_siguiente(nodo):
	#print("Movimiento: ",nodo.x,nodo.y)
	var pa=nodo.padre
	if pa!=null:
		if pa.padre==null:
			return nodo
		else:
			return Movimiento_siguiente(nodo.padre)

func Busqueda_Profundidad(muros , nodosvisitados,inicio_arana,xfrodo,yfrodo):
	if inicio_arana.x==xfrodo and inicio_arana.y==yfrodo:
		#print("Encontre ruta :" ,inicio_arana.x,inicio_arana.y )
		#print("Expandidos:",len(nodosvisitados))
		return inicio_arana
	inicio_arana.expandir(muros ,nodosvisitados,xfrodo,yfrodo)
	#print("se expandio : ",len(inicio_arana.hijos))
	inicio_arana.Ordenar_nodos()
	var aux=null
	for i in inicio_arana.hijos:
		aux =Busqueda_Profundidad(muros,nodosvisitados,i,xfrodo,yfrodo)
		if aux!=null:
			return aux
		
func Algoritmo_profundidad(muros):
	var nodosvisitados=[]
	var inicio_arana=Nodo_Arbol.new()
	inicio_arana.asignar_valor(enemigo.grid_x,enemigo.grid_y,euristica(enemigo.grid_x,enemigo.grid_y),null)
	var nodo_final=Busqueda_Profundidad(muros,nodosvisitados,inicio_arana,frodo.grid_x,frodo.grid_y)
	#print("euristica:",nodo_final.euristica)
	var siguiente_posicion=Movimiento_siguiente(nodo_final)
	return siguiente_posicion


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")
