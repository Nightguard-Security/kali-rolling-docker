if [ -n "$(docker ps -aqf name=ng-kali)" ]; then
    docker rm -f ng-kali
fi
docker buildx build -t ng-kali .
docker run -d \
  --name=ng-kali \
  -it \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 40022:22 \
  -v ./root:/root \
  --device "/dev/net/tun:/dev/net/tun" \
  --restart unless-stopped \
  --gpus all \
  ng-kali
sleep 2
docker exec ng-kali chmod 700 /root
