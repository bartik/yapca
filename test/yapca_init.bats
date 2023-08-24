setup() {
	load 'test_helper/bats-support/load'
	load 'test_helper/bats-assert/load'
	# get the containing directory of this file
	# use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
	# as those will point to the bats executable's location or the preprocessed file respectively
	DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
	# make executables in src/ visible to PATH
	PATH="${DIR}/../src:$PATH"
	# backup the test ini file
	cp "${DIR}/../src/ini/yapca.ini" "${DIR}/../src/ini/yapca.bats"
	# prepare test directory
	cd "${DIR}/.."
	mkdir -p batsCA
	cd batsCA
	# export master password file path+name
	export YAPCA_MASTERPASS_FILE="$(cd "${DIR}/../batsCA" && pwd -P)/.bats.masterpass"
	echo "password" >"${YAPCA_MASTERPASS_FILE}"
	chmod 0400 ${YAPCA_MASTERPASS_FILE}
	# first run will encrypt the passwords
	yapca.sh encini
}

teardown() {
	rm -f "${DIR}/../src/ini/yapca.ini"
	rm -f "${DIR}/../src/ini/yapca.bak"
	mv "${DIR}/../src/ini/yapca.bats" "${DIR}/../src/ini/yapca.ini"
	rm -rf "${DIR}/../batsCA"
	unset YAPCA_MASTERPASS_FILE
}

# bats file_tags=yapca:init

# bats test_tags=yapca:positive,yapca:INIT-P001
@test "INIT-P001: Test of the initialization." {
	run yapca.sh init 
	assert_success
	refute_line --partial '[ERROR]:'
	# root directory structure
	assert_dir_exists "${DIR}/../batsCA/certs"
	assert_dir_exists "${DIR}/../batsCA/crl"
	assert_dir_exists "${DIR}/../batsCA/newcerts"
	assert_dir_exists "${DIR}/../batsCA/private"
	assert_file_exists "${DIR}/../batsCA/index.txt"
	assert_file_exists "${DIR}/../batsCA/private/ca.key.pem"
	assert_file_exists "${DIR}/../batsCA/certs/ca.cert.pem"
	# root certificate
	assert_line --partial 'Subject: C = GB, ST = England, L = Brighton, O = Rewardea & Co., postalCode = BN12RG, telephoneNumber = "+44-1273-345678", street = Bonton Street 53, street = Building 3A, street = MKF365, OU = Services, OU = Datacenter, OU = Servers, CN = Services datacenter Servers Root 2077 G1, emailAddress = info@rewardea.uk'
	# intermediate directory structure
	assert_dir_exists "${DIR}/../batsCA/intermediate/certs"
	assert_dir_exists "${DIR}/../batsCA/intermediate/crl"
	assert_dir_exists "${DIR}/../batsCA/intermediate/csr"
	assert_dir_exists "${DIR}/../batsCA/intermediate/newcerts"
	assert_dir_exists "${DIR}/../batsCA/intermediate/private"
	assert_file_exists "${DIR}/../batsCA/intermediate/index.txt"
	assert_file_exists "${DIR}/../batsCA/intermediate/private/intermediate.key.pem"
	assert_file_exists "${DIR}/../batsCA/intermediate/certs/intermediate.cert.pem"
	assert_file_exists "${DIR}/../batsCA/intermediate/certs/ca-chain.cert.pem"
}

