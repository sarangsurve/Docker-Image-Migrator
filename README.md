# Docker-Image-Migrator
A lightweight shell script to migrate Docker images by pulling them from a source registry, tagging them for a target registry, and pushing them to the destination.

## 🔧 Usage

```bash
./docker-image-migrator.sh <source-registry> <source-image[:tag]> <target-registry> <target-image[:tag]>
```

## Example
```bash
./docker-image-migrator.sh https://hub.docker.com/library python:3.9-alpine myregistry mypython:3.9-alpine
```

## 💡 Features
* Defaults to latest tag if not provided
* Removes http:// or https:// from registry URLs
* Clear error handling
* Color-coded output for better readability
* Optional enhancements (for future use): logging levels, ```--dry-run```, verbose mode.

