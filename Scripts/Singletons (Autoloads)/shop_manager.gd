extends Node

# Arrays that will hold buyable item objects
var bag_set: Array = []
var weapon_set: Array = []
var shoes_set: Array = []

var stick: PackedScene = preload("res://Scenes/Weapons/attack_hit_box.tscn")
var sledge_hammer: PackedScene = preload("res://Scenes/Weapons/sledge_hammer.tscn")
var thorn_blade: PackedScene = preload("res://Scenes/Weapons/thorn_blade.tscn")
var sword: PackedScene = preload("res://Scenes/Weapons/mighty_sword.tscn")
var double_bladed_sword: PackedScene = preload("res://Scenes/Weapons/double_bladed_sword.tscn")
var laser_sword: PackedScene = preload("res://Scenes/Weapons/laser_sword.tscn")

func _ready() -> void:
	create_bags()
	create_weapons()
	create_shoes()



func create_bags() -> void:
	# Making the objects and putting them into the array, there must be an easier way to do this...
	var basic_bag = buyable.new("BasicBag", "bag", 0, null, 15, 0)
	basic_bag.buy()
	basic_bag.equip()
	bag_set.append(basic_bag)
	var bbb = buyable.new("BBB", "bag", 30, null, 35, 0)
	bag_set.append(bbb)
	var backpack = buyable.new("Backpack", "bag", 70, null, 85, 0)
	bag_set.append(backpack)
	var dufflebag = buyable.new("Dufflebag", "bag", 125, null, 150, 0)
	bag_set.append(dufflebag)
	var santa_bag = buyable.new("SantaBag", "bag", 200, null, 300, 0)
	bag_set.append(santa_bag)
	var purse = buyable.new("Purse", "bag", 450, null, 999, 0)
	bag_set.append(purse)
	GameManager.equipped_bag = basic_bag # At the start of the game, the basic bag will be the first item we have

func create_weapons() -> void:
	var _stick = buyable.new("Stick", "weapon", 0, stick, 0, 0)
	_stick.buy()
	_stick.equip()
	weapon_set.append(_stick)
	var sledgehammer = buyable.new("Sledgehammer", "weapon", 25, sledge_hammer, 0, 0)
	weapon_set.append(sledgehammer)
	var thornblade = buyable.new("ThornBlade", "weapon", 50, sledge_hammer, 0, 0)
	weapon_set.append(thornblade)
	var _sword = buyable.new("Sword", "weapon", 90, sword, 0, 0)
	weapon_set.append(_sword)
	var doublebladedsword = buyable.new("DoubleBladedSword", "weapon", 125, double_bladed_sword, 0, 0)
	weapon_set.append(doublebladedsword)
	var lasersword = buyable.new("LaserSword", "weapon", 200, laser_sword, 0, 0)
	weapon_set.append(lasersword)
	GameManager.equipped_weapon = _stick

func create_shoes() -> void:
	var worn_out_shoes = buyable.new("WornOutShoes", "shoes", 0, null, 0, 50.0)
	worn_out_shoes.buy()
	worn_out_shoes.equip()
	shoes_set.append(worn_out_shoes)
	var burglar_ones = buyable.new("BurglarShoes", "shoes", 50, null, 0, 75.0)
	shoes_set.append(burglar_ones)
	var running_shoes = buyable.new("RunningShoes", "shoes", 150, null, 0, 100.0)
	shoes_set.append(running_shoes)
	var hedgehog_shoes = buyable.new("HedgehogShoes", "shoes", 300, null, 0, 175.0)
	shoes_set.append(hedgehog_shoes)
	GameManager.equipped_shoes = worn_out_shoes
