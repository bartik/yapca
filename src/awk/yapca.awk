#!/usr/bin/awk

##
# @brief Parse configuration
#
# Initializing the script parameters
#
# @param	section		defines the section of ini file which is processed
# @param	settings	the ini section name from which the settings are read
# @param	s					command line parameter holding the value of settings
# @param	p					command line parameter holding the value of CA root
#
# @section begin_block The BEGIN block
#
BEGIN {
	section = ""
	settings = ""
	certroot = ""
	if (length(s) > 0) {
		settings = s
	}
	if (length(p) > 0) {
		certroot = p
	}
}

##
# @brief Parse configuration
#
# The first file supplied on awk command line must be the ini/configuration
# file. FNR==NR is true for the first file. Store the configuration in the
# config[] array. Empty spaces in the key are deleted. Trailing spaces are 
# removed. Empty lines and lines which begin with # (after trimmed as stated
# before) are not stored in the config[] array.
#
FNR == NR {
	if ($0 !~ /^[[:blank:]]*#/) {
		tmpLine = $0
		gsub(/^[[:blank:]]+/, "", tmpLine)
		gsub(/[[:blank:]]+$/, "", tmpLine)
		if (length(tmpLine) > 1) {
			gsub(/#.*$/, "", tmpLine)
			len = split(tmpLine, iniLine, "=")
			if (iniLine[1] ~ /^\[/) {
				section = iniLine[1]
				gsub("\\[", "", section)
				gsub("\\]", "", section)
			} else {
				key = iniLine[1]
				gsub(/[[:blank:]]+/, "", key)
				val = iniLine[2]
				for (j = 3; j <= len; j++) {
					val = val "=" iniLine[j]
				}
				if (length(k) > 1 && section == s && key == k) {
					printf "%s\n", val
					exit 0
				} else {
					config[section "|" key] = val
				}
			}
		}
	}
	next
}

/__[[:alnum:]\.]+__/ {
	for (key in config) {
		split(key, ikey, "|")
		t = "__" ikey[2] "__"
		if (length(certroot) > 0 && ikey[2] == "dir") {
			gsub(t, certroot, $0)
		} else if (ikey[1] == settings) {
			gsub(t, config[key], $0)
		}
	}
	if ($0 !~ /__[[:alnum:]\.]+__/) {
		print $0
	}
	next
}

{
	print $0
}

