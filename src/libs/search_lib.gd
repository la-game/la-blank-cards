class_name SearchLib
extends RefCounted


# Returns true if string contains any of the texts.
static func any_text_in_string(texts: PackedStringArray, string: String) -> bool:
	for text in texts:
		if text in string:
			return true
	return false


# Returns true if any of the strings contains any of the texts.
static func any_text_in_strings(texts: PackedStringArray, strings: Array[String]) -> bool:
	for string in strings:
		if any_text_in_string(texts, string):
			return true
	return false
