extends Node

var energy:int = 0
var energy_bonus:int = 0

var cell_positions:Array = []

var mitochondria:int = 0

var mitochondriaPrice:int = 500
var sb:Dictionary = {
	"1": 15,
	"2": 150,
	"3": 800,
	"4": 4000,
	"5": 15_000,
}
var formulas:Array = []
var components:Dictionary = {
	"O": 0,
	"NH": 0,
	"CR3": 0,
	"N": 0,
	"OH": 0,
	"F": 0,
	"HN": 0,
	"CH3": 0,
	"S": 0,
	"NH2": 0,
	"CL": 0,
	"F3C": 0,
}

var crafting:Dictionary = {
	"VEGF": [],
	"Glucagon": [],
	"Interferon": [],
	"Histamine": [],
	"TNF-alpha": [],
	"Insulin": [],
}

var canCraft:bool = true
