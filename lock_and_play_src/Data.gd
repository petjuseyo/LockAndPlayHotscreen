extends RefCounted
class_name Data


################################################################################
## SIGNAL BUS
################################################################################

class _SignalBus_class extends RefCounted:
	signal _lock_started()
	signal _lock_paused()
	signal _lock_resumed()
	signal _lock_ended()
	signal _lock_time_changed(action: Dictionary)
	signal _game_started(action: Dictionary)
	signal _game_ended(action: Dictionary)
	signal _collection_enabled(action: Dictionary)
	signal _collection_disabled(action: Dictionary)
	signal _collection_level_up(action: Dictionary)
	signal _collection_level_down(action: Dictionary)
	signal _countdown_revealed(action: Dictionary)
	signal _countdown_hidden(action: Dictionary)
	
static var _SignalBus_instance := _SignalBus_class.new()

# lock cycle
static var lock_started = _SignalBus_instance._lock_started
static var lock_paused = _SignalBus_instance._lock_paused
static var lock_resumed = _SignalBus_instance._lock_resumed
static var lock_ended = _SignalBus_instance._lock_ended
# lock actions
static var lock_time_changed = _SignalBus_instance._lock_time_changed
static var game_started := _SignalBus_instance._game_started
static var game_ended := _SignalBus_instance._game_ended
static var collection_enabled = _SignalBus_instance._collection_enabled
static var collection_disabled = _SignalBus_instance._collection_disabled
static var collection_level_up = _SignalBus_instance._collection_level_up
static var collection_level_down = _SignalBus_instance._collection_level_down
static var countdown_revealed = _SignalBus_instance._countdown_revealed
static var countdown_hidden = _SignalBus_instance._countdown_hidden


################################################################################
## ACTIONS DEFINITIONS
################################################################################

