tool
extends Spatial

export(Font) var font;
export(Color) var color;
export(String) var text;

func _ready():
	var label = get_node("Viewport/Label");
	label.add_font_override("font", font);
	label.add_color_override("font_color", color);
	label.text = text.replace("\\n", "\n");
