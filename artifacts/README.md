# Model Artifacts

This directory stores generated teaching artifacts such as fitted model objects, posterior draws, and precomputed summaries.

The intended workflow is:

1. Source code for each artifact lives in `models/`.
2. `scripts/build-model-artifacts.R` runs the artifact builders.
3. Generated files are written to `artifacts/models/`.
4. GitHub Actions can upload the generated files or commit them back to the branch when explicitly requested.

Small artifacts that are needed during class can be committed. Large artifacts should usually be kept as GitHub Actions artifacts or release assets rather than committed to the main repository.
