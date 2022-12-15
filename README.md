    docker build -t space_engineers:latest .

    docker run \
        -p 27016:27016/udp \
        -v $(pwd)/data:/home/steam/data \
        space_engineers:latest
