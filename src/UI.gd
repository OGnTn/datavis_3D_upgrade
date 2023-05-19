extends Control


var filter_size_y_base = 498
var filter_pos_y_base = 128

var filter_size_y_collapsed = 0
var filter_pos_y_collapsed = 626

var collapsed = false

func toggle_collapse():
	var tween1 = create_tween()
	var tween2 = create_tween()
	tween1.set_trans(Tween.TRANS_ELASTIC)
	tween2.set_trans(Tween.TRANS_ELASTIC)
	if collapsed:
		tween1.tween_property($FilterPanel, "size",  Vector2($FilterPanel.size.x, filter_size_y_base), 0.3)
		tween2.tween_property($FilterPanel, "position",  Vector2($FilterPanel.position.x, $FilterPanel.position.y - 500), 0.3)
		#$FilterPanel.size.y = filter_size_y_base
		#$FilterPanel.position.y = filter_pos_y_base
		$FilterPanel/FilterContainer.visible = true
		collapsed = false
	else:
		tween1.tween_property($FilterPanel, "size",  Vector2($FilterPanel.size.x, filter_size_y_collapsed), 0.3)
		tween2.tween_property($FilterPanel, "position",  Vector2($FilterPanel.position.x, $FilterPanel.position.y + 500), 0.3)
		$FilterPanel/FilterContainer.visible = false
		collapsed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	toggle_collapse()

func _on_collapse_filter_pressed():
	toggle_collapse()
