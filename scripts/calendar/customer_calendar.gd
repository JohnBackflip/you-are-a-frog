extends Resource
class_name CustomerCalendar

@export var customer_calendar : Array[DailyCustomers]

func get_day(day : int):
	return customer_calendar[day]
