extends Node

signal connected
var _connected: bool = false

enum InitStatus {
  STEAMWORKS_ACTIVE = 0,
  FAILED = 1,
  CANNOT_CONNECT = 2,
  OUT_OF_DATE = 3,
}

var STATUS_STRINGS = {
  InitStatus.STEAMWORKS_ACTIVE: tr("steamworks_connect_active"),
  InitStatus.FAILED: tr("steamworks_connect_failed"),
  InitStatus.CANNOT_CONNECT: tr("steamworks_connect_unable"),
  InitStatus.OUT_OF_DATE: tr("steamworks_connect_out_of_date"),
}

func _ready():
  # 480 demo app
  # 1623730 palworld
  var resp = Steam.steamInitEx(480, true)
  var status: InitStatus = InitStatus[InitStatus.find_key(resp.status)]
  var s = STATUS_STRINGS[status]
  print("[Steamworks] %s" % s)
  if status == InitStatus.STEAMWORKS_ACTIVE:
    _connected = true
    connected.emit()

func on_ready(cb: Callable):
  if _connected:
    cb.call()
  else:
    connected.connect(cb)
