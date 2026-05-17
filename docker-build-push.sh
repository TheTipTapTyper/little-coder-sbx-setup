# move to the directory containing this script
cd "$(dirname "$(realpath "$0")")"

# Usage: ./docker-build-push.sh <dockerhub-username>
# Example: ./docker-build-push.sh myuser

if [ -z "$1" ]; then
  echo "Usage: $0 <dockerhub-username>"
  exit 1
fi

# build the image and push it
docker build -t "$1/little-coder-template:v1" --push ./
