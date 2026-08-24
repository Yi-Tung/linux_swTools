#!/bin/bash

is_build_success=1
all_main_c=""

build_mode=""
build_main_c=""
build_configs_path=""

case "$1" in
  'release' | "")
    build_mode='release'
    all_main_c=$(find src -name "*.c")
    build_configs_path="$(pwd)/configs"
    ;;
  'debug')
    build_mode='debug'
    all_main_c=$(find src -name "*.c")
    build_configs_path="$(pwd)/configs"
    ;;
  'test')
    build_mode='test'
    all_main_c=$(find tests -name "*.c")
    build_configs_path="$(pwd)/configs"
    ;;
  *)
    echo "${0}: invalid mode"
    exit 1
    ;;
esac

make clean
mkdir -p bin

echo -e "\033[97;42m============Ready to start building============\033[0m"

for build_main_c in $all_main_c
do
  export build_mode="${build_mode}"
  export build_main_c="${build_main_c}"
  export build_configs_path="${build_configs_path}"
  make

  if [ $? -ne 0 ]
  then
    is_build_success=0
    break
  elif [[ "$build_mode" = "release" ]] || [[ "$build_mode" = "debug" ]]
  then
    mv "exe" "bin/$(basename ${build_main_c%.*})"
  elif [[ "$build_mode" = "test" ]]
  then
    mv "test" "bin/$(basename ${build_main_c%.*})"
  fi
done

if [[ "$build_mode" = "release" ]] || [[ "$build_mode" = "debug" ]]
then
  (cp -a src/scripts/*.sh bin/. 2>/dev/null) && (chmod +x bin/*.sh)
elif [[ "$build_mode" = "test" ]]
then
  (cp -a tests/scripts/*.sh bin/. 2>/dev/null) && (chmod +x bin/*.sh)
fi

if [ $is_build_success -eq 1 ]
then
  echo -e "\033[97;42m================Build Successful===============\033[0m"
elif [ $is_build_success -eq 0 ]
then
  echo -e "\033[97;41m==================Build Failed=================\033[0m"
fi

exit $((is_build_success == 1 ? 0:1))
