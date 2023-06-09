extends Node3D

var csv = preload("res://data/processed_data_full9.csv")
var rangedata = preload("res://data/processed_data_ranges.csv")
var unis = preload("res://data/universities.csv")

@onready var globe = $".."
signal loaded_data

# Called when the node enters the scene tree for the first time.
func _ready():
	#var data = load_csv_file(csv_path)
	#print(data[0])
	var data = csv.records
	#print("########################################################")
	#print(datarec[0])
	#var ranges = load_ranges("res://data/processed_data_ranges.csv")
	var rangedatarec = rangedata.records
	for d in data:
		Globals.universities.append({"city": d["city"], "country": d["country"], "university": d["university"]})
	#Globals.universities = unis.records
	
	
	#print(rangedatarec)
	var clean = {}
	var averages = []
	var avg = 0;
	for i in rangedatarec.size():
		clean[rangedatarec[i]["keys"]] = [float(rangedatarec[i]["max"]), float(rangedatarec[i]["min"]), float(rangedatarec[i]["avg"])]
	var ranges = clean
	for i in ranges.values():
		averages.append(float(i[2]))
		avg += float(i[2])
	avg = avg/averages.size()
	var min = averages.min()
	var max = averages.max()
	Globals.average = avg
	Globals.min = min
	Globals.max = max
	globe.ranges = ranges
	Globals.ranges = ranges
	#await get_tree().createtimer(5).timeout
	#await $"../earth_scene".ready
	#print("ready")
	for e in data:
		var city_marker = globe.add_marker(e.get("latitude"), e.get("longitude"), e)
		city_marker._on_data_loaded(min,max,avg)
	loaded_data.emit()
	pass # Replace with function body.


func load_csv_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var contents = file.get_as_text()
	var lines = contents.split("\r")
	print(len(lines))
	var data = []
	var keys = lines[0].split(",")
	print(keys)
	
	for l in range(len(lines)):
		if l != 0:
			var fields = lines[l].split(",")
			var dict = create_dictionary(keys, fields)
			data.append(dict)
	file.close()
	return data

func create_dictionary(keys, values) -> Dictionary:
	var dictionary = {}
	for i in range(keys.size()):
		if len(values) > i:
			dictionary[keys[i]] = values[i]
	return dictionary

func load_ranges(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var contents = file.get_as_text()
	var lines = contents.split("\r")
	var data = {}
	var _keys = lines[0].split(",")
	for i in range(len(lines) - 1):
		if i != 0:
			var clean = lines[i].get_slice("\n", 1)
			clean = clean.split(",")
			var key = clean[0]
			var values = [float(clean[1]), float(clean[2]), float(clean[3])]
			data[key] = values
	return data
