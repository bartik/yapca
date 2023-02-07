setup() {
	load 'test_helper/bats-support/load'
	load 'test_helper/bats-assert/load'
	# get the containing directory of this file
	# use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
	# as those will point to the bats executable's location or the preprocessed file respectively
	DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
	# make executables in src/ visible to PATH
	PATH="$DIR/../src:$PATH"
	# export master password file path+name
	export YAPCA_MASTERPASS_FILE="$DIR/../.bats.masterpass"
	# backup the test ini file
	cp "$DIR/../src/ini/yapca.ini" "$DIR/../src/ini/yapca.bats"
}

teardown() {
	rm -f "$DIR/../src/ini/yapca.ini"
	rm -f "$DIR/../src/ini/yapca.bak"
	mv "$DIR/../src/ini/yapca.bats" "$DIR/../src/ini/yapca.ini"
	rm -f "${YAPCA_MASTERPASS_FILE}"
	unset YAPCA_MASTERPASS_FILE
}

# bats file_tags=yapca:encini

# bats test_tags=yapca:positive,yapca:ENCINI-P001
@test "ENCINI-P001: Cleartext passwords are read correctly." {
	rm -f "${YAPCA_MASTERPASS_FILE}"
	run yapca.sh encini
	assert_failure 102
	assert_output --partial 'main(): _ca_passin=txt::password'
	assert_output --partial 'main(): _ca_passout=txt::password'
	assert_output --partial 'main(): _ca_passcsr=txt::password'
	assert_output --partial 'main(): _intermediate_passin=txt::password'
	assert_output --partial 'main(): _intermediate_passout=txt::password'
	assert_output --partial 'main(): _intermediate_passcsr=txt::password'
}

# bats test_tags=yapca:positive,yapca:ENCINI-P002
@test "ENCINI-P002: Cleartext passwords are decoded correctly." {
	rm -f "${YAPCA_MASTERPASS_FILE}"
	run yapca.sh encini
	assert_failure 102
	assert_output --partial 'yapca_decrypt_pass(): echo password'
	assert_output --partial 'main(): _ca_passin=password'
	assert_output --partial 'main(): _ca_passout=password'
	assert_output --partial 'main(): _ca_passcsr=password'
	assert_output --partial 'main(): _intermediate_passin=password'
	assert_output --partial 'main(): _intermediate_passout=password'
	assert_output --partial 'main(): _intermediate_passcsr=password'
}

# bats test_tags=yapca:negative,yapca:ENCINI-N001
@test "ENCINI-N001: Fails when password file does not exist." {
	rm -f "${YAPCA_MASTERPASS_FILE}"
	run yapca.sh encini
	assert_failure 102
	assert_output --partial '.bats.masterpass does not exist or has wrong permissions.'
}

# bats test_tags=yapca:negative,yapca:ENCINI-N002
@test "ENCINI-N002: Fails with wrong permissions to password file." {
	echo "password" >"${YAPCA_MASTERPASS_FILE}"
	chmod 0444 ${YAPCA_MASTERPASS_FILE}
	run yapca.sh encini
	assert_failure 102
	assert_output --partial '.bats.masterpass does not exist or has wrong permissions.'
}

