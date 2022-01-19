#!/bin/bash

game=""
env=""
values_string=""
test_addendum=""
while getopts :g:m:e:v:t: flag
do
    case "${flag}" in
        g) game=${OPTARG};;
    esac
    case "${flag}" in
        m) map=${OPTARG};;
    esac
    case "${flag}" in
        e) env=${OPTARG};;
    esac
    case "${flag}" in
        v) values_string=${OPTARG};;
    esac
    case "${flag}" in
        t) test_addendum="--dry-run";;
    esac
done

helm_name=$(echo "gameserver-${env}-${game}-${map}"  | tr '[:upper:]' '[:lower:]')

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd "${SCRIPT_DIR}/../helm"
echo helm upgrade $helm_name "game-server" -f "./game-server/${game}/${env}.values.yaml" ${values_string} $test_addendum
helm upgrade $helm_name "game-server" -f "./game-server/${game}/${env}.values.yaml" ${values_string} $test_addendum
popd