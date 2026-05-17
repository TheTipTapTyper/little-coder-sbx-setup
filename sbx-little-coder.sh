# launch a docker sandbox container in the cwd using my custom image that runs the little-coder agent
sbx run --kit "$(dirname "$(realpath "$0")")"/little-coder-kit/ little-coder
