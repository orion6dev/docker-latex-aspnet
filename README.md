# Dockerfile Documentation

This Dockerfile is designed to create a Docker image based on Microsoft's ASP.NET 7.0 image, with a focus on LaTeX and related tools. Below is a detailed breakdown of its contents and some best practices.

## Base Image

```docker
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
```

- **Description**: This line specifies the base image, which is Microsoft's official ASP.NET runtime Docker image for .NET 7.0.
- **Best Practices**:
  - Always use official and verified images as the base to ensure security and reliability.
  - Specify a tag (like `7.0`) to avoid breaking changes in future updates.
- **Reference**: [ASP.NET Docker Images](https://hub.docker.com/_/microsoft-dotnet-aspnet)

## Arguments

```docker
ARG USER_NAME=latex
ARG USER_HOME=/home/latex
ARG USER_ID=1000
ARG USER_GECOS=LaTeX
...
```

- **Description**: These lines define build-time variables to configure the Docker image, like the default user and their home directory.
- **Best Practices**:
  - Use `ARG` to make your Docker images flexible and configurable at build time.
- **Reference**: [Docker ARG](https://docs.docker.com/engine/reference/builder/#arg)

## Package Installation

```docker
RUN apt-get update && apt-get install --no-install-recommends -y \
  texlive-full \
  ...
```

- **Description**: This `RUN` command updates the package lists and installs a large set of packages, including `texlive-full` and various auxiliary tools like Git, wget, and make.
- **Best Practices**:
  - Use `--no-install-recommends` to avoid installing unnecessary packages.
  - Clean up the apt cache by removing `/var/lib/apt/lists` to reduce the image size.
- **Reference**: [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

## Removing Documentation Packages

```docker
RUN apt-get --purge remove -y $(dpkg-query -Wf '${binary:Package}\n' | grep -E '\-doc$')
```

- **Description**: This command removes documentation packages to reduce the image size.
- **Best Practices**:
  - Consider multi-stage builds to reduce image size.
  - Be mindful of the trade-off between build time and the final image size.
- **Reference**: [Multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)

## Cleaning Up

```docker
RUN apt-get clean -y && rm -rf /var/lib/apt/lists/*
```

- **Description**: Cleans up the apt cache and temporary files to reduce the image size.
- **Best Practices**:
  - Always clean up in the same `RUN` statement to avoid increasing the layer size.

## Adding a User

```docker
RUN adduser \
  --home "$USER_HOME" \
  --uid $USER_ID \
  --gecos "$USER_GECOS" \
  --disabled-password \
  "$USER_NAME"
```

- **Description**: Adds a non-root user with the specified configurations.
- **Best Practices**:
  - Run applications as a non-root user for security.
  - Use `--disabled-password` to prevent password login for the user.
- **Reference**: [Docker and security](https://docs.docker.com/engine/security/)

## Exposing Ports

```docker
EXPOSE 80
```

- **Description**: Indicates that the container listens on port 80.
- **Best Practices**:
  - `EXPOSE` doesn't publish the port but is a way of documenting which ports are intended to be published.
- **Reference**: [EXPOSE](https://docs.docker.com/engine/reference/builder/#expose)

## Conclusion

This Dockerfile sets up a .NET 7.0 environment with LaTeX and necessary tools suitable for generating documents.
It follows Docker best practices to ensure a secure, efficient, and maintainable image.

For further reading and best practices, consult the following resources:
- [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker and security](https://docs.docker.com/engine/security/security/)
- 
## Orion6 Software Engineering

Please use [Conventional Commits](https://www.conventionalcommits.org) for commit messages.

Run the build from the repos root directory.

```bash
podman build -t orion6dev/latex-aspnet .
```

Based on:
https://github.com/leplusorg/docker-latex