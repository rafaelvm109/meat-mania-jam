extends Node

@onready var press_machine: Node2D = $"../Machines/PressMachine"
@onready var mangler_machine: Node2D = $"../Machines/mangler_machine"
@onready var oven_machine: Node2D = $"../Machines/oven_machine"
@onready var inv_1: Panel = $"../Inventory/CanvasLayer/Control/Inv1"
@onready var inv_2: Panel = $"../Inventory/CanvasLayer/Control/Inv2"
@onready var inv_3: Panel = $"../Inventory/CanvasLayer/Control/Inv3"
@onready var inv_4: Panel = $"../Inventory/CanvasLayer/Control/Inv4"
@onready var chicken: Node2D = $"../Specimen/Chicken"
@onready var deliver_machine: Node2D = $"../Machines/deliver_machine"

var first_subject_list = [0, 1, 2]
var machine_order_list = []

"""
0: press machine
1: mangler machine
2: oven machine
3: injector machine
"""
func append_machine_order(machine: int) -> void:
	machine_order_list.append(machine)
	print(machine_order_list)


func clear_list() -> void:
	machine_order_list = []
	print("list cleared")


func is_subject_acceptable() -> bool:
	if machine_order_list == first_subject_list:
		print("both lists match, solution valid")
		return true
	else:
		print("lists do not match, solution invalid")
		return false


func snap_chicken_to_inv() -> void:
	if !press_machine.snap_subject and !mangler_machine.snap_mangler_subject and !oven_machine.snap_oven_subject and !deliver_machine.snap_deliver_subject:
		chicken.position = inv_1.global_position + (inv_1.size / 2)
