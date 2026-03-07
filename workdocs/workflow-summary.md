# GitHub Workflow Summary

## 1) `build_inference_image.yml`
- **Workflow name:** Build Inference Image
- **Triggers:**
  - Manual run via `workflow_dispatch`
  - Pushes to branch `build_inference_image`
- **Purpose:** Build and push the inference Docker image using `Dockerfile.inference`.
- **Image tag:** `${{ vars.DOCKER_USER }}/tips_image:inference`
- **Main steps:**
  1. Checkout source (`actions/checkout@v4`)
  2. Login to Docker Hub (`docker/login-action@v3`) with `vars.DOCKER_USER` and `secrets.DOCKER_PAT`
  3. Setup Docker Buildx cloud builder (`docker/setup-buildx-action@v3`, endpoint `hhkhanh/tips`)
  4. Build and push image (`docker/build-push-action@v6`)

## 2) `build_raw_image.yml`
- **Workflow name:** Build Raw Image
- **Triggers:**
  - Manual run via `workflow_dispatch`
  - Pushes to branch `build_raw_image`
- **Purpose:** Build and push the raw/base Docker image using `Dockerfile`.
- **Image tag:** `${{ vars.DOCKER_USER }}/tips_image:raw`
- **Main steps:**
  1. Checkout source (`actions/checkout@v4`)
  2. Login to Docker Hub (`docker/login-action@v3`) with `vars.DOCKER_USER` and `secrets.DOCKER_PAT`
  3. Setup Docker Buildx cloud builder (`docker/setup-buildx-action@v3`, endpoint `hhkhanh/tips`)
  4. Build and push image (`docker/build-push-action@v6`)

## 3) `build_serverless_image.yml`
- **Workflow name:** Build Serverless Image
- **Triggers:**
  - Manual run via `workflow_dispatch`
  - Pushes to branch `build_serverless_image`
- **Purpose:** Build and push the serverless Docker image using `./Dockerfile.serverless`.
- **Image tag:** `${{ vars.DOCKER_USER }}/tips_image:serverless`
- **Main steps:**
  1. Checkout source (`actions/checkout@v4`)
  2. Login to Docker Hub (`docker/login-action@v3`) with `vars.DOCKER_USER` and `secrets.DOCKER_PAT`
  3. Setup Docker Buildx cloud builder (`docker/setup-buildx-action@v3`, endpoint `hhkhanh/tips`)
  4. Build and push image (`docker/build-push-action@v6`, with `context: .`)

## Common Pattern Across All 3 Workflows
- Triggered manually and by a dedicated branch push.
- Uses the same Docker Hub authentication and Buildx cloud endpoint.
- Pushes image variants (`inference`, `raw`, `serverless`) to `${{ vars.DOCKER_USER }}/tips_image`.
