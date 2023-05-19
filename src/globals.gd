extends Node

var ranges
var average = 0
var min = 0
var max = 0

var descriptions = {
	"meal_inexpensive_restaurant": "Meal at an inexpensive Restaurant (USD)",
	"cigarettes": "Cigarettes 20 Pack (Marlboro) (USD)",
	"monthly_pass": "Monthly Pass (Regular Price) (USD)",
	"taxi": "Taxi 1km (Normal Tariff) (USD)",
	"basic":"Basic (Electricity, Heating, Cooling, Water, Garbage) for 85m2 Appartment (USD)",
	"internet": "Internet (60 Mbps or More, Unlimited Data, Cable/ADSL) (USD)",
	"cinema": "Cinema, International Release, 1 Seat (USD)",
	"beer_restaurant": "Average price of beer in restaurant (USD)",
	"beer_market": "Average price of beer at the market (USD)",
	"fruits": "Average cost of 1kg fruits",
	"vegetables": "Average cost of 1kg vegetables",
	"appartment_centre": "Price of 1 bedroom appartment in the city centre",
	"appartment_outside_centre": "Price of 1 bedroom appartment outside of the city center",
	"water": "Water (1.5 liter bottle, at the market) (USD)"
}
var names = {
	"meal_inexpensive_restaurant": "Meal",
	"cigarettes": "Cigarettes",
	"monthly_pass": "Monthly Pass",
	"taxi": "Taxi",
	"basic":"Basic Costs",
	"internet": "Internet",
	"cinema": "Cinema",
	"beer_restaurant": "Beer, Restaurant",
	"beer_market": "Beer, Market",
	"fruits": "Fruits",
	"vegetables": "Vegetables",
	"appartment_centre": "Appartment, City Centre",
	"appartment_outside_centre": "Appartment, Outside Centre",
	"water": "Water"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
