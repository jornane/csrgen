# Batch CSR generator
Generate certificate signing requests in batch.
Requires input with hostnames with one hostname per line.
Empty line means new signing request.
Read `EXAMPLE.csrgen` for more information.
Input can be provided as stdin or by providing the filename as argument.

Comes with a basic openssl.conf included for your convenience.

## Useful commands
In the following commands, you must replace the variables with the filename.
All files end with .pem and start with the same string as the variable, but in lowercase.

So, for example, `${CSR_FILE}` will become `csr-example.com.pem`.

### Verify CSR
```bash
openssl req -noout -text -verify -in "${CSR_FILE}"
```

Takes a csr file and gives readable detailed output.
Search for *Subject:* and *X509v3 Subject Alternative Name:*

### Generate .tgz with all requests
```bash
tar zc */csr-*.pem > csrs.tgz
```

When run from the same directory where you ran csrgen from,
this will generate a csrs.tgz in the current directory.
The resulting file will contain all csr files.

### Generate self-signed certificate (to use while you wait for the officially signed ones to arrive)
```bash
openssl x509 -req -days 30 -in "${CSR_FILE}" -signkey "${KEY_FILE}" -out "${CERT_FILE}"
```

This will give you a certificate file which is valid for one month.
That should be plenty of time to wait for the real deal.
If you think you will need more time, you can change the `-days 30` parameter to something bigger.

Alternatively, you can make a self-signed certificate without a CSR.
```bash
openssl req -x509 -new -key "${KEY_FILE}" -out "${CERT_FILE}"
```

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
