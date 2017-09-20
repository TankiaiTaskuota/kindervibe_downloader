#!/bin/bash

AUTH_TOKEN=''; #AUTH_TOKEN from app
CHILDS_IDS=(''); #CHILDS_IDS from app ('1' '2' '4')
CPATH='' #path to save info /home/user/path/

if [ -n "$1" ]
 then
DAY=$1;
else
DAY=`date +%Y-%m-%d`; #'2017-04-25';
fi

while (( $(date -d "$DAY" +%s) < $(date +%s) ))
do

DAY_PATH="${CPATH}${DAY}_${CHILDS_IDS[count]}/"
echo $1
#ensure dir exits

if [[ ! -e $DAY_PATH ]]; then
    mkdir "$DAY_PATH"
elif [[ ! -d $DAY_PATH ]]; then
    echo "$DAY_PATH already exists but is not a directory" 1>&2
fi
#check variables
if [ -z "{AUTH_TOKEN}" ]; then
    echo "AUTH_TOKEN is unset or set to the empty string"
fi
if [ -z "${CHILDS_IDS}" ]; then
    echo "CHILDS_IDS is unset or set to the empty string"
fi

count=0;
while [ "x${CHILDS_IDS[count]}" != "x" ]
do

curl -v --header "Authorization: Token ${AUTH_TOKEN}" "http://kindervibe.com/api/activity/day/?child_pk=${CHILDS_IDS[count]}&date=${DAY}" -o "${DAY_PATH}day.txt";

array=`grep -o ".............jpg" "${DAY_PATH}day.txt"`

IFS=$'\n' read -d '' -r -a arr <<< "$array"
for x in "${arr[@]}"
do
  `wget -U 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4' -T 20  --tries=3 "http://kindervibe.com/media/photos/${x}" -q -O "${DAY_PATH}${x}"`
done
count=$(( $count + 1 ));
done
echo $DAY
DAY=`date -d "$DAY next day" +%Y-%m-%d`
echo $DAY
sleep 2
done
