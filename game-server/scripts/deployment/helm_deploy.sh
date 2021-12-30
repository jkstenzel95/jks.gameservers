#!/bin/bash

game=""
env=""
values_string=""
test_addendum=""
while getopts :g:m:e:v:t_ flag
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

echo "dry run bit: ${test_addendum}"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd "${SCRIPT_DIR}/../../helm"
echo helm install "gameserver-${env}-${map}" "game-server" -f "./game-server/${game}/${env}.values.yaml" ${values_string} --dry-run
helm install "gameserver-${env}-${map}" "game-server" -f "./game-server/${game}/${env}.values.yaml" ${values_string} --dry-run