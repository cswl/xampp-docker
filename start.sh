IMAGE_NAME=cswl/xampp
CONTAINER_NAME=xamppy-docker
PUBLIC_WWW_DIR='~/web_pages'


echo "Running container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."

docker start $CONTAINER_NAME > /dev/null 2> /dev/null || {
	echo "Creating new container..."
	docker run \
	       --detach \
	       -p 8086:80 \
	       -p 3386:3306 \
	       --name $CONTAINER_NAME \
	       --tty \
		   -v ~/web_pages:/www \
			$IMAGE_NAME
}

if [ "$#" -eq  "0" ]; then
	docker exec --interactive --tty $CONTAINER_NAME bash
else
	docker exec --interactive --tty $CONTAINER_NAME $@
fi

