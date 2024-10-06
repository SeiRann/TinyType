extends Control

@onready var display_text = $Text
@onready var score_text = $Score
@onready var multiplier_text = $Multiplier
@onready var accuracy_text = $Accuracy
@onready var wpm_text = $WPM
@onready var timer = $WordTimer

var rng = RandomNumberGenerator.new()
var cursor = 0
var basetext
var neutraltext 
var correctText = ''
var incorrectText = ''
var score = 0
var streak = 0
var multiplier = 1
var correct_characters = 0
var total_characters = 0
var accuracy:float = 100
var start_time = 0.0
var elapsed_time = 0.0
var words_completed = 0
var wpm:float = 0.0
var timer_started = false


var words = ["capybara", "hyrax", "sugar glider", "pygmy hedgehog", "fennec fox", 
	"chinchilla", "guinea pig", "pika", "jerboa", "red panda", 
	"arctic fox", "kinkajou", "meerkat", "pygmy possum", "marmoset", 
	"degu", "tamandua", "wallaby", "quokka", "potoroo", 
	"banded hare-wallaby", "dik-dik", "groundhog", "prairie dog", 
	"tree kangaroo", "mouse deer", "raccoon", "binturong", "bushbaby", 
	"sea otter", "stoat", "hummingbird", "numbat", "spotted cuscus", 
	"southern hairy-nosed wombat", "north american porcupine", "squirrel", 
	"chipmunk", "flying squirrel", "cotton-top tamarin", "three-toed sloth", 
	"common dwarf hamster", "dwarf mongoose", "golden marmoset", 
	"black-footed ferret", "african pygmy hedgehog", "western pygmy mouse", 
	"yellow-bellied marmot", "paca", "bongo", "black-tailed prairie dog", 
	"ground squirrel", "common opossum", "fairy penguin", "rock wallaby", 
	"kangaroo", "giant rabbit", "miniature horse", "domestic ferret", 
	"baby elephant", "elephant shrew", "red squirrel", "muskox", 
	"tapir", "slow loris", "red kangaroo", "grey mouse lemur", 
	"spotted rat kangaroo", "javelina", "bandicoot", "dwarf hamster", 
	"sand cat", "black-tailed jackrabbit", "snowshoe hare", 
	"quokka", "marbled polecat", "three-banded armadillo", "koala", 
	"pika", "elephant shrew", "long-tailed tit", "northern short-tailed shrew", 
	"dwarf rabbit", "oriental fire-bellied toad", "platypus", 
	"common marmoset", "vicuna", "domestic guinea pig", "brushtail possum", 
	"bamboo lemur", "domestic cat", "common bottlenose dolphin", 
	"pigeon", "common raven", "red fox", "merle chihuahua", 
	"chipmunk", "wild rabbit", "fat-tailed dwarf lemur", "water vole", 
	"hedgehog tenrec", "deer mouse", "patas monkey", "spotted guinea pig", 
	"tree shrew", "silver-haired bat", "meerkat", "northern fur seal", 
	"kinkajou", "short-nosed echidna", "elephant seal", "green sea turtle", 
	"bottlenose dolphin", "greenland whale", "beluga whale", 
	"fin whale", "northern elephant seal", "southern elephant seal", 
	"sea lion", "polar bear", "walrus", "narwhal", "manatee", 
	"dugong", "sloth", "tapir", "moose", "ferret", 
	"rat", "squirrel", "armadillo", "agouti", "wolverine", 
	"tarsier", "pampas fox", "dingo", "mouse", "rabbits", 
	"weasel", "mink", "fossa", "dormouse", "muntjac", 
	"sika deer", "harbor seal", "sea otter", "mountain lion", 
	"bobcat", "lesser hedgehog tenrec", "golden hamster", 
	"chinchilla", "pygmy goat", "miniature donkey", "miniature pig", 
	"toy poodle", "shih tzu", "puppy", "kitten", "duckling", 
	"coyote", "hare", "hedgehog", "skunk", "squirrel", 
	"rabbit", "quokka","African elephant", "Binturong", "Bamboo lemur", "Black-tailed prairie dog", 
	"Capuchin monkey", "Chinese hamster", "Civet", "Colobus monkey", 
	"Common marmoset", "Cotton-top tamarin", "Damaraland mole rat", 
	"Elephant seal", "Greater bilby", "Honduran white bat", 
	"Indri", "Japanese dormouse", "Kowari", "Lesser mouse deer", 
	"Little brown bat", "Macaque", "Malayan flying fox", 
	"Mandrill", "Marsh rabbit", "Mouse lemur", 
	"Naked mole rat", "Northern flying squirrel", "Oncilla", 
	"Pacific black duck", "Pangolin", "Platypus", 
	"Pygmy rabbit", "Red-bellied paca", "Red-crowned crane", 
	"Ring-tailed lemur", "Short-tailed shrew", "Squirrel monkey", 
	"Sugar glider", "Tamaraw", "Tarsier",
	"Tree shrew", "White-footed mouse", "Wombat", 
	"Zebra duiker","African pygmy hedgehog", "Agouti", "Alpaca", "American badger", 
	"Asian elephant", "Bamboo rat", "Bat-eared fox", "Beaver", 
	"Binturong", "Bushbuck", "Capybara", "Civet cat", 
	"Common redstart", "Common squirrel monkey", "Cotton rat", 
	"Degu", "Dik-dik", "Dwarf cat", "Dwarf mongoose", 
	"Eastern chipmunk", "European hamster", "Fennec", 
	"Fossa", "Fruit bat", "Gaur", "Giant anteater", 
	"Green monkey", "Himalayan tahr", "Indian flying fox", 
	"Island fox", "Jerboa", "Kangaroo rat", "Kinkajou", 
	"Kolossus", "Lesser hedgehog tenrec", "Lynx", 
	"Malayan civet", "Marmoset monkey", "Mongoose", 
	"Mountain goat", "Muskrat", "Numbat", "Okapi", 
	"Opossum", "Orangutan", "Otter", "Paca", 
	"Pangolin", "Peccary", "Pika", "Potoroos", 
	 "Rabbit", "Red kangaroo", 
	"Reindeer", "Rock wallaby", "Saddle-billed stork", 
	"Sand cat", "Scaly-tailed flying squirrel", "Serval", 
	"Short-beaked echidna", "Sifaka", "South American coati", 
	"Spotted hyena", "Tamandua", "Tamarins", 
	"Thylacine", "Virginia opossum", "Western grey kangaroo", 
	"Wild boar", "Wolverine", "Zebra"]

