extends Resource
class_name CustomerCalendar

# What customers will come in what days
@export var customer_calendar : Array[DailyCustomers]

func get_day(day : int):
	if day <= customer_calendar.size() - 1:
		return customer_calendar[day]
