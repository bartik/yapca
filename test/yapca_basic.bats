setup() {
	load 'test_helper/bats-support/load'
	load 'test_helper/bats-assert/load'
	# get the containing directory of this file
	# use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
	# as those will point to the bats executable's location or the preprocessed file respectively
	DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
	# make executables in src/ visible to PATH
	PATH="$DIR/../src:$PATH"
}

# bats file_tags=yapca:basic

# bats test_tags=yapca:positive,yapca:BASIC-P001
@test "BASIC-P001: Can be run." {
	run yapca.sh -h
	assert_success
	assert_line --partial 'parse_commandline(): exit 0'
	refute_line --partial 'ERROR'
}

# bats test_tags=yapca:positive,yapca:BASIC-P002
@test "BASIC-P002: Can be run with correct help output." {
	run yapca.sh -h
	assert_success
	assert_line --partial '-h, --help: Prints help'
	refute_line --partial 'ERROR'
}

# bats test_tags=yapca:negative,yapca:BASIC-N001
@test "BASIC-N001: Fails withoud parameters." {
	run yapca.sh
	assert_failure 101
	assert_line --partial 'FATAL ERROR: Not enough positional arguments - we require exactly 1'
}
