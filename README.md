# Batch CSR generator
Generate certificate signing requests in batch.
Requires input with hostnames with one hostname per line.
Empty line means new signing request.
Read `EXAMPLE` for more information.
Input can be provided as stdin or by providing the filename as argument.

Comes with a basic openssl.conf included for your convenience.

## Useful commands
### Verify CSR
```bash
openssl req -noout -text -verify -in "${CSR_FILE}"
```

Takes a csr file and gives readable detailed output.
Search for *Subject:* and *X509v3 Subject Alternative Name:*

### Verify signed certificate (for when you get them back)
```bash
openssl x509 -text -noout -in "${CERT_FILE}"
```

Takes a signed certificate and shows detailed readable contents.

### Convert to p12
```bash
openssl pkcs12 -export -out "${OUT_FILE}" -inkey "${KEY_FILE}" -in "${CERT_FILE}" -certfile "${CHAIN_FILE}"`
```

Takes private key, certificate and chain and generates a .p12 file which will contain them all.
This is useful for using the certificate in systems which require .p12, such as Windows Server.
