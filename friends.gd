extends Node

signal friend_list_changed
signal friend_info_changed(id: int, info: UserInfo)

class UserInfo:
  var steam_id: int = -1
  var persona_name: String = ""
  var online: bool = false
  var game_played: int = -1
  var avatar: Image = null

  func _init(id: int):
    self.steam_id = id

  func _to_string() -> String:
    return "{UserInfo %d %s %s %d}" % [steam_id, persona_name, online, game_played]

var _friend_count: int = -1
var _user_info = {}
var _friends = Set.new()

func _ready():
  Steam.persona_state_change.connect(_persona_state_change)
  Steam.avatar_loaded.connect(_avatar_loaded)
  var count = self.get_friend_count()
  print("Friend count %d" % count)
  var friend_ids = []
  for i in range(count):
    var steam_id = Steam.getFriendByIndex(i, Steam.FriendFlags.FRIEND_FLAG_IMMEDIATE)
    friend_ids.append(steam_id)
    Steam.requestUserInformation(steam_id, false)
  print("friends: ", friend_ids)

func _avatar_loaded(id: int, width: int, data: PackedByteArray):
  var image = Image.create_from_data(width, width, false, Image.FORMAT_RGBA8, data)
  if not id in _user_info:
    _user_info[id] = UserInfo.new(id)
  var info = _user_info[id]
  info.avatar = image
  friend_info_changed.emit(id, info)

func _persona_state_change(id: int, flags: Steam.PersonaChange):
  if not id in _user_info:
    _user_info[id] = UserInfo.new(id)
  var info = _user_info[id]
  if Steam.getFriendRelationship(id) == Steam.FriendRelationship.FRIEND_RELATION_FRIEND:
    _friends.add(info)
    friend_list_changed.emit()
  
  # https://godotsteam.com/classes/friends/#personachange
  info.persona_name = Steam.getFriendPersonaName(id)
  info.online = Steam.getFriendPersonaState(id) != Steam.PersonaState.PERSONA_STATE_OFFLINE
  var game = Steam.getFriendGamePlayed(id)
  if game:
    info.game_played = game.id
  else:
    info.game_played = -1
  friend_info_changed.emit(id, info)
  if flags & Steam.PersonaChange.PERSONA_CHANGE_AVATAR:
    # 1 == small size
    Steam.getPlayerAvatar(1, id)
  print("state change %s" % info)

func get_friend_count():
  if _friend_count == -1:
    _friend_count = Steam.getFriendCount()
  return _friend_count

func clear_cache():
  _friend_count = -1
  _user_info = {}
  _friends.clear()
  friend_list_changed.emit()

func get_friends_list() -> Set:
  return _friends

func get_friend_by_id(id: int) -> UserInfo:
  return _user_info[id]