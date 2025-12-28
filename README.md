# Resume Builder

A Docker container with LaTeX and XeLaTeX set up for compiling my resumes. This speeds up the process on my Kubernetes cluster by pre-installing dependencies. Multi-arch images (amd64/arm64) are built automatically via GitHub Actions.

## Contents

- XeLaTeX with font packages (texlive-xetex, fonts-recommended)
- AWS CLI v2 for uploading to Cloudflare R2
- Git, curl, jq, unzip
