#!/bin/sh

func_demo() {
  [ "$1" = "" ] && return 1

  local priv_msg="Hello"
  echo "${priv_msg} ~ ${1}"
  return 0
}


func_name="$1"

if [ "$func_name" = "" ]
then
  echo "empty function name" >&2
  exit 1
elif ! type $func_name 2>/dev/null | grep -q 'function'
then
  echo "invalid function name" >&2
  exit 1
fi

"$@"

if [ $? -ne 0 ]
then
  echo "failed to execute '$func_name' function" >&2
  exit 1
fi
