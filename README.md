# apptainer-gha-runner

*A simple wrapper to run GitHub Actions in a Singularity/Apptainer container instead of Docker.*

This repository provides a lightweight GitHub Action runner image and two reusable actions that enable executing GitHub workflows inside Apptainer containers. It is designed for environments where Docker is unavailable or unsuitable—such as HPC systems—and integrates smoothly with CI/CD pipelines that require reproducible, containerized execution.

## Runner Image

The Docker image [`ghcr.io/landerlini/apptainer-gha-runner`](https://github.com/landerlini/apptainer-gha-runner) extends the standard GitHub ARC runner with:

- [Apptainer](https://apptainer.org) (similar to [SingularityCE](https://docs.sylabs.io/guides/4.3/user-guide/)) for container execution  
- [Snakemake](https://snakemake.org) for workflow orchestration  

This image is intended to be deployed via GitHub ARC in Kubernetes environments, particularly those using InterLink to connect to HPC/HTC backends.

## GitHub Actions

Two reusable actions are provided to simplify integration:

### 1. `landerlini/apptainer-gha-runner/container@main`

Runs a single containerized command using Apptainer.

Example usage:

```yaml
jobs:
  run-container:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v3
      - uses: landerlini/apptainer-gha-runner/container@main
        with:
          image: docker://ubuntu:22.04
          command: echo "Hello from Apptainer"
```

### 2. `landerlini/apptainer-gha-runner/workflow@main`

Executes a Snakemake workflow using Apptainer containers for each rule.

Example usage:

```yaml
jobs:
  run-snakemake:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v3
      - uses: landerlini/apptainer-gha-runner/workflow@main
        with:
          workdir: training
          snakefile: workflow/Snakefile

```

Each rule in the Snakefile may specify a container image via the `container:` directive. 
Apptainer will be used to execute each rule in its respective container.
If the repository contains multiple workflows in multiple subdirectories, multiple jobs 
can be scheduled. Note that `workdir` is the directory from which the workflow is executed 
and is relative to the repository root, while `snakefile` provides the path to the Snakefile
**relative to the `workdir`.

## License

This project is licensed under the MIT License.
