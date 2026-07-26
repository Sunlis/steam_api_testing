extends MarginContainer

const player_scene = preload("res://player.tscn")

@onready var player_container: Control = %player_container

func _ready():
  Steamworks.on_ready(_steamworks_ready)
  Friends.friend_list_changed.connect(_reset_friend_list)
  Friends.friend_info_changed.connect(_friend_info_changed)

func _steamworks_ready():
  _reset_friend_list()

var _friend_items = {}

func _reset_friend_list():
  print("friends list reset")
  for c in player_container.get_children():
    c.queue_free()
  
  var list = Friends.get_friends_list()
  print("friend list: ", list.to_array())
  for friend in list:
    var item = player_scene.instantiate()
    _friend_items[friend.steam_id] = item
    player_container.add_child(item)
    _friend_info_changed(friend.steam_id, friend)

func _friend_info_changed(id: int, info: Friends.UserInfo):
  # var info = Friends.get_friend_by_id(id)
  if not id in _friend_items:
    return
  var item = _friend_items[id]
  if info.avatar != null:
    item.avatar_image = info.avatar
  item.username = info.persona_name
  item.status = "online" if info.online else "offline"
