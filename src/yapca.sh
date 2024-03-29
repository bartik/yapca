#!/bin/bash
# https://jamielinux.com/docs/openssl-certificate-authority/index.html
export PS4='+(\D{%D %T} ${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -exo pipefail
# This is a rather minimal example Argbash potential
# Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
# ARG_OPTIONAL_SINGLE([openssl],[o],[openssl command to use],[openssl])
# ARG_OPTIONAL_SINGLE([tmp],[t],[temporary directory to use])
# ARG_OPTIONAL_SINGLE([ini],[i],[ini file to read])
# ARG_OPTIONAL_SINGLE([path],[p],[path to the certificate tree])
# ARG_OPTIONAL_SINGLE([keylength],[k],[Keylength not for ca or intermediate, use ini file],[2048])
# ARG_OPTIONAL_SINGLE([validity],[v],[Validity period not for ca or intermediate, use ini file],[365])
# ARG_POSITIONAL_SINGLE([positional], [Commands to execute], )
# ARG_HELP([The general script's help msg])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.9.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate
# ./test/bats/bin/bats test/yapca_basic.bats
# ./test/bats/bin/bats test/yapca_init.bats
# ./test/bats/bin/bats test/yapca_encini.bats

SCRIPTNAME="${0##*/}"
SCRIPTNAME="${SCRIPTNAME%%.*}"
readonly SCRIPTNAME
SCRIPTPATH=$(dirname "$0")
SCRIPTPATH="$(cd "${SCRIPTPATH}" && pwd -P)/"
readonly SCRIPTPATH
SCRIPTUMASK="$(umask)"
readonly SCRIPTUMASK
CURRENTDIR="$(pwd -P)/"
readonly CURRENTDIR

# die codes
readonly ERR_ARGBASH=101
readonly ERR_ENCRYPT_INI=102
readonly ERR_READ_INI=103
readonly ERR_UNKNOWN_COMMAND=104

# cert related constants
readonly SERVER_KEYLENGTH=2048

# Define trace levels
readonly TRACE_LEVEL_ERROR=1
readonly TRACE_LEVEL_WARN=2
readonly TRACE_LEVEL_INFO=3
readonly TRACE_LEVEL_DEBUG=4

# Default trace level
readonly DEFAULT_TRACE_LEVEL=${TRACE_LEVEL_INFO}

die() {
  local _ret="${2:-1}"
  test "${_PRINT_HELP:-no}" = yes && print_help >&2
  echo "$1" >&2
	yapca_trace "${TRACE_LEVEL_ERROR}" "End fail"
  umask "${SCRIPTUMASK}"
  exit "${_ret}"
}

begins_with_short_option() {
  local first_option all_short_options='otikvh'
  first_option="${1:0:1}"
  test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

print_help() {
  printf '%s\n' "The general script's help msg"
  printf 'Usage: %s [-o|--openssl <arg>] [-t|--tmp <arg>] [-i|--ini <arg>] [-p|--path <arg>] [-k|--keylength <arg>] [-v|--validity <arg>] [-h|--help] <positional>\n' "$0"
  printf '\t%s\n' "<positional>: Commands to execute"
  printf '\t%s\n' "-o, --openssl: openssl command to use (default: 'openssl')"
  printf '\t%s\n' "-t, --tmp: temporary directory to use (no default)"
  printf '\t%s\n' "-i, --ini: ini file to read (no default)"
  printf '\t%s\n' "-p, --path: path to the certificate tree (no default)"
  printf '\t%s\n' "-k, --keylength: Keylength not for ca or intermediate, use ini file (default: '2048')"
  printf '\t%s\n' "-v, --validity: Validity period not for ca or intermediate, use ini file (default: '365')"
  printf '\t%s\n' "-h, --help: Prints help"
}

parse_commandline() {
  _positionals_count=0
  while test $# -gt 0; do
    _key="$1"
    case "$_key" in
    -o | --openssl)
      test $# -lt 2 && die "Missing value for the optional argument '$_key'." "${ERR_ARGBASH}"
      _arg_openssl="$2"
      shift
      ;;
    --openssl=*)
      _arg_openssl="${_key##--openssl=}"
      ;;
    -o*)
      _arg_openssl="${_key##-o}"
      ;;
    -t | --tmp)
      test $# -lt 2 && die "Missing value for the optional argument '$_key'." "${ERR_ARGBASH}"
      _arg_tmp="$2"
      shift
      ;;
    --tmp=*)
      _arg_tmp="${_key##--tmp=}"
      ;;
    -t*)
      _arg_tmp="${_key##-t}"
      ;;
    -i | --ini)
      test $# -lt 2 && die "Missing value for the optional argument '$_key'." "${ERR_ARGBASH}"
      _arg_ini="$2"
      shift
      ;;
    --ini=*)
      _arg_ini="${_key##--ini=}"
      ;;
    -i*)
      _arg_ini="${_key##-i}"
      ;;
    -p | --path)
      test $# -lt 2 && die "Missing value for the optional argument '$_key'." "${ERR_ARGBASH}"
      _arg_path="$2"
      shift
      ;;
    --path=*)
      _arg_path="${_key##--path=}"
      ;;
    -p*)
      _arg_path="${_key##-p}"
      ;;
    -k | --keylength)
      test $# -lt 2 && die "Missing value for the optional argument '$_key'." "${ERR_ARGBASH}"
      _arg_keylength="$2"
      shift
      ;;
    --keylength=*)
      _arg_keylength="${_key##--keylength=}"
      ;;
    -k*)
      _arg_keylength="${_key##-k}"
      ;;
    -v | --validity)
      test $# -lt 2 && die "Missing value for the optional argument '$_key'." "${ERR_ARGBASH}"
      _arg_validity="$2"
      shift
      ;;
    --validity=*)
      _arg_validity="${_key##--validity=}"
      ;;
    -v*)
      _arg_validity="${_key##-v}"
      ;;
    -h | --help)
      print_help
      exit 0
      ;;
    -h*)
      print_help
      exit 0
      ;;
    *)
      _last_positional="$1"
      _positionals+=("$_last_positional")
      _positionals_count=$((_positionals_count + 1))
      ;;
    esac
    shift
  done
}

handle_passed_args_count() {
  local _required_args_string="'positional'"
  test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 1 (namely: $_required_args_string), but got only ${_positionals_count}." "${ERR_ARGBASH}"
  test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 1 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." "${ERR_ARGBASH}"
}

assign_positional_args() {
  local _positional_name _shift_for=$1
  _positional_names="_arg_positional "

  shift "$_shift_for"
  for _positional_name in ${_positional_names}; do
    test $# -gt 0 || break
    eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." "${ERR_ARGBASH}"
    shift
  done
}

# Define function to print trace messages
yapca_trace() {
  local level=${1}
  local message=${2}

  # Check if trace level is greater than or equal to the threshold
  if [[ ${level} -le ${DEFAULT_TRACE_LEVEL} ]]; then
    case ${level} in
      "${TRACE_LEVEL_ERROR}") echo "[ERROR]: ${message}";;
      "${TRACE_LEVEL_WARN}") echo "[WARNING]: ${message}";;
      "${TRACE_LEVEL_INFO}") echo "[INFO]: ${message}";;
      "${TRACE_LEVEL_DEBUG}") echo "[DEBUG]: ${message}";;
    esac
  fi
}

function yapca_random_string() {
  # ensure $1 is a number
  local l_hex_digits
	printf -v l_hex_digits '%d' "${1}"
  # generate random hex string
  printf '%8s' "$(od -An -N"${l_hex_digits}" -tx1 /dev/urandom | tr -d '[:blank:]')"
}

function yapca_encrypt_string() {
	# processed string
	local p_str_dec
	local p_str_enc
	# salt
	local p_salt_front
	local p_salt_back
	# salt length
	local p_len_front
	local p_len_back
	# encrypt parameters
	p_enc_cmd=(
		"enc"
		"-aes-256-cbc"
		"-pbkdf2"
		"-base64"
		"-A"
		"-pass"
		"file:${2}"
	)
	
	p_str_dec="${1}"
	# Generate a random prefix and postfix salt
	p_salt_front="$("${_arg_openssl}" rand $((RANDOM % 16 + 16)) | tr -dc '[:alnum:]' )"
	p_salt_back="$("${_arg_openssl}" rand $((RANDOM % 16 + 16)) | tr -dc '[:alnum:]' )"
	# get the lengths
	p_len_front=${#p_salt_front}
	p_len_back=${#p_salt_back}
	# encrypt
	# pattern "<prefix_len><prefix><password><postfix><postfix_len>"
	# <prefix_len> is always 2 chars
	# <postfix_len> is always 2 chars
	printf -v p_str_enc "%02x%s%s%s%02x" "${p_len_front}" "${p_salt_front}" "${p_str_dec}" "${p_salt_back}" "${p_len_back}"
	p_str_enc="$(echo -e "${p_str_enc}" | "${_arg_openssl}" "${p_enc_cmd[@]}")"
	printf "%s" "${p_str_enc}"
}

function yapca_decrypt_string() {
	# processed string
	local p_str_enc
	local p_str_dec
	local p_str_len
	# salt length
	local p_len_afront
	local p_len_back
	# temporary strings
	local p_tmp_front
	local p_tmp_back
	local p_tmp_dec
	# decrypt parameters
	p_dec_cmd=(
		"enc"
		"-aes-256-cbc"
		"-pbkdf2"
		"-base64"
		"-d"
		"-pass"
		"file:${2}"
	)
	
	p_str_enc="${1}"
	# decrypt
	# pattern "<prefix_len><prefix><password><postfix><postfix_len>"
	# <prefix_len> is always 2 chars
	# <postfix_len> is always 2 chars
	# decoded string
	p_str_dec="$(echo -e "${p_str_enc}" | "${_arg_openssl}" "${p_dec_cmd[@]}")"
	# extract pass
	# determine the length of the prefix salt
	printf -v p_len_front "%d" "0x${p_str_dec:0:2}"
	# remove the front salt ^<frontsaltlength><frontsalt>
	p_tmp_front="${p_str_dec:0:2+${p_len_front}}"
	p_tmp_dec=${p_str_dec#"${p_tmp_front}"}
	# determine the back salt <backsalt><backsaltlength>$
	p_tmp_front="${p_tmp_dec%??}"
	p_tmp_back=${p_tmp_dec#"${p_tmp_front}"}
	printf -v p_len_back "%d" "0x${p_tmp_back}"
	# determine the password length
	p_str_len=${#p_tmp_dec}-2-${p_len_back}
	# decrypted string withoud salt
	p_str_dec=${p_str_dec:2+${p_len_front}:${p_str_len}}
	printf "%s" "${p_str_dec}"
}

##
## Create the root pair
##
function yapca_initialize_root() {
  #
  # Prepare the directory structure
  #
  a_dir=(
    "${_ca_dir}"
    "${_ca_dir}/certs"
    "${_ca_dir}/crl"
    "${_ca_dir}/newcerts"
    "${_ca_dir}/private"
  )
  for l_dir in "${a_dir[@]}"; do
    mkdir -p "${l_dir}"
    chmod 0700 "${l_dir}"
  done
  chmod 700 "${_ca_dir}/private"
  touch "${_ca_dir}/index.txt"
  echo 1000 >"${_ca_dir}/serial"
  #
  # Prepare the configuration file
  #
  a_cmd=(
    "-v"
    "s=ca"
    "-v"
    "p=${_ca_dir}"
    "-f"
    "${SCRIPTPATH}awk/${SCRIPTNAME}.awk"
    "${_arg_ini}"
    "${SCRIPTPATH}tpl/openssl.tpl"
  )
  awk "${a_cmd[@]}" >"${_ca_dir}/openssl.cnf"
  printf "%s\n", "${_ca_passin}" >"${_ca_dir}/${SCRIPTNAME}.passin"
  printf "%s\n", "${_ca_passout}" >"${_ca_dir}/${SCRIPTNAME}.passout"
  printf "%s\n", "${_ca_passcsr}" >"${_ca_dir}/${SCRIPTNAME}.passcsr"
  #
  # Create the root key
  #
  a_cmd=(
    "genrsa"
    "-aes256"
    "-passout"
    "file:${_ca_dir}/${SCRIPTNAME}.passout"
    "-out"
    "${_ca_dir}/private/${_ca_key}"
  )
  if [[ "${_ca_keylength}" != "" ]]; then
    a_cmd+=("${_ca_keylength}")
  fi
  "${_arg_openssl}" "${a_cmd[@]}"
  chmod 400 "${_ca_dir}/private/${_ca_key}"
  #
  # Create the root certificate
  #
  a_cmd=(
    "req"
    "-config"
    "${_ca_dir}/openssl.cnf"
    "-key"
    "${_ca_dir}/private/${_ca_key}"
    "-passin"
    "file:${_ca_dir}/${SCRIPTNAME}.passin"
    "-passout"
    "file:${_ca_dir}/${SCRIPTNAME}.passout"
    "-new"
    "-x509"
    "-sha256"
    "-extensions"
    "v3_ca"
    "-out"
    "${_ca_dir}/certs/${_ca_crt}"
  )
  if [[ "${_ca_validity}" != "" ]]; then
    a_cmd+=("-days" "${_ca_validity}")
  fi
  "${_arg_openssl}" "${a_cmd[@]}"
  chmod 444 "${_ca_dir}/certs/${_ca_crt}"
  # Verify the root certificate
  a_cmd=(
    "x509"
    "-noout"
    "-text"
    "-in"
    "${_ca_dir}/certs/${_ca_crt}"
  )
  "${_arg_openssl}" "${a_cmd[@]}"
}

##
## Create the intermediate pair
##
function yapca_initialize_intermediate() {
  # Prepare the directory
  a_dir=(
    "${_intermediate_dir}"
    "${_intermediate_dir}/certs"
    "${_intermediate_dir}/crl"
    "${_intermediate_dir}/csr"
    "${_intermediate_dir}/newcerts"
    "${_intermediate_dir}/private"
  )
  for l_dir in "${a_dir[@]}"; do
    mkdir -p "${l_dir}"
    chmod 0700 "${l_dir}"
  done
  chmod 700 "${_intermediate_dir}/private"
  touch "${_intermediate_dir}/index.txt"
  echo 1000 >"${_intermediate_dir}/serial"
  echo 1000 >"${_intermediate_dir}/crlnumber"

  #
  # Prepare the configuration file
  #
  a_cmd=(
    "-v"
    "s=intermediate"
    "-v"
    "p=${_intermediate_dir}"
    "-f"
    "${SCRIPTPATH}awk/${SCRIPTNAME}.awk"
    "${_arg_ini}"
    "${SCRIPTPATH}tpl/openssl.tpl"
  )
  awk "${a_cmd[@]}" >"${_intermediate_dir}/openssl.cnf"
  printf "%s\n", "${_intermediate_passin}" >"${_intermediate_dir}/${SCRIPTNAME}.passin"
  printf "%s\n", "${_intermediate_passout}" >"${_intermediate_dir}/${SCRIPTNAME}.passout"
  printf "%s\n", "${_intermediate_passcsr}" >"${_intermediate_dir}/${SCRIPTNAME}.passcsr"

  #
  # Create the intermediate key
  #
  a_cmd=(
    "genrsa"
    "-aes256"
    "-passout"
    "file:${_intermediate_dir}/${SCRIPTNAME}.passout"
    "-out"
    "${_intermediate_dir}/private/${_intermediate_key}"
  )
  if [[ "${_intermediate_keylength}" != "" ]]; then
    a_cmd+=("${_intermediate_keylength}")
  fi
  "${_arg_openssl}" "${a_cmd[@]}"
  chmod 400 "${_intermediate_dir}/private/${_intermediate_key}"

  # Create the intermediate certificate
  #
  # create key + csr
  #
  a_cmd=(
    "req"
    "-config"
    "${_intermediate_dir}/openssl.cnf"
    "-new"
    "-sha256"
    "-passin"
    "file:${_intermediate_dir}/${SCRIPTNAME}.passin"
    "-passout"
    "file:${_intermediate_dir}/${SCRIPTNAME}.passcsr"
    "-key"
    "${_intermediate_dir}/private/${_intermediate_key}"
    "-out"
    "${_intermediate_dir}/csr/${_intermediate_csr}"
  )
  "${_arg_openssl}" "${a_cmd[@]}"
  chmod 444 "${_intermediate_dir}/csr/${_intermediate_csr}"

  #
  # Sign csr
  #
  a_cmd=(
    "ca"
    "-batch"
    "-config"
    "${_ca_dir}/openssl.cnf"
    "-extensions"
    "v3_intermediate_ca"
    "-notext"
    "-md"
    "sha256"
    "-passin"
    "file:${_ca_dir}/${SCRIPTNAME}.passin"
    "-in"
    "${_intermediate_dir}/csr/${_intermediate_csr}"
    "-out"
    "${_intermediate_dir}/certs/${_intermediate_crt}"
  )
  if [[ "${_intermediate_validity}" != "" ]]; then
    a_cmd+=("-days" "${_intermediate_validity}")
  fi
  "${_arg_openssl}" "${a_cmd[@]}"
  chmod 444 "${_intermediate_dir}/certs/${_intermediate_crt}"

  #
  # Verify the intermediate certificate
  #
  a_cmd=(
    "x509"
    "-noout"
    "-text"
    "-in"
    "${_intermediate_dir}/certs/${_intermediate_crt}"
  )
  "${_arg_openssl}" "${a_cmd[@]}"

  a_cmd=(
    "verify"
    "-CAfile"
    "${_ca_dir}/certs/${_ca_crt}"
    "${_intermediate_dir}/certs/${_intermediate_crt}"
  )
  "${_arg_openssl}" "${a_cmd[@]}"

  #
  # Create the certificate chain file
  #
  cat "${_intermediate_dir}/certs/${_intermediate_crt}" \
    "${_ca_dir}/certs/${_ca_crt}" >"${_intermediate_dir}/certs/${_ca_chain}"
  chmod 444 "${_intermediate_dir}/certs/${_ca_chain}"
}

function yapca_initialize_ca() {
  # create the root and intermediate certs
  yapca_initialize_root
  yapca_initialize_intermediate
  # remove tempdir
  if [[ -d "${_arg_tmp}" ]]; then
    rm -rf "${_arg_tmp}"
  fi
  # remove password files
  rm -f "${_ca_dir}/${SCRIPTNAME}.passin"
  rm -f "${_ca_dir}/${SCRIPTNAME}.passout"
  rm -f "${_ca_dir}/${SCRIPTNAME}.passcsr"
  rm -f "${_intermediate_dir}/${SCRIPTNAME}.passin"
  rm -f "${_intermediate_dir}/${SCRIPTNAME}.passout"
  rm -f "${_intermediate_dir}/${SCRIPTNAME}.passcsr"
}

##
## Generate server key withoud password
##
function yapca_server_key() {
  local l_server_key="${1}"
  local l_server_keylength="${2}"
  a_cmd=(
    "genrsa"
    "-config"
    "${_ca_dir}/openssl.cnf"
    "-out"
    "${_intermediate_dir}/private/${l_server_key}"
  )
  if [[ "${l_server_keylength}" != "" ]]; then
    a_cmd+=("${l_server_keylength}")
	else
    a_cmd+=("${SERVER_KEYLENGTH}")
  fi
  "${_arg_openssl}" "${a_cmd[@]}"
  chmod 400 "${_intermediate_dir}/private/${l_server_key}"
}

##
## Create a signing request withoud password
##
function yapca_server_csr() {
  l_server_key="${1}"
  a_cmd=(
    "req"
    "-config"
    "${_intermediate_dir}/openssl.cnf"
    "-new"
    "-key"
    "${_intermediate_dir}/private/${l_server_key}"
    "-out"
    "${_intermediate_dir}/csr/${l_server_csr}"
  )
  "${_arg_openssl}" "${a_cmd[@]}"
  chmod 444 "${_intermediate_dir}/csr/${l_server_key}"
}

##
## Create a certificate by signing the request
##
function yapca_server_crt() {

	openssl ca -config intermediate/openssl.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in intermediate/csr/www.example.com.csr.pem \
      -out intermediate/certs/www.example.com.cert.pem
	chmod 444 intermediate/certs/www.example.com.cert.pem
}

##
## Decrypt password
##
function yapca_decrypt_pass() {
  l_enc_str="${1}"
	l_dec_str="${l_enc_str}"
	l_name_base=".${SCRIPTNAME}.masterpass"
	l_name_dir="${_ca_dir}/"
	# Check if password file name is in env
	if [[ -n "${YAPCA_MASTERPASS_FILE}" ]]; then
		l_name_base="$(basename "${YAPCA_MASTERPASS_FILE}")"
		l_name_dir="$(dirname "${YAPCA_MASTERPASS_FILE}")"
		l_name_dir="$(cd "${l_name_dir}" && pwd -P)/"
	fi
	# check if the password is encrypted
	if [[ "${l_enc_str}" == txt::* ]]; then
		# remove prefix
		l_dec_str="${l_enc_str#?????}"
	# check if we have a master password
	elif [[ "$(find "${l_name_dir}." ! -name . -prune -type f -name "${l_name_base}" -perm 400)" == "${l_name_dir}./${l_name_base}" && "${l_enc_str}" == enc::* ]]; then
		# remove prefix
		l_enc_str="${l_enc_str#?????}"
		l_dec_str="$(yapca_decrypt_string "${l_enc_str}" "${l_name_dir}${l_name_base}")"
  fi
  echo "${l_dec_str}"
}

##
## Encrypt passwords in ini file
##
function yapca_encrypt_pass() {
  l_ini="${1}"
	l_name_base=".${SCRIPTNAME}.masterpass"
	l_name_dir="${_ca_dir}/"
	# Check if password file name is in env
	if [[ -n "${YAPCA_MASTERPASS_FILE}" ]]; then
		l_name_base="$(basename "${YAPCA_MASTERPASS_FILE}")"
		l_name_dir="$(dirname "${YAPCA_MASTERPASS_FILE}")"
		l_name_dir="$(cd "${l_name_dir}" && pwd -P)/"
	fi
	if [[ "$(find "${l_name_dir}." ! -name . -prune -type f -name "${l_name_base}" -perm 400)" == "${l_name_dir}./${l_name_base}" ]]; then
    # write to ini file
		if [[ -n ${l_ini:-} && -f ${l_ini:-} && -w ${l_ini:-} ]]; then
			# rewrite to temporary file with encrypted passwords
			echo -n >"${_arg_tmp}/encrypted.ini"
			while IFS='' read -r INILINE || [[ -n "${INILINE}" ]]; do
				{
					if [[ "${INILINE}" == pass* ]]; then
						l_name="${INILINE%%=*}"
						l_pass="${INILINE#*=}"
						if [[ "${l_pass}" == txt::* ]]; then
							# remove the txt:: prefix
							l_pass="${l_pass#?????}"
							# encrypt password
							l_enc_pass="$(yapca_encrypt_string "${l_pass}" "${l_name_dir}${l_name_base}")"
							# write back
							printf '%s=enc::%s\n' "${l_name}" "${l_enc_pass//=/\\075}"
						else
							printf '%s\n' "${INILINE}"
						fi
					else
						printf '%s\n' "${INILINE}"
					fi
				} >>"${_arg_tmp}/encrypted.ini"
			done <"${l_ini}"
			# replace plaintext password ini with the encrypted one
			mv "${l_ini}" "${l_ini%.*}.bak" && cp "${_arg_tmp}/encrypted.ini" "${l_ini}"
		else
			die "File: ${l_ini} is not writable." "${ERR_ENCRYPT_INI}"
		fi
  else
    die "Masterpassword file: ${l_name_dir}${l_name_base} does not exist or has wrong permissions." "${ERR_ENCRYPT_INI}"
  fi
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_openssl="openssl"
_arg_tmp="/tmp/.${SCRIPTNAME}_$(yapca_random_string 4)"
_arg_ini="${SCRIPTPATH}ini/${SCRIPTNAME}.ini"
_arg_keylength="2048"
_arg_validity="365"
_arg_path="${CURRENTDIR}"

# Main
parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# If temporary directory does not exist
if [[ ! -d "${_arg_tmp}" ]]; then
  mkdir -p "${_arg_tmp}"
fi

################################################################################
# determine ini file name
# Construct the list of l_inifiles in descending order of importance
# 1) defined by ini parameter (assumes whole path and extension as parameter)
# 2) defined by ini parameter (assumes whole path as parameter) + ini extension
# 3) defined by ini parameter + current/run directory + .ini extension
# 4) defined by ini parameter + script directory + .ini extension
# 5) defined by ini parameter + current/run directory
# 6) defined by ini parameter + script directory
# 7) script name + current/run directory + .ini extension
# 8) script name + script directory + .ini extension
# 9) name "default.ini" + current/run directory
# 10) name "default.ini " + script directory
l_inifiles=()
if [[ -n ${_arg_ini} ]]; then
  l_inifiles+=(
    "${_arg_ini}"
    "${_arg_ini}.ini"
    "${CURRENTDIR}${_arg_ini}.ini"
    "${CURRENTDIR}ini/${_arg_ini}.ini"
    "${SCRIPTPATH}${_arg_ini}.ini"
    "${SCRIPTPATH}ini/${_arg_ini}.ini"
    "${CURRENTDIR}${_arg_ini}"
    "${CURRENTDIR}ini/${_arg_ini}"
    "${SCRIPTPATH}${_arg_ini}"
    "${SCRIPTPATH}ini/${_arg_ini}"
  )
fi
l_inifiles+=(
  "${CURRENTDIR}${SCRIPTNAME}.ini"
  "${CURRENTDIR}ini/${SCRIPTNAME}.ini"
  "${SCRIPTPATH}${SCRIPTNAME}.ini"
  "${SCRIPTPATH}ini/${SCRIPTNAME}.ini"
  "${CURRENTDIR}default.ini"
  "${CURRENTDIR}ini/default.ini"
  "${SCRIPTPATH}default.ini"
  "${SCRIPTPATH}ini/default.ini"
)

for ((i = 0; i < ${#l_inifiles[@]}; i++)); do
  if [[ -f ${l_inifiles[$i]} && -r ${l_inifiles[$i]} ]]; then
    _arg_ini="${l_inifiles[$i]}"
    break
  fi
done

################################################################################
# read ini file if defined
# do not overwrite already existing parameters from command line
if [[ -n ${_arg_ini:-} && -f ${_arg_ini:-} && -r ${_arg_ini:-} ]]; then
  while IFS='=' read -r INIVAR INIVAL; do
    if [[ ${INIVAR} == [* ]]; then
      INIVAR="${INIVAR#?}"
      INISEC="${INIVAR%%?}"
			# this part reads only the ca and intermediate sections from ini
			if [[ "${INISEC}" != "ca" && "${INISEC}" != "intermediate" ]]; then
				break
			fi
    elif [[ ${INIVAL:-} ]]; then
      ARGVAR="_${INISEC}_${INIVAR}"
      ARGVAL=${!ARGVAR:-}
      if [[ -z ${ARGVAL} ]]; then
        if [[ ${ARGVAR} == "_arg_parameter" ]]; then
          for _last_positional in ${INIVAL}; do
            _positionals+=("$_last_positional")
            _positionals_count=$((_positionals_count + 1))
          done
        else
          declare "_${INISEC}_${INIVAR}=${INIVAL}"
        fi
      fi
    fi
  done < "${_arg_ini}"
else
  die "File: ${_arg_ini:-} is not readable." "${ERR_READ_INI}"
fi

# set defaults here if not read from ini file
_ca_passin="${_ca_passin:=Z88TSdJphmUGrvlXnkZ7}"
_ca_passout="${_ca_passout:=GErJenAKvT1FVQQSBWcf}"
_ca_passcsr="${_ca_passcsr:=cNwbgwgaxMMHNVNOhC3k}"
_intermediate_passin="${_intermediate_passin:=Z88TSdJphmUGrvlXnkZ7}"
_intermediate_passout="${_intermediate_passout:=GErJenAKvT1FVQQSBWcf}"
_intermediate_passcsr="${_intermediate_passcsr:=cNwbgwgaxMMHNVNOhC3k}"
_ca_key="${_ca_key:=ca.key.pem}"
_ca_crt="${_ca_crt:=ca.cert.pem}"
_ca_chain="${_ca_chain:=ca-chain.cert.pem}"
_ca_keylength="${_ca_keylength:=4096}"
_ca_validity="${_ca_validity:=36500}"
_intermediate_key="${_intermediate_key:=intrmediate.key.pem}"
_intermediate_crt="${_intermediate_crt:=intermediate.cert.pem}"
_intermediate_csr="${_intermediate_csr:=intermediate.csr.pem}"
_intermediate_keylength="${_intermediate_keylength:=2048}"
_intermediate_validity="${_intermediate_validity:=3650}"
if [[ "${_ca_dir}" != '/'* ]]; then
  _ca_dir="${_arg_path}${_ca_dir}"
fi
if [[ "${_intermediate_dir}" != '/'* ]]; then
  _intermediate_dir="${_arg_path}${_intermediate_dir}"
fi
_ca_dir="${_ca_dir%/}"
_intermediate_dir="${_intermediate_dir%/}"

# decode passwords if required
_ca_passin="$(yapca_decrypt_pass "${_ca_passin}")"
_ca_passout="$(yapca_decrypt_pass "${_ca_passout}")"
_ca_passcsr="$(yapca_decrypt_pass "${_ca_passcsr}")"
_intermediate_passin="$(yapca_decrypt_pass "${_intermediate_passin}")"
_intermediate_passout="$(yapca_decrypt_pass "${_intermediate_passout}")"
_intermediate_passcsr="$(yapca_decrypt_pass "${_intermediate_passcsr}")"

umask 0077
yapca_trace "${TRACE_LEVEL_INFO}" "Begin"
case "${_arg_positional}" in
init)
	yapca_trace "${TRACE_LEVEL_INFO}" "Initialize CA"
	# echo "password" > .yapca.masterpass
	# mkdir -p CA; cp .yapca.masterpass CA/
	# ./src/yapca.sh -p /home/yapca/CA/ init
  yapca_initialize_ca
  ;;
encini)
	yapca_trace "${TRACE_LEVEL_INFO}" "Encode passwords in the INI file"
	# ./src/yapca.sh encini
  yapca_encrypt_pass "${_arg_ini}"
  ;;
decini)
	yapca_trace "${TRACE_LEVEL_INFO}" "Print decrypted passwords from the INI file"
	# ./src/yapca.sh decini
	printf "CA::passin \t\"%s\"\n" "${_ca_passin}"
	printf "CA::passout\t\"%s\"\n" "${_ca_passout}"
	printf "CA::passcsr\t\"%s\"\n" "${_ca_passcsr}"
	printf "intermediate::passin \t\"%s\"\n" "${_intermediate_passin}"
	printf "intermediate::passout\t\"%s\"\n" "${_intermediate_passout}"
	printf "intermediate::passcsr\t\"%s\"\n" "${_intermediate_passcsr}"
	;;
server)
	yapca_trace "${TRACE_LEVEL_INFO}" "Creating a new server key"
	yapca_server_key "keyname" 2048
	yapca_server_csr "keyname"
	;;
noop)
	yapca_trace "${TRACE_LEVEL_INFO}" "No operation performed"
	;;
*)
	yapca_trace "${TRACE_LEVEL_ERROR}" "Unknown command"
  die "FATAL ERROR: Unknown command" ${ERR_UNKNOWN_COMMAND}
  ;;
esac
yapca_trace "${TRACE_LEVEL_INFO}" "End success"
umask "${SCRIPTUMASK}"
exit 0