# Enum class for Actions. Can't be accessed directly outside Data
class EnumActions:
	# provide access outside Data
	
	## ACTION
	const ADD_TIME: int = 0
	const REMOVE_TIME: int = 1
	const ENABLE_COLLECTION: int = 2
	const DISABLE_COLLECTION: int = 3
	const TOGGLE_COLLECTION: int = 4
	const TOGGLE_COLLECTION_RANDOM: int = 5
	const SHOW_LOCK_TIME: int = 6
	const HIDE_LOCK_TIME: int = 7
	const TOGGLE_LOCK_TIME_VISIBILITY: int = 8
	const LEVEL_UP: int = 9
	const LEVEL_DOWN: int = 10
	const FREEZE_LOCK: int = 11
	const UNFREEZE_LOCK: int = 12
	const TOGGLE_FREEZE: int = 13
	const OS_COMMAND: int = 14
	const OS_COMMAND_NEW_PROCESS: int = 15
	# TODO ADD_MONEY_PAYWALL integration
	
	## ARG_TYPE
	const ARG_TYPE_NONE: int = 0
	const ARG_TYPE_INT: int = 1 # unused for now
	const ARG_TYPE_DURATION: int = 2 # also a int value in sec
	const ARG_TYPE_STRING: int = 3
	const ARG_TYPE_COLLECTION: int = 4 # also a string
	
	## ORIGIN
	const ORIGIN_NONE: int = 0 # aka UNKNOWN useful for debug or direct manipulation
	const ORIGIN_DICE_GAME: int = 1
	const ORIGIN_DICE_PENALTIES: int = 2
	const ORIGIN_WOF_GAME: int = 3
	const ORIGIN_WOF_PENALTIES: int = 4
	
	var add_time: Dictionary:
		get:
			return {
				"type": ADD_TIME,
				"name": "Add time",
				"tooltip": "",
				"arg": 0,
				"arg_type": ARG_TYPE_DURATION,
				"origin": ORIGIN_NONE,
			}
	var remove_time: Dictionary:
		get:
			return {
				"type": REMOVE_TIME,
				"name": "Remove time",
				"tooltip": "",
				"arg": 0,
				"arg_type": ARG_TYPE_DURATION,
			}
	var enable_collection: Dictionary:
		get:
			return {
				"type": ENABLE_COLLECTION,
				"name": "Enable collection",
				"placeholder": "collection name 1;collection name 2",
				"tooltip": "Type the name of the collections you want enabled. You can separate collections with a semicolon ;",
				"arg": "",
				"arg_type": ARG_TYPE_COLLECTION,
			}
	var disable_collection: Dictionary:
		get:
			return {
				"type": DISABLE_COLLECTION,
				"name": "Disable collection",
				"placeholder": "collection name 1;collection name 2",
				"tooltip": "Type the name of the collections you want disabled. You can separate collections with a semicolon ;",
				"arg": "",
				"arg_type": ARG_TYPE_COLLECTION,
			}
	var toggle_collection: Dictionary:
		get:
			return {
				"type": TOGGLE_COLLECTION,
				"name": "Toggle collection",
				"placeholder": "collection name 1;collection name 2",
				"tooltip": "Type the name of the collections you want toggled on/off. You can separate collections with a semicolon ;",
				"arg": "",
				"arg_type": ARG_TYPE_COLLECTION,
			}
	var toggle_collection_random: Dictionary: 
		get:
			return {
				"type": TOGGLE_COLLECTION_RANDOM,
				"name": "Toggle random collection",
				"placeholder": "collection name 1;collection name 2",
				"tooltip": "A random collection will be selected and toggled on/off. You can separate collections with a semicolon ;",
				"arg": "",
				"arg_type": ARG_TYPE_COLLECTION,
			}
	var show_lock_time: Dictionary:
		get:
			return {
				"type": SHOW_LOCK_TIME,
				"name": "Show lock time",
				"arg": null,
				"arg_type": ARG_TYPE_NONE,
			}
	var hide_lock_time: Dictionary:
		get:
			return {
				"type": HIDE_LOCK_TIME,
				"name": "Hide lock time",
				"tooltip": "⚠︎ Make sure you have a way to unhide the countdown, otherwise you risk being stuck with an invisible countdown!",
				"tooltip_color": "coral",
				"arg": null,
				"arg_type": ARG_TYPE_NONE,
			}
	var toggle_lock_time_visibility: Dictionary:
		get:
			return {
				"type": TOGGLE_LOCK_TIME_VISIBILITY,
				"name": "Toggle lock time visibility",
				"arg": null,
				"arg_type": ARG_TYPE_NONE,
			}
	var level_up: Dictionary:
		get:
			return {
				"type": LEVEL_UP,
				"name": "Level up collection",
				"placeholder": "collection name 1;collection name 2",
				"tooltip": "Type the name of the collections you want to level up. You can separate collections with a semicolon ;",
				"arg": "",
				"arg_type": ARG_TYPE_COLLECTION,
			}
	var level_down: Dictionary:
		get:
			return {
				"type": LEVEL_DOWN,
				"name": "Level down collection",
				"placeholder": "collection name 1;collection name 2",
				"tooltip": "Type the name of the collections you want to level down. You can separate collections with a semicolon ;",
				"arg": "",
				"arg_type": ARG_TYPE_COLLECTION,
			}
	var freeze_lock: Dictionary:
		get:
			return {
				"type": FREEZE_LOCK,
				"name": "Freeze the lock",
				"tooltip": "⚠︎ Make sure you have a way to unfreeze yourself, otherwise you risk being frozen indefinitely!",
				"tooltip_color": "coral",
				"arg": null,
				"arg_type": ARG_TYPE_NONE,
			}
	var unfreeze_lock: Dictionary:
		get:
			return {
				"type": UNFREEZE_LOCK,
				"name": "Unfreeze the lock",
				"tooltip": "",
				"arg": null,
				"arg_type": ARG_TYPE_NONE,
			}
	var toggle_freeze: Dictionary:
		get:
			return {
				"type": TOGGLE_FREEZE,
				"name": "Toggle freeze",
				"tooltip": "",
				"arg": null,
				"arg_type": ARG_TYPE_NONE,
			}
	var os_command: Dictionary:
		get:
			return {
				"type": OS_COMMAND,
				"name": "OS command (same process)",
				"placeholder": 'python.exe "C:\\Users\\yourname\\EdgewarePlusPlus\\edgeware\\edgeware.pyw"',
				"tooltip": 
					"Will execute the command specified in a blocking way: Hotscreen will be blocked until the executed command terminates.\n\
					Your command shouldn't expect user input as no terminal window will be opened to type in.\n\
					Errors will be logged (check the mod's /logs). Use this to test your command if it doesn't work.\n\
					⚠︎ Make sure to know what you're doing and don't copy paste commands if you don't understand what it's doing!",
				"tooltip_color": "coral",
				"arg": "",
				"arg_type": ARG_TYPE_STRING,
			}
	var os_command_new_process: Dictionary:
		get:
			return {
				"type": OS_COMMAND_NEW_PROCESS,
				"name": "OS command (new process)",
				"placeholder": 'python.exe "C:\\Users\\yourname\\EdgewarePlusPlus\\edgeware\\edgeware.pyw"',
				"tooltip": 
					"Will execute the command specified in a new process that runs independently of Hotscreen.\n\
					Your command shouldn't expect user input as no terminal window will be opened to type in.\n\
					⚠︎ Make sure to know what you're doing and don't copy paste commands if you don't understand what it's doing!",
				"tooltip_color": "coral",
				"arg": "",
				"arg_type": ARG_TYPE_STRING,
			}
			

# Provide access to Action Enum from outside Data
static var Action = EnumActions.new()

static var actions_preset = { 
	"dice": [
		Action.add_time,
		Action.remove_time,
		Action.enable_collection,
		Action.disable_collection,
		Action.toggle_collection,
		Action.toggle_collection_random,
		Action.level_up,
		Action.level_down,
		Action.show_lock_time,
		Action.hide_lock_time,
		Action.toggle_lock_time_visibility,
		#Action.freeze_lock,
		#Action.unfreeze_lock,
		#Action.toggle_freeze,
		#Action.os_command,
		#Action.os_command_new_process,
	]
}

################################################################################
## WINDOW MODE
################################################################################

class EnumWindowMode:
	enum Mode {
		MODE_CONFIG,
		MODE_GAME,
	}
static var WINDOW_MODE_CONFIG:EnumWindowMode.Mode = EnumWindowMode.Mode.MODE_CONFIG
static var WINDOW_MODE_GAME:EnumWindowMode.Mode = EnumWindowMode.Mode.MODE_GAME


class EnumBuildType:
	enum Type {
		BUILD_RELEASE,
		BUILD_DEBUG,
	}
static var BUILD_RELEASE:EnumBuildType.Type = EnumBuildType.Type.BUILD_RELEASE
static var BUILD_DEBUG:EnumBuildType.Type = EnumBuildType.Type.BUILD_DEBUG

################################################################################
## CONFIG & GAMES DATA
################################################################################

static var app_info := {
	"name": "Lock And Play Mod",
	"id": "LockAndPlayHS",
	"mod_src_path": "lock_and_play_src",
	"version": "0.1",
	"author": "juseyo",
	"build": BUILD_RELEASE,
	"logging": true, # create logs file
	"print_logs": true, # prints logs in console
}

# common data for lock and not specific to a game
static var lock_data := {
	"countdown_visible": true,
}

static var games := {
	"dice": {
		"id": "dice",
		"icon": "🎲",
		"name": "Dice",
		"desc": "Roll the dice and try to reduce your time locked",
		"enabled": true,
		"game_scene": "DiceGame.tscn",
		#"config_path": "./CUSTOM_DATA/modsdev/LockAndPlayHS/DiceConfigPanel.tscn",
		#"config_path": resolve_scene_path("DiceConfigPanel.tscn"),
		"config_scene": "DiceConfigPanel.tscn",
		"config_data": {
			"window_size": [750, 700], 
			# The difference between the two dice will be multiplied by this time (in seconds)
			"time_mult": 60,
			# max allowed amount of days for `time_mult` (in days)
			"time_mult_max_days": 7,
			# After using the extension, you will have to wait this duration before using it again (in seconds)
			"wait_time": 0,
			# Penalties
			"runs_count_required": 0, # how many launches are needed
			"regularity": 0, # hold the duration of a cycle
			"punishment": [], # [{type, arg, arg_type}]
		},
		"game_data": {
			"window_size": [600, 350],
			# list of timestamps each time the game was run this locked session. resets after exiting lock.
			"runs_timestamps": [], 
			"cycle_start_time": 0, # used for penalties, hold the timestamp of the start of a cycle
			"cycle_end_time": 0, # used for penalties, hold the timestamp of the end of a cycle
		},
	},
	#"wof": {
		#"id": "wof",
		#"icon": "🛞",
		#"name": "Wheel Of Fortune",
		#"desc": "Try your luck by spinning the Wheel of Fortune - coming soon!",
		#"enabled": false,
		#"game_scene": "EmptyConfigPanel.tscn",
		#"config_scene": "EmptyConfigPanel.tscn",
		#"config_data": {
			#
		#},
	#},
}
