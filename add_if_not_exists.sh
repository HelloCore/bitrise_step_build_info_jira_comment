TEXT=$1
FILENAME=$2

IS_EXISTS="FALSE"

if [ -f $FILENAME ]
then
    while IFS= read -r line
    do
        if [ "$line" = "$TEXT" ]
        then
            IS_EXISTS="TRUE"
            break
        fi
    done <"$FILENAME"
else
    echo "$TEXT" > $FILENAME
    IS_EXISTS="TRUE"
fi

if [ "$IS_EXISTS" = "FALSE" ]
then
    echo "$TEXT" >> $FILENAME
fi