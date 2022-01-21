#!/bin/bash

test_addendum=""
while getopts v:t flag
do
    case "${flag}" in
        v) values_string=${OPTARG};;
    esac
    case "${flag}" in
        t) test_addendum="--dry-run";;
    esac
done

helm_name="gameserver-loadbalancer"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd "${SCRIPT_DIR}/../helm"
echo helm upgrade --install $helm_name "loadbalancer" ${values_string} $test_addendum
helm upgrade --install $helm_name "loadbalancer" ${values_string} $test_addendum
popd