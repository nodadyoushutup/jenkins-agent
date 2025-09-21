# jenkins-agent

This repository defines a custom Jenkins inbound agent image that layers a rich
set of troubleshooting and provisioning tools on top of the official
`jenkins/inbound-agent` base image. The container is intended to run on both
`amd64` and `arm64` nodes so the Jenkins fleet can mix architectures without
needing separate agent definitions.

## Building the image locally

Use Docker Buildx so the architecture-specific package selections in the
Dockerfile receive the correct `TARGETARCH` build argument.

```bash
# Create a new builder that supports multi-architecture builds if you do not
# already have one available.
docker buildx create --use --name jenkins-agent-builder

# Build the image for both amd64 and arm64 and push it to a registry.
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag ghcr.io/OWNER/REPO:TAG \
  --push \
  .
```

If you only need an image for your current architecture, drop the `--platform`
flag and replace `--push` with `--load` to load it into your local Docker
engine.

## Continuous delivery

A GitHub Actions workflow (`.github/workflows/publish.yml`) automatically builds
and publishes a multi-architecture image to the GitHub Container Registry for
commits to the `main` branch and any tags. Pull requests run the same build in
CI without pushing artifacts, helping catch regressions early.
