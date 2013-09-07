#!/bin/bash
# CONFIGURATION
C="XX"
O="Default Organisation"
OU="Default OU"
SUBJECT=/C=${C}/O=${O}/OU=${OU}/CN=

# INITIAL VALUES
CN=
ALT=
altCount=0
totalCount=0
csrCount=0
{ cat $@; echo; } | while read line
do
	[ "${line:0:1}" == "#" ] && continue
	if [ "$line" == "" ]
	then
		if [ "$CN" != "" ]
		then
			if [ -e "$CN" ]
			then
				echo Directory $CN already exists > /dev/stderr
			else
				export ALTNAME="$ALT"
				echo -n ${CN} > /dev/stderr
				mkdir "${CN}"
				openssl req -batch -new -nodes \
					-keyout "${CN}/key-${CN}.pem" \
					-out "${CN}/csr-${CN}.pem" \
					-config openssl.cnf \
					-subj "${SUBJECT}${CN}" \
						> "${CN}/csr-${CN}.log" \
				2>&1 \
				&& echo ": ok (${altCount} names)" > /dev/stderr \
				|| exit 1 \

				csrCount=$(expr $csrCount + 1)
		rmdir "${CN}" > /dev/null 2>&1
			fi
		fi
		CN=
		ALT=
		altCount=0
	else
		trimline=$(echo $line | tr -d ' ')
		[ "$CN" == "" ] && CN="$trimline"
		[ "$ALT" == "" ] && ALT="DNS:$trimline" || ALT="$ALT","DNS:$trimline"
		altCount=$(expr $altCount + 1)
		totalCount=$(expr $totalCount + 1)
	fi
done

