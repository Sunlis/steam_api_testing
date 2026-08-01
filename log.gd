extends Node

class_name Log

var _label: String

func _init(label: String):
  _label = label

func print(message: String):
  print("[%s] %s" % [_label, message])
