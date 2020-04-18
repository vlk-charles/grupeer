#!/bin/bash

SITE=https://www.grupeer.com
URL=/view-cession-agreement/
CURL="curl -b laravel_session=$1"
export SITE URL CURL

p=1
while $CURL "$SITE/my-investments?page=$p" | grep -o "$URL[^\"]*" | grep -o '[^/]\+$'
 do p=$(expr "$p" + 1)
done | xargs -rL 1 bash -c '
 until [ "$(file -b --mime-type "$0")" = application/pdf ]; do
  $CURL -O "$SITE$URL$0"
 done
 mv "$0"{,.pdf}'
