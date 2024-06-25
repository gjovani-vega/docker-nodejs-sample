# Sample Node.js application

This repository is a sample Node.js application for Docker's documentation.


build and run locally for testing (uses sqlite):
~~~
docker build --target dev -t demoapp .
docker container run -p 3000:3000 demoapp
~~~

prod (uses postgres container):
~~~
docker-compose -f docker-compose.yaml up --build
~~~

