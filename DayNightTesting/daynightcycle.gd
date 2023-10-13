extends CanvasModulate

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

signal time_tick(day:int, hour:int, minute:int)

@export var gradient:GradientTexture1D
@export var INGAME_SPEED = 1.0
@export var INITIAL_HOUR = 6

var time:float = 0.0
var past_minute:float = 1.0

func _ready():
	time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR
func _process(delta:float):
	# runs rapidly
	#time += delta
	
	# runs on a twenty minute(?) day/night cycle
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	var value = ((sin(time) + 1.0) / 2.0)
	self.color = gradient.gradient.sample(value)
	
	_recalculate_time()

func _recalculate_time():
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	var day = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)
	if past_minute != minute: 
		past_minute = minute
		time_tick.emit(day,hour,minute)
