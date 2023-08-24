# OpenSSL __title__ CA configuration file.
# Copy to `__dir__/openssl.cnf`.

[ ca ]
# `man ca`
default_ca = CA_default

[ CA_default ]
# Directory and file locations.
dir               = __dir__
certs             = $dir/certs
crl_dir           = $dir/crl
new_certs_dir     = $dir/newcerts
database          = $dir/index.txt
serial            = $dir/serial
RANDFILE          = $dir/private/.rand

# The root key and root certificate.
private_key       = $dir/private/__fname__.key.pem
certificate       = $dir/certs/__fname__.cert.pem

# For certificate revocation lists.
crlnumber         = $dir/crlnumber
crl               = $dir/crl/__fname__.crl.pem
crl_extensions    = crl_ext
default_crl_days  = 30

# SHA-1 is deprecated, so use SHA-2 instead.
default_md        = sha256

name_opt          = ca_default
cert_opt          = ca_default
default_days      = 375
preserve          = no
policy            = policy___policy__

[ policy_strict ]
# The root CA should only sign intermediate certificates that match.
# See the POLICY FORMAT section of `man ca`.
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ policy_loose ]
# Allow the intermediate CA to sign a more diverse range of certificates.
# See the POLICY FORMAT section of the `ca` man page.
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
# Options for the `req` tool (`man req`).
default_bits        = 2048
distinguished_name  = req_distinguished_name
encrypt_key         = no
prompt              = no
string_mask         = utf8only

# SHA-1 is deprecated, so use SHA-2 instead.
default_md          = sha256

# Extension to add when the -x509 option is used.
x509_extensions     = v3_ca

input_password      = __passin__
output_password     = __passout__

[ req_distinguished_name ]
# See <https://en.wikipedia.org/wiki/Certificate_signing_request>.
countryName             = __countryName__
stateOrProvinceName     = __stateOrProvinceName__
localityName            = __localityName__
organizationName      	= __organizationName__
postalCode							= __postalCode__
telephoneNumber					= __telephoneNumber__
0.streetAddress					= __0_streetAddress__
1.streetAddress					= __1_streetAddress__
2.streetAddress					= __2_streetAddress__
3.streetAddress					= __3_streetAddress__
4.streetAddress					= __4_streetAddress__
5.streetAddress					= __5_streetAddress__
6.streetAddress					= __6_streetAddress__
7.streetAddress					= __7_streetAddress__
8.streetAddress					= __8_streetAddress__
9.streetAddress					= __9_streetAddress__
0.organizationalUnitName= __0_organizationalUnitName__
1.organizationalUnitName= __1_organizationalUnitName__
2.organizationalUnitName= __2_organizationalUnitName__
3.organizationalUnitName= __3_organizationalUnitName__
4.organizationalUnitName= __4_organizationalUnitName__
5.organizationalUnitName= __5_organizationalUnitName__
6.organizationalUnitName= __6_organizationalUnitName__
7.organizationalUnitName= __7_organizationalUnitName__
8.organizationalUnitName= __8_organizationalUnitName__
9.organizationalUnitName= __9_organizationalUnitName__
commonName              = __commonName__
emailAddress            = __emailAddress__

[ v3_ca ]
# Extensions for a typical CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ v3_intermediate_ca ]
# Extensions for a typical intermediate CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ usr_cert ]
# Extensions for client certificates (`man x509v3_config`).
basicConstraints = CA:FALSE
nsCertType = client, email
nsComment = "OpenSSL Generated Client Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, emailProtection
authorityInfoAccess = OCSP;URI:__authorityInfoAccess__

[ server_cert ]
# Extensions for server certificates (`man x509v3_config`).
basicConstraints = CA:FALSE
nsCertType = server
nsComment = "OpenSSL Generated Server Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer:always
subjectAltName=__subjectAltName__
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
authorityInfoAccess = OCSP;URI:__authorityInfoAccess__

[ crl_ext ]
# Extension for CRLs (`man x509v3_config`).
authorityKeyIdentifier=keyid:always

[ ocsp ]
# Extension for OCSP signing certificates (`man ocsp`).
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, digitalSignature
extendedKeyUsage = critical, OCSPSigning
