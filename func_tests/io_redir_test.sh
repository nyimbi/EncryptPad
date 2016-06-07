#!/bin/sh

set -e

USAGE="io_redir_test.sh <path_to_encrypt_cli>"
if [ $# -lt 1 ]
then
    echo $USAGE
    exit 1
fi

CMD="$1 -p passphrase.txt"

TMP_DIR="./tmp"
ENC_DIR="./epd_encrypted_last"

if [ "$PLAIN_TEXT_FILE" = "" ]
then
    PLAIN_TEXT_FILE=plain_text.txt
fi

rm -fR $ENC_DIR
mkdir -p $ENC_DIR

$CMD -e < $PLAIN_TEXT_FILE > $ENC_DIR/random1.dat.gpg
cat $PLAIN_TEXT_FILE | $CMD -e > $ENC_DIR/random2.dat.gpg
cat $PLAIN_TEXT_FILE | $CMD -e | cat > $ENC_DIR/random3.dat.gpg
$CMD -e < $PLAIN_TEXT_FILE | cat > $ENC_DIR/random4.dat.gpg