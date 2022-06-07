# Agda

Container image for Agda used by CodeRunner.

## Usage

```bash
W=/workspace/agda
# Create container
C=$(docker container create --rm -w $W ghcr.io/codewars/agda:latest agda --verbose=0 --include-path=. --library=standard-library --library=cubical ExampleTest.agda)

# Copy files from the current directory
# Example.agda
# ExampleTest.agda
docker container cp ./. $C:$W

# Run tests
docker container start --attach $C
```

## Building

```bash
$ docker build -t ghcr.io/codewars/agda:latest .
```
