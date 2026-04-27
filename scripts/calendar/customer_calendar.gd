extends Resource
class_name CustomerCalendar

@export_dir var customer_calendar_folder : String = "res://resources/calendar"
# What customers will come in what days
@export var customer_calendar : Array[DailyCustomers]

func _init() -> void:
	customer_calendar.clear()
	var dir = DirAccess.open(customer_calendar_folder)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Only load files ending in .tres or .res
			if not dir.current_is_dir() and (file_name.ends_with(".tres") or file_name.ends_with(".res")):
				var day = load(customer_calendar_folder + "/" + file_name)
				if day is DailyCustomers:
					customer_calendar.append(day)
			
			file_name = dir.get_next()
		
		print("Loaded %d days from folder!" % customer_calendar.size())
	else:
		push_error("Could not open potion folder path: " + customer_calendar_folder)

func get_day(day : int):
	if day <= customer_calendar.size() - 1:
		return customer_calendar[day]
