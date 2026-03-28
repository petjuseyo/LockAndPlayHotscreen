extends RefCounted
class_name Utils 

static var Data = preload("Data.gd")


static var relative_mod_path := ""
static var absolute_mod_path := ""

#static var _logging: Logging = null
#static var logging: Logging = null :
	#get: 
		#if not _logging :
			#_logging = Logging.new(relative_mod_path, Data.app_info.logging, Data.app_info.print_logs)
		#return _logging
static var logging: Logging = null

##
## Called only once to init things that require a tree node, like
## relative_mod_path and absolute_mod_path, and make them accessible statically.
##
static func init(node: Node) -> void:
		
	if not logging :
		logging = Logging.new(
			Data.app_info.logging,
			Data.app_info.print_logs,
			Data.app_info.build == Data.BUILD_DEBUG
		)
		
	if node == null:
		return
		
	if node.scene_file_path.is_empty():
		logerror("node.scene_file_path is empty. Try calling this function after _init, in _ready for example.")
		return
		
	if relative_mod_path.is_empty() or absolute_mod_path.is_empty():
		_fill_mod_path(node)
		
	logging.create_new_log_file(relative_mod_path)


##
## Fills absolute_mod_path and relative_mod_path.
##
static func _fill_mod_path(node: Node):
	var _relative_mod_path = node.scene_file_path.get_base_dir()
	if _relative_mod_path.is_empty():
		return
		
	if _relative_mod_path.begins_with("res://"):
		_relative_mod_path = _relative_mod_path.lstrip("res://")
	
	absolute_mod_path = OS.get_executable_path().get_base_dir().path_join(_relative_mod_path)
	relative_mod_path = "./".path_join(_relative_mod_path)


################################################################################
## Error Handling
################################################################################


static func loginfo(msg: Variant):
	if logging:
		logging.info(msg)

static func logdebug(msg: Variant):
	if logging:
		logging.debug(msg)
		
static func logerror(msg: Variant):
	if logging:
		logging.err(msg)


################################################################################
## Mod Path Helpers
################################################################################


## cache results
static var __cached_scene_path = {}

##
## Dynamic scene path finding
##
static func resolve_scene_path(scene_path:String) -> String:
	if __cached_scene_path.has(scene_path):
		return __cached_scene_path.get(scene_path)
		
	var search_path_root = "./CUSTOM_DATA/"
	if not relative_mod_path.is_empty():
		search_path_root = relative_mod_path
	var mod_src_path = find_folder_path(Data.app_info.mod_src_path, search_path_root)
	var full_scene_path = mod_src_path.path_join(scene_path)
	
	__cached_scene_path.set(scene_path, full_scene_path)
	return full_scene_path


static func find_folder_path(matching:String, current_path:String="./CUSTOM_DATA/") -> String:
	var found_path := ""
	var dir = DirAccess.open(current_path)
	if dir:
		for sub in dir.get_directories():
			if sub == matching:
				return current_path.path_join(sub)
			else:
				found_path = find_folder_path(matching, current_path.path_join(sub))
				if found_path != "":
					return found_path
	else:
		logdebug("An error occurred when trying to access the path.")
	return found_path


################################################################################
## Time Helpers
################################################################################


static func time_to_seconds(days: int, hours: int, minutes: int) -> int:
	days = max(days, 0)
	hours = clamp(hours, 0, 23)
	minutes = clamp(minutes, 0, 59)

	return (days * 86400) + (hours * 3600) + (minutes * 60)

static func seconds_to_dhm(total_seconds: int) -> Dictionary:
	total_seconds = max(total_seconds, 0)

	var days := total_seconds / 86400
	var remainder := total_seconds % 86400

	var hours := remainder / 3600
	remainder = remainder % 3600

	var minutes := remainder / 60
	remainder = remainder % 60

	var seconds := remainder

	return {
		"days": days,
		"hours": hours,
		"minutes": minutes,
		"seconds": seconds
	}

# Format the given time in a human readable format: days, hours, minutes
static func format_time_from_dhm(time: Dictionary, incl_seconds: bool = false) -> String:
	var result := ""
	if time.days > 0:
		var plural = "days" if time.days > 1 else "day"
		result = "%s %s" % [str(time.days), plural]
	if time.hours > 0:
		var plural = "hours" if time.hours > 1 else "hour"
		result = "%s %s %s" % [result, str(time.hours), plural]
	if time.minutes > 0:
		var plural = "minutes" if time.minutes > 1 else "minute"
		result = "%s %s %s" % [result, str(time.minutes), plural]
	if incl_seconds and time.seconds > 0:
		result = "%s %s seconds" % [result, str(time.seconds)]
		
	# set a short default value in case it's empty
	if result.is_empty():
		result = "0 minutes"
	
	# removes possible space at the start of the string
	return result.strip_edges()


# Format the given time in a human readable format: days, hours, minutes
static func format_time_from_seconds(seconds: int, incl_seconds: bool = false) -> String:
	return format_time_from_dhm(seconds_to_dhm(seconds), incl_seconds)


################################################################################
## Misc
################################################################################

# Returns escaped BBCode that won't be parsed by RichTextLabel as tags.
static func escape_bbcode(bbcode_text):
	# We only need to replace opening brackets to prevent tags from being parsed.
	return bbcode_text.replace("[", "[lb]")


