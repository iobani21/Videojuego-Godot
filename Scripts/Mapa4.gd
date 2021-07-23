extends Node2D

# Colisiones
var level_grid
var muros =[]
# Valores Iniciales
export (int) var grid_width = 25
export (int) var grid_height = 23
export (int) var x_start = -300
export (int) var y_start = -1700
export (int) var x_off = 150
export (int) var y_off = 150
#Variables de inicio 
var inicioxsalida=4
var inicioysalida=0
var inicioxrobot=16
var inicioyrobot=20
var inicioxsam=0
var inicioysam=22
# Objetos
var frodo
var enemigo
var sam
# Cargar Tiles
var tiles = [
	preload("res://Scenes/Scenes-Pisos/Piso-4.tscn"),
	preload("res://Scenes/Scenes-Personajes/Gollum.tscn"),
	preload("res://Scenes/Scenes-Muros/Muro-4.tscn"),
	preload("res://Scenes/Scenes-Personajes/Jugador1.tscn"),
	preload("res://Scenes/Scenes-Personajes/Sam.tscn")
]


func _ready():
	Generar_Muro_Vertical(-1,-1,24)#Muro izquierda
	Generar_Muro_Horizontal(-1,-1,26)#Muro Superior
	Generar_Muro_Vertical(25,-2,25)#Muro derecho
	Generar_Muro_Horizontal(-1,23,27)#Muro inferior
	
	#Obstaculos
	Generar_Muro_Vertical(2,-1,11)
	Generar_Muro_Vertical(2,10,12)
	
	Generar_Muro_Horizontal(3,1,10)
	Generar_Muro_Horizontal(14,1,10)
	
	Generar_Muro_Horizontal(4,3,20)
	Generar_Muro_Vertical(4,3,15)
	Generar_Muro_Vertical(4,18,5)
	Generar_Muro_Vertical(23,4,10)
	Generar_Muro_Vertical(23,14,10)
	
	Generar_Muro_Horizontal(11,15,5)
	Generar_Muro_Horizontal(11,10,6)
	Generar_Muro_Vertical(16,10,6)
	Generar_Muro_Vertical(11,10,2)
	Generar_Muro_Vertical(11,13,3)
	
	Generar_Muro_Horizontal(11,17,8)
	Generar_Muro_Vertical(18,7,9)
	Generar_Muro_Horizontal(9,7,10)
	Generar_Muro_Vertical(9,7,10)
	Generar_Muro_Vertical(7,6,18)
	Generar_Muro_Horizontal(5,5,17)
	Generar_Muro_Vertical(21,5,17)
	Generar_Muro_Horizontal(9,19,11)
	Generar_Muro_Horizontal(8,21,10)
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
	# Agregarlos al mapa
	add_child(frodo)
	add_child(enemigo)
	add_child(sam)

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

