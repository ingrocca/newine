docker container prune -f
docker run -d --privileged --restart unless-stopped --mount source=newine-data-volume,target=/data -p 8080:8080 -p 3000:3000 -p 23:22 --name newine -t hawkant/newine-black-server
