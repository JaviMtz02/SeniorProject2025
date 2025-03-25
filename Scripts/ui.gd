extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var time_label: Label = $TimeLabel
@onready var money_label: Label = $MoneyLabel

var money_accrued: int = 0

func _ready():
	if get_parent().has_method("get_level_data"):
		var level_data = get_parent().get_level_data()
		# Convert minutes & seconds into just seconds
		timer.set_wait_time(level_data["time_minutes"] * 60 + level_data["time_seconds"])
		timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_timer_label()
	update_money_label()

func update_timer_label():
	var seconds: int = int(timer.time_left) % 60
	var minutes: int = int(timer.time_left / 60)
	time_label.text = "%02d:%02d" % [minutes, seconds]

func update_money_label():
	money_label.text = str(GameManager.get_current_money_accrued())