func updateAccuracy():
	if total_characters > 0:
		var accuracy = (float(correct_characters) / float(total_characters)) * 100
		# Update the UI to display the accuracy
		accuracy_text.text = "Accuracy: " + str(accuracy).substr(0,5) + "%"

func gameReset():
	correctText = ''
	incorrectText = ''
	score = 0
	streak = 0
	multiplier = 1
	neutraltext = 0
	cursor = 0
	basetext = generateText(20)
	neutraltext=basetext
	words_completed = 0  # Reset word count
	timer_started = false  # Reset timer flag
	updateText()
	resetMultiplier()
	updateMultiplier()
	resetScore()

func resetScore():
	score = 0
	score_text.text = "Score:"+str(score)

func addScore(points, multiplier):
	score += points*multiplier
	score_text.text = "Score:"+str(score)

func resetMultiplier():
	multiplier = 1
	streak = 0
	updateMultiplier()

func updateMultiplier():
	match(multiplier):
		1:
			multiplier_text.text = "Multiplier:x"+str(multiplier)
		2:
			multiplier_text.text = "[color=green]"+"Multiplier:x"+str(multiplier)+"[/color]"
		3:
			multiplier_text.text = "[color=blue]"+"Multiplier:x"+str(multiplier)+"[/color]"
		4:
			multiplier_text.text = "[color=orange]"+"Multiplier:x"+str(multiplier)+"[/color]"
		5:
			multiplier_text.text = "[color=purple]"+"Multiplier:x"+str(multiplier)+"[/color]"

func updateText():
	if len(incorrectText)>0:
		display_text.text = "[color=green]" + correctText+ "[/color]" + "[color=red]"+incorrectText+"[/color]"+neutraltext
	else:
		display_text.text = "[color=green]" + correctText+ "[/color]" + "[color=red]"+incorrectText+"[/color]"+neutraltext
	
func updateWPM():
	elapsed_time = (Time.get_ticks_msec() / 1000.0) - start_time  # Time in seconds
	if elapsed_time > 0:
		wpm = (words_completed / elapsed_time) * 60.0  # Words per minute
		wpm_text.text = "WPM: " + str(wpm).substr(0, 5)

	
func addToCorrect(index):
	correctText += basetext[index]
	neutraltext = neutraltext.substr(1, len(neutraltext) - 1)
	correct_characters += 1  # Increment correct characters
	total_characters += 1  # Increment total characters typed
	
	if basetext[index] == "_" or index == len(basetext)-1:
		words_completed+=1
		updateWPM()
	
	updateText()
	updateAccuracy()  # Update accuracy after each correct input
	
func addToIncorrect(index):
	incorrectText += basetext[index]
	neutraltext = neutraltext.substr(1, len(neutraltext) - 1)
	total_characters += 1  # Increment total characters typed
	updateText()
	updateAccuracy()  # Update accuracy after each incorrect input
	
func removeIncorrect():
	neutraltext = incorrectText + neutraltext
	incorrectText = ""
	updateText()

func generateWord(length:int, material:String)->String:
	var word = ""
	for i in range(length):
		word+=material[rng.randi_range(0,len(material)-1)]
		
	return word

func generateText(word_length:int):
	var material
	var text = ""
	var word
	
	for i in range(word_length):
		word = words[rng.randi_range(0,len(words)-1)]
		if word.find("-") != -1:
			word = word.replace("-","_")
			word = word.replace(" ","_")
		else:
			word = word.replace(" ","_")
		
		if i == word_length-1:
			text+= word.to_lower()
		else:
			text+=word.to_lower()+"_"
	
	display_text.text=text
	return text

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			# Start the timer on the first input
			if not timer_started:
				start_time = Time.get_ticks_msec() / 1000.0  # Get time in seconds
				timer_started = true
			if cursor!=len(basetext)-1:
				if event.as_text_key_label().to_lower() == basetext[cursor]:
					#CORRECT
					if not len(incorrectText)>0:
						addToCorrect(cursor)
						streak+=1
						match(streak):
							20:
								multiplier+=1
								updateMultiplier()
								$Multiplier2.play()
							50:
								multiplier+=1
								updateMultiplier()
								$Multiplier3.play()
							100:
								multiplier+=1
								updateMultiplier()
								$Multiplier4.play()
							200:
								multiplier+=1
								updateMultiplier()
								$Multiplier5.play()
						
						addScore(1,multiplier)
						cursor+=1
				elif event.as_text() == "Space" and basetext[cursor]== "_":
					#CORRECT SPACE
					addToCorrect(cursor)
					cursor+=1
				elif event.as_text_key_label() == "Backspace":
					#BACKSPACE
					resetMultiplier()
					if len(incorrectText)>0:
						removeIncorrect()
						cursor-=1
				else:
					#WRONG
					$Mistake.play()
					resetMultiplier()
					if not len(incorrectText) > 0:
						addToIncorrect(cursor)
						cursor+=1
			else:
				updateAccuracy()
				display_text.text = "Finished!"
				$Finish.play()
				if accuracy == 100:
					$Capybara.visible = true
					$GortLabel.visible = true
				if wpm>=50:
					$Duck.visible = true
					$Duck.visible = true
				if score>=500:
					$RedPanda.visible = true
					$RedPandaLabel.visible = true
				if multiplier==5:
					$Beaver.visible = true
					$BeaverLabel.visible = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	basetext = generateText(20)
	neutraltext = basetext 
	$MainMusic.play()
	updateMultiplier()
	addScore(0,1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_button_pressed() -> void:
	gameReset()