#static var _logs_timestamp: float = 0.0
#static var _logs_filename: String = ""
#const DEFAULT_LOGS_FILENAME := "lockandplay_{0}_{1}.log"
#static func logmessage(message: Variant) -> void:
	#
	#if _logs_filename.is_empty():
		#var profile = "main"
		#if HS.profile_id != -1:
			#profile = "profile_%s" % [str(HS.profile_id)]
	#
		#_logs_filename = DEFAULT_LOGS_FILENAME.format([
			#profile, Time.get_datetime_string_from_unix_time(_logs_timestamp)
		#]).validate_filename()
	#
	#var logs_dir = relative_mod_path.path_join("logs")
	#
	#if not DirAccess.dir_exists_absolute(logs_dir):
		#var error = DirAccess.make_dir_recursive_absolute(logs_dir)
		#if error:
			#print("[LockAndPlay] Error creating logs directory")
			#return
	#
	#var full_export_path := logs_dir.path_join(_logs_filename)
	#
	#var file = null
	#if FileAccess.file_exists(full_export_path):
		#file = FileAccess.open(full_export_path, FileAccess.READ_WRITE)
	#else:
		#file = FileAccess.open(full_export_path, FileAccess.WRITE)
	#
	#if not file:
		#var error = FileAccess.get_open_error()
		#print("[LockAndPlay] Error '%s' while trying to open the logs file" % [error])
		#
	#var now = Time.get_datetime_string_from_system()
		#
	#file.seek_end()
	#file.store_line(message)
	#file.close()


################################################################################
## Logging class
################################################################################


class Logging extends RefCounted:
	
	const DEFAULT_LOGS_FOLDER := "logs"
	const DEFAULT_LOGS_FILENAME := "lockandplay_{0}_{1}.log"
	
	const ENTRY_FORMAT := "[%s] %s - %s"
	
	const MAX_FLUSH_INTERVAL_SECONDS: float = 2.0
	var _last_sync: float = 0.0
	var _elapsed_time: float = 0.0
	
	const MAX_FLUSH_INTERVAL_MESSAGES: int = 10
	var _message_count: int = 0
	
	var file: FileAccess = null
	var filename: String = ""
	var full_file_path: String = ""
	var folder_path: String = ""
	var entries_backlog := []
	
	# enable logging
	var enabled: bool = true
	# enable printing
	var print_logs: bool = false
	# is a debug build (debug logs won't be treated if not)
	var debug_build: bool = false
	
	func _init(_enabled=true, _print_logs=false, _debug_build=false) -> void:
		enabled = _enabled
		print_logs = _print_logs
		debug_build = _debug_build
		_last_sync = Time.get_unix_time_from_system()
	
	func create_new_log_file(_dir_path: String):
		if enabled and not _dir_path.is_empty():
			folder_path = _dir_path.path_join(DEFAULT_LOGS_FOLDER)
			make_dir_if_not_exist()
			filename = make_filename()
			full_file_path = folder_path.path_join(filename)
			open_file()
	
	func make_dir_if_not_exist():
		if not DirAccess.dir_exists_absolute(folder_path):
			var error = DirAccess.make_dir_recursive_absolute(folder_path)
			if error:
				print("[LockAndPlay] Error creating logs directory")
				return
		
	func make_filename():
		var profile = "main"
		if HS.profile_id != -1:
			profile = "profile_%s" % [str(HS.profile_id)]
	
		return DEFAULT_LOGS_FILENAME.format([
			profile, Time.get_datetime_string_from_system()
		]).validate_filename()
		
		
	func open_file():
		if file and file.is_open():
			file.close()
		
		if FileAccess.file_exists(full_file_path):
			file = FileAccess.open(full_file_path, FileAccess.READ_WRITE)
			file.seek_end()
		else:
			file = FileAccess.open(full_file_path, FileAccess.WRITE)
		
		if not file:
			var error = FileAccess.get_open_error()
			print("[LockAndPlay] Error '%s' while trying to open the logs file" % [error])
			return
			
		# write logs if any were added while the file wasn't open (before init)
		var i = entries_backlog.size()
		while i > 0:
			var entry = entries_backlog.pop_front()
			_write(entry.message, entry.severity)
			i -= 1
	
	func _write(entry, severity="INFO"):
		if file and file.is_open():
			var formatted_entry = format_entry(entry, severity)
			file.store_line(formatted_entry)
			flush()
			_message_count += 1
		else:
			entries_backlog.append({ "message": entry, "severity": severity })
			
	func format_entry(entry, severity="INFO"):
		return ENTRY_FORMAT % [severity, Time.get_time_string_from_system(), str(entry)]
			
	func format_message(entry, severity="INFO"):
		return ENTRY_FORMAT % [severity, Time.get_time_string_from_system(), str(entry)]
		
	func info(entry):
		if print_logs:
			print(format_message(entry, "INFO"))
		if enabled:
			_write(entry, "INFO")
		
	func debug(entry):
		# do not log or print if not a debug build
		if not debug_build:
			return
		if print_logs:
			print(format_message(entry, "DEBUG"))
		if enabled:
			_write(entry, "DEBUG")
		
	func warn(entry):
		if print_logs:
			print(format_message(entry, "WARNING"))
		if enabled:
			_write(entry, "WARNING")
		
	func err(entry):
		if print_logs:
			print(format_message(entry, "ERROR"))
		if enabled:
			_write(entry, "ERROR")
		
	func flush():
		if not file:
			return
		
		var now := Time.get_unix_time_from_system()
		_elapsed_time += now - _last_sync
		_last_sync = now
		if _elapsed_time >= MAX_FLUSH_INTERVAL_SECONDS:
			_elapsed_time = 0.0
			file.flush()
		elif _message_count % MAX_FLUSH_INTERVAL_MESSAGES == 0:
			file.flush()
	
	func close():
		if file and file.is_open():
			file.close()
