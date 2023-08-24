setup() {
	load 'test_helper/bats-support/load'
	load 'test_helper/bats-assert/load'
	load 'test_helper/bats-file/load'
	# get the containing directory of this file
	# use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
	# as those will point to the bats executable's location or the preprocessed file respectively
	DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
	# make executables in src/ visible to PATH
	PATH="${DIR}/../src:$PATH"
	# export master password file path+name
	export YAPCA_MASTERPASS_FILE="${DIR}/../.bats.masterpass"
	# backup the test ini file
	cp "${DIR}/../src/ini/yapca.ini" "${DIR}/../src/ini/yapca.bats"
}

teardown() {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	mv "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
	rm -f "${YAPCA_MASTERPASS_FILE}"
	unset YAPCA_MASTERPASS_FILE
}

# bats file_tags=yapca:encini

# bats test_tags=yapca:positive,yapca:ENCINI-P000
@test "ENCINI-P000: Check that we have the correct ini file for tests." {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	cp "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
  sum_before="$(openssl dgst -sha256 "${DIR}/../src/ini/yapca.ini" | awk '{ print $NF }')"
	assert_equal "${sum_before}" "bc394a20aa239adde08098f3fdbb00cf6ebdb27a3b0da30b465f75bf2221d31c"
}

# bats test_tags=yapca:positive,yapca:ENCINI-P001
@test "ENCINI-P001: Cleartext passwords are read correctly." {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	cp "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
	rm -f "${YAPCA_MASTERPASS_FILE}"
	run yapca.sh encini
	assert_failure 102
	assert_line --partial 'main(): _ca_passin=txt::password'
	assert_line --partial 'main(): _ca_passout=txt::password'
	assert_line --partial 'main(): _ca_passcsr=txt::password'
	assert_line --partial 'main(): _intermediate_passin=txt::password'
	assert_line --partial 'main(): _intermediate_passout=txt::password'
	assert_line --partial 'main(): _intermediate_passcsr=txt::password'
}

# bats test_tags=yapca:positive,yapca:ENCINI-P002
@test "ENCINI-P002: Cleartext passwords are decoded correctly." {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	cp "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
	rm -f "${YAPCA_MASTERPASS_FILE}"
	run yapca.sh encini
	assert_failure 102
	assert_line --partial 'yapca_decrypt_pass(): echo password'
	assert_line --partial 'main(): _ca_passin=password'
	assert_line --partial 'main(): _ca_passout=password'
	assert_line --partial 'main(): _ca_passcsr=password'
	assert_line --partial 'main(): _intermediate_passin=password'
	assert_line --partial 'main(): _intermediate_passout=password'
	assert_line --partial 'main(): _intermediate_passcsr=password'
}

# bats test_tags=yapca:positive,yapca:ENCINI-P003
@test "ENCINI-P003: Passwords are encrypted properly." {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	cp "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
	echo "password" >"${YAPCA_MASTERPASS_FILE}"
	chmod 0400 ${YAPCA_MASTERPASS_FILE}
	run yapca.sh encini
	assert_success
	refute_line --regexp '^.*yapca_encrypt_pass().+ printf .%s=enc.+%s.n.*=$'
	refute_line --partial 'ERROR'
}

# bats test_tags=yapca:positive,yapca:ENCINI-P004
@test "ENCINI-P004: Backup file is created properly." {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	cp "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
	echo "password" >"${YAPCA_MASTERPASS_FILE}"
	chmod 0400 ${YAPCA_MASTERPASS_FILE}
  sum_before="$(openssl dgst -sha256 "${DIR}/../src/ini/yapca.ini" | awk '{ print $NF }')"
	run yapca.sh encini
	sum_after="$(openssl dgst -sha256 "${DIR}/../src/ini/yapca.bak" | awk '{ print $NF }')"
	assert_success
	refute_line --partial '[ERROR]:'
	assert_file_exists "${DIR}/../src/ini/yapca.bak"
	assert_equal "${sum_after}" "${sum_before}"
}

# bats test_tags=yapca:positive,yapca:ENCINI-P005
@test "ENCINI-P005: Encrypted passwords are decrypted properly." {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	cp "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
	echo "password" >"${YAPCA_MASTERPASS_FILE}"
	# first run will encrypt the passwords
	chmod 0400 ${YAPCA_MASTERPASS_FILE}
	yapca.sh encini
	# second run will fail but the decoding must be correct
	run yapca.sh noop
	assert_success
	assert_line --partial 'yapca_decrypt_pass(): echo password'
	assert_line --partial 'main(): _ca_passin=password'
	assert_line --partial 'main(): _ca_passout=password'
	assert_line --partial 'main(): _ca_passcsr=password'
	assert_line --partial 'main(): _intermediate_passin=password'
	assert_line --partial 'main(): _intermediate_passout=password'
	assert_line --partial 'main(): _intermediate_passcsr=password'
	assert_line --partial 'main(): _intermediate_passcsr=password'
	refute_line --partial '[ERROR]:'
}

# bats test_tags=yapca:negative,yapca:ENCINI-N001
@test "ENCINI-N001: Fails when password file does not exist." {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	cp "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
	rm -f "${YAPCA_MASTERPASS_FILE}"
	run yapca.sh encini
	assert_failure 102
	assert_line --partial '.bats.masterpass does not exist or has wrong permissions.'
}

# bats test_tags=yapca:negative,yapca:ENCINI-N002
@test "ENCINI-N002: Fails with wrong permissions on password file." {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	cp "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
	echo "password" >"${YAPCA_MASTERPASS_FILE}"
	chmod 0444 ${YAPCA_MASTERPASS_FILE}
	run yapca.sh encini
	assert_failure 102
	assert_line --partial '.bats.masterpass does not exist or has wrong permissions.'
}

