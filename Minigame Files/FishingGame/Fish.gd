extends Resource
class_name Fish

@export var fish_name: String = "FIHH"
@export var tint: Color = Color.SKY_BLUE

@export_range(0.2, 3.0, 0.05) var bite_time_avg: float = 1.3 
@export_range(0.1, 2.0, 0.05) var bite_time_variance: float = 0.5
 
@export_range(0.0, 1.0, 0.01) var difficulty: float = 0.45
 
enum MovePattern { SMOOTH, DARTY, SINK_RISE, CHAOTIC }
@export var pattern: MovePattern = MovePattern.SMOOTH
