#!/bin/bash

test_addendum=""
while getopts g:e:t flag
do
    case "${flag}" in
        g) game=${OPTARG};;
    esac
    case "${flag}" in
        e) env=${OPTARG};;
    esac
    case "${flag}" in
        t) test_addendum="--dry-run";;
    esac
done

helm_name=$(echo "serviceaccount-${env}-${game}"  | tr '[:upper:]' '[:lower:]')

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd "${SCRIPT_DIR}/../helm"
echo helm upgrade --install $helm_name "service-account" -f "./service-account/${game}/${env}.values.yaml" $test_addendum
helm upgrade --install $helm_name "service-account" -f "./service-account/${game}/${env}.values.yaml" $test_addendum
popd