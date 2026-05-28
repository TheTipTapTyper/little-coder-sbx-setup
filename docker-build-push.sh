# move to the directory containing this script
cd "$(dirname "$(realpath "$0")")"

# Usage: ./docker-build-push.sh <dockerhub-username>
# Example: ./docker-build-push.sh myuser
if [ -z "$1" ]; then
  echo "Usage: $0 <dockerhub-username>"
  exit 1
fi

# build the image and push it with both a date tag and latest
DATE_TAG="v1-$(date +%Y%m%d)"
docker build \
    --platform linux/amd64 \
    --build-arg CACHEBUST="$(date +%s)" \
    -t "$1/little-coder-template:$DATE_TAG" \
    -t "$1/little-coder-template:latest" \
    --push ./