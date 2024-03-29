extends ColorRect

export var dialogPath = ""
export(float) var textSpeed = 0.05

var dialog


var phraseNum = 0
var finished = false

func _ready():
	visible = false
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()
	
func _process(_delta):
	$Indicator.visible = finished
	if Global.canTalk and Input.is_action_just_pressed("interact"):
		Global.talkOver = false
		visible = true
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)

func getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogPath), "File path does not exist")
		
	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
		
	var output = parse_json(json)
		
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []

func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		Global.talkOver = true
		queue_free()
		return
	finished = false
	
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
		
	finished = true
	phraseNum += 1
	return
