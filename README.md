# multistage_docker_image
Multistage docker image building example with angular application

Run 'build_my_app_image.sh' with sudo, and set first parameter created image tag. It will create a new image by multi-stage build logic and after build script will delete unused images.

To run container open port 80.

For example:
  sudo build_my_app_image.sh my_app:angular
  sudo docker run -p 1234:80 my_app:angular
  
  Now you can open localhost:1234 and see angular default appliction.
