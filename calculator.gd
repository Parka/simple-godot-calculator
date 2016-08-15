
extends PanelContainer

onready var NumPad = find_node("NumPad")
onready var OpPad = find_node("OperationsPad")
onready var Display = find_node("Display")

var stored = 0
var currentOp = ""

func _ready():
	for button in NumPad.get_children():
		button.connect("pressed",self,"num_pressed",[button])
	for button in OpPad.get_children():
		button.connect("pressed",self,"op_pressed",[button])

func num_pressed ( button ) :
	if is_inf(stored):
		stored = 0
		Display.set_text("")
		currentOp = "0"
		
	if !Display.get_text().is_valid_float():
		Display.set_text("0")
		
	if Display.get_text().is_valid_float() && currentOp == "=":
		currentOp = ""
		Display.set_text("0")
	
	if Display.get_text() == "0" && button.get_text() != '.':
		Display.set_text(button.get_text())
	elif Display.get_text().find(".") < 0 || button.get_text() != '.':
		Display.set_text(Display.get_text() + button.get_text())

func op_pressed ( button ) :
	if button.get_text() == "C":
		stored = 0
		currentOp = ""
		Display.set_text("0")
	else:
		calculate()
		currentOp = button.get_text()
		
		if button.get_text() == "=" || is_inf(stored):
			Display.set_text(str(stored))
		else:
			Display.set_text(button.get_text())

func calculate():
	if Display.get_text().is_valid_float() && !is_inf(stored):
		if currentOp == "+":
			stored = stored + Display.get_text().to_float()
		elif currentOp == "-":
			stored = stored - Display.get_text().to_float()
		elif currentOp == "/":
			stored = stored / Display.get_text().to_float()
		elif currentOp == "*":
			stored = stored * Display.get_text().to_float() 
		elif currentOp == "":
			stored = Display.get_text().to_float() 