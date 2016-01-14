<h1>Docker Brimir</h1>
_____________

This project is a Dockerfile / Docker container for the [Brimir ticketing system](https://github.com/ivaldi/brimir).

To build it, after installing [Docker](https://www.docker.com/), run :
```
  user@docker : git clone https://github.com/thehunt33r/docker-brimir
  user@docker : cd docker-brimir
  user@docker : docker build -t brimir .
  user@docker : docker run -p 80:3000 -t -d brimir
```

Many thanks to philip-dakno for contributing to this project. 

