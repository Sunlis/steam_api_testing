extends MarginContainer

func _ready():
  Steamworks.on_ready(_steamworks_ready)

func _steamworks_ready():
  print("Persona: %s" % Steam.getPersonaName())
  print("Steam ID: %d" % Steam.getSteamID())