func _process(delta):
	#print("bar esta en : ",enemigo.grid_x,enemigo.grid_y)
	if sam.grid_x==frodo.grid_x and sam.grid_y==frodo.grid_y:
		print("te salvaste")
		enemigo.hide()
		get_tree().change_scene("res://Scenes/Menu.tscn")
		return 
	if   enemigo.grid_x==frodo.grid_x and enemigo.grid_y==frodo.grid_y:
		print("Lo atrape")
		frodo.hide()
		get_tree().change_scene("res://Scenes/Menu.tscn")
	else:
		var boss_siguiente=A(muros) #Devuelve  el nodo donde esta boss y el grafo ya esta mapeado por el metodo onda
	#print("muevete hacia :" , menor.x, menor.y)
	#print("Estamos en : ", robot.grid_x,robot.grid_y)
		var dir=Vector2(0,0)
		dir.x=boss_siguiente.x-enemigo.grid_x
		dir.y=boss_siguiente.y-enemigo.grid_y
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
	var acomulado
	var euristica
	var vecinos=[]
	func asignar_valor(x,y,distancia,padre,acomulado):
		self.x=x
		self.y=y
		self.padre=padre
		self.distancia=distancia
		self.acomulado=acomulado
		self.euristica=acomulado+distancia
		#print("x:",x,"y:",y," ",self.euristica,self.euristica,"nivel",self.nivel,"distancia",self.distancia) 
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
	func cambiar_euristica(distancia,acomulado):
		self.acomulado=acomulado
		self.distancia=distancia
		self.euristica=self.euristica+distancia
	func crear_vecino(nuevox,nuevoy,muros,franja,nodosvisitados,frodox,frodoy):
		var aux=Vector2(nuevox,nuevoy)
		var band=Verificar_muros(muros,aux)
		var restax=nuevox-frodox
		restax=restax*restax
		var restay=nuevoy-frodoy
		restay=restay*restay
		
		var distanciamatt= sqrt((restax+restay))
		distanciamatt=int(distanciamatt)
		if band==false:
			var nodo = NodoGrafo.new()
			nodo.asignar_valor(nuevox,nuevoy,distanciamatt,self,self.euristica)
			var aux2=nodo.verificar(nodosvisitados)
			if aux2==null:
					franja.append(nodo)
					self.vecinos.append(nodo)
			else:
				if aux2.euristica<(distanciamatt+acomulado):
					aux2.cambiar_euristica(distanciamatt,acomulado)
				self.vecinos.append(aux2)
				
	func expandir(xmeta,ymeta,lista,nodosvisitados,muros):
		var restax = xmeta-self.x
		var restay = xmeta-self.y
		restax=pow(restax,2)
		restay=pow(restay,2)
		var distanciamatt= sqrt((restax+restay))
		distanciamatt=int(distanciamatt)
		if self.esvisitado(nodosvisitados)==true:
			return null
		#Expandiendo arriba
		crear_vecino(self.x,self.y-1,muros,lista,nodosvisitados,xmeta,ymeta)
		#Expandiendo abajo
		crear_vecino(self.x,self.y+1,muros,lista,nodosvisitados,xmeta,ymeta)
		#Expandiendo izquierda
		crear_vecino(self.x-1,self.y,muros,lista,nodosvisitados,xmeta,ymeta)
		#Expandiendo derecha
		crear_vecino(self.x+1,self.y,muros,lista,nodosvisitados,xmeta,ymeta)
		if (self.x==xmeta and self.y==ymeta):
			#print(len(nodosvisitados))
			return self
		nodosvisitados.append(self)
		return null
func _recorre_la_franja(xmeta,ymeta,franja,nodosvisitados,muros):

	while(len(franja)!=0):
		if len(franja)>1:
			Ordenar_nodos(franja)
		var actual=franja.pop_front()
		var camino=actual.expandir(xmeta,ymeta,franja,nodosvisitados,muros)
		if camino!=null:
			return camino 
			
func Ordenar_nodos(lista):
	var num = len(lista)
	var i = 0
	while i < num:
		var j = i
		while j < num:
			if  lista[i].distancia > lista[j].distancia:
				var aux = lista[i]
				lista[i] = lista[j]
				lista[j] = aux
			j = j + 1
		i = i + 1
		
func A(muros):
	var la_franja=[]
	var nodos_visitados=[]
	var pl= NodoGrafo.new()
	var restax=enemigo.grid_x-frodo.grid_x
	var restay=enemigo.grid_y-frodo.grid_y
	restax=restax*restax
	restay=restay*restay
	#print(restax, " ",restay)
	var distanciamatt= sqrt((restax+restay))
	distanciamatt=int(distanciamatt)
	#print(distanciamatt)
	pl.asignar_valor(enemigo.grid_x,enemigo.grid_y,distanciamatt,null,0)
	la_franja.append(pl)
	var ruta=_recorre_la_franja(frodo.grid_x,frodo.grid_y,la_franja,nodos_visitados,muros)
	var mov_sig=Movimiento_siguiente(ruta)
	return mov_sig
	#print("Visite : ", len(nodos_visitados),"nodos ")


func Movimiento_siguiente(nodo):
	#print("Movimiento: ",nodo.x,nodo.y,"nivel",nodo.nivel)
	var pa=nodo.padre
	if pa!=null:
		if pa.padre==null:
			return nodo
		else:
			return Movimiento_siguiente(nodo.padre)





#Generar Mapa Funciones
func Generar_Muro_Horizontal(x,y,longitud):
	var sumadory
	for i in range(longitud):
		muros.append(Vector2(x+i,y))

func Generar_Muro_Vertical(x,y,longitud):
	
	for i in range(1,longitud):
		muros.append(Vector2(x,y+i))


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")
