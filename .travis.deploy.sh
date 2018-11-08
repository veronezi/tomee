#!/bin/bash
set -e

function deploy_docker_image () {
    if [ "$TRAVIS_BRANCH" = "master" ]; then
        echo "deploying docker image $1:$2-b$3"
        docker tag $1 $1:$2-b$3
        docker push $1:$2-b$3
        docker push $1
    else
        echo "deploying docker image $1:$2-rc$3"
       docker tag $1 $1:$2-rc$3
       docker push $1:$2-rc$3
    fi
}

deploy_docker_image veronezi/sample-tomee $MY_VERSION $TRAVIS_BUILD_NUMBER

echo "binaries uploaded"