# docker-nrf5-thread-build
Build Environment for nRF5 using nRF5-SDK-for-Thread-and-Zigbee


# Example to run the container with volumn
run-docker.sh

    #!/bin/bash

    # After docker container run,
    # set MY_PROJ in docker container:
    # ex:
    #   export MY_PROJ=/nrf5/projects
    # Notes:
    #   use -e to set MY_PROJ automatically

    docker run --name nrf5_thread_build_ctnr -it --rm \
        -v "$(pwd)/../projects:/nrf5/projects" \
        -e MY_PROJ=/nrf5/projects \
        phillin77/nrf5-thread-build bash
