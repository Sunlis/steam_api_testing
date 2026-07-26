@tool

extends MarginContainer

@onready var _avatar: TextureRect = %avatar
@onready var _username: Label = %username
@onready var _status: Label = %status

@export var avatar_image: Image
@export var username: String
@export var status: String

func _update():
  if not is_inside_tree():
    return
  _avatar.texture = ImageTexture.create_from_image(avatar_image)
  _username.text = username
  _status.text = status
