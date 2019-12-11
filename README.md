# chuck-norris-facts-docker

Simple maven web app that shows an awasome Chuck Norris random jokes page based on chucknorris.io api.
Docker image based on tomcat.
Just build the image. For example:
```
docker build --rm -f "chuck-yanko/DockerFile" -t chuck-yanko:latest "chuck-yanko"
```
Run the image exposing the port you wish to your server. For example:
```
docker run -p 8080:8080 chuck-yanko
```
Than on your browser, go to <your server address>/chuck-yanko. For example:
```
http://localhost:8080/chuck-yanko/
```

