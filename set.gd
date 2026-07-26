extends RefCounted

class_name Set

var _count = 0
var _values = {}

func insert(v):
  if not _values.has(v):
    _count += 1
  _values[v] = true
  return self

func add(v):
  return insert(v)

func remove(v):
  if _values.has(v):
    _count -= 1
  _values.erase(v)
  return self

func has(v):
  return _values.has(v) and _values[v] == true

func clear():
  _values = {}
  _count = 0

func size():
  return _count

func get_at(index):
  return _values.keys()[index]

func to_array():
  var out = []
  for i in self:
    out.append(i)
  return out

# https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_advanced.html#custom-iterators

func _should_continue(current):
  return current < size()

func _iter_init(iter):
  iter[0] = 0
  return _should_continue(iter[0])

func _iter_next(iter):
  iter[0] += 1
  return _should_continue(iter[0])

func _iter_get(iter):
  return get_at(iter)
