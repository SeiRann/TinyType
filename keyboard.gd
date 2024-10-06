extends Node2D

@onready var keys = get_children()


func position(x0:int,y0:int,key_size:int,scale):
	
	for i in range(len(keys)):
		keys[i].scale = Vector2(scale,scale)
		if i<=9:
			keys[i].position = Vector2(((i+x0)*key_size+key_size/2)*scale,(0+key_size/2+y0)*scale)
		elif i>=10 and i<19:
			keys[i].position = Vector2(((i+x0-9.75)*key_size+key_size/2)*scale, (key_size+key_size/2+y0)*scale)
		elif i>=19 and i<26:
			keys[i].position = Vector2(((i+x0-17.5)*key_size+key_size/2)*scale, (key_size*2+key_size/2+y0)*scale)
		else:
			keys[i].position = Vector2(((i+x0-21.5)*key_size+key_size/2)*scale, (key_size*3+key_size/2+y0)*scale)

func _ready():
	position(7.5,195,32,1.5)
	
	

# Dictionary to map key names to their corresponding AnimatedSprite2D nodes
@onready var key_sprites = {
	"Q": $Q,
	"W": $W,
	"E": $E,
	"R": $R,
	"T": $T,
	"Y": $Y,
	"U": $U,
	"I": $I,
	"O": $O,
	"P": $P,
	"A": $A,
	"S": $S,
	"D": $D,
	"F": $F,
	"G": $G,
	"H": $H,
	"J": $J,
	"K": $K,
	"L": $L,
	"Z": $Z,
	"X": $X,
	"C": $C,
	"V": $V,
	"B": $B,
	"N": $N,
	"M": $M,
	"Space": $space
}

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_name = event.as_text_key_label()
		if key_sprites.has(key_name):
			if event.pressed:
				key_sprites[key_name].play("pressed")
			else:
				key_sprites[key_name].play("default")
