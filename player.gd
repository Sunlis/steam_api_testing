@tool

extends MarginContainer

@onready var _avatar: TextureRect = %avatar
@onready var _username: Label = %username
@onready var _status: Label = %status
@onready var _game: Label = %game

@export var avatar_image: Image = null:
  set(v):
    avatar_image = v
    _update()
@export var username: String = "":
  set(v):
    username = v
    _update()
@export var online: bool = false:
  set(v):
    online = v
    _update()
@export var game_name: String = "":
  set(v):
    game_name = v
    _update()

func _ready():
  _update()

func _update():
  if not is_inside_tree():
    return
  if avatar_image:
    _avatar.texture = ImageTexture.create_from_image(avatar_image)
  _username.text = username
  _status.text = "online" if online else "offline"
  _game.text = game_name
