extends Node

var _autoload_params = null

func set_params(params):
	_autoload_params = params

func get_params():
	var params = _autoload_params
	_autoload_params = null
	return params
