extends Node

@onready var press_machine: Node2D = $"../Machines/PressMachine"
@onready var mangler_machine: Node2D = $"../Machines/mangler_machine"
@onready var oven_machine: Node2D = $"../Machines/oven_machine"
@onready var inv_1: Panel = $"../Inventory/CanvasLayer/Control/Inv1"
@onready var inv_2: Panel = $"../Inventory/CanvasLayer/Control/Inv2"
@onready var inv_3: Panel = $"../Inventory/CanvasLayer/Control/Inv3"
@onready var inv_4: Panel = $"../Inventory/CanvasLayer/Control/Inv4"
@onready var deliver_machine: Node2D = $"../Machines/deliver_machine"
@onready var injector_machine: Node2D = $"../Machines/Injector"
@onready var specimen: Node = $"../Specimen"

var unusable_specimen: bool = false
var chicken_solution_list = [0, 1, 2] # solution list for first specimen
var sheep_solution_list = [3, 1] # solution list for first specimen
var pig_solution_list = [4, 1, 3] # solution list for first specimen
var machine_order_list = [] # list of the actual sequence
var current_specimen = null


func _process(delta: float) -> void:
	current_specimen = specimen.get_child(0)

"""
0: press machine
1: mangler machine
2: oven machine
3: injector machine (mitosis)
4: injector macjine (growth)
"""
# adds a number from 0 to 3 to the list based on the machine used
func append_machine_order(machine: int) -> void:
	machine_order_list.append(machine)
	print(machine_order_list)


# resets the list
func clear_list() -> void:
	machine_order_list = []
	print("list cleared")


# resets the machine counters
func clear_machine_counter() -> void:
	press_machine.smashed_count = 0
	mangler_machine.mangled_count = 0
	oven_machine.clicks_to_burn = 0


# compares both lists to determine if solution is valid
func is_subject_acceptable() -> bool:
	if current_specimen.name.to_lower() == "chicken" and machine_order_list == chicken_solution_list:
		print("both lists match, solution valid")
		return true
	elif current_specimen.name.to_lower() == "sheep" and machine_order_list == sheep_solution_list:
		print("both lists match, solution valid")
		return true
	elif current_specimen.name.to_lower() == "pig" and machine_order_list == pig_solution_list:
		print("both lists match, solution valid")
		return true
	else:
		print("lists do not match, solution invalid")
		return false


# if specimen is not in any machine, then snap it into the inventory
func snap_chicken_to_inv() -> void:
	if !press_machine.snap_subject and !mangler_machine.snap_mangler_subject and !oven_machine.snap_oven_subject and !deliver_machine.snap_deliver_subject and !injector_machine.snap_injector_specimen:
		current_specimen.position = inv_1.global_position + (inv_1.size / 2)
