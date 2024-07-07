# Helix-Config

This repository hosts my configuration files for the Helix text editor. It's set up to support programming in Golang,
Python, and Rust. Additionally, it includes a Dockerfile to facilitate running the editor with these languages on any
system without requiring local installation.

## Getting Started

To build the Docker image, use the command below:

```bash
docker build -t helix-editor .
```

To start the Docker container, run the following command:

```bash
docker run -it helix-editor
```

If you wish to include your codebase, you can mount it using:

```bash
docker run -v .:/workspace -it helix-editor
```

Alternatively, you can pull and use the image directly from my Docker Hub:

```bash
docker run -it patrickkoss/helix-editor:v0.0.1
```
