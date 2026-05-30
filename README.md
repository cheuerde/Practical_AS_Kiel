# Practical_AS_Kiel

Advanced Statistics lab material for the animal breeding masters program at Kiel University.

The repository is being moved from standalone R Markdown chapters to a Quarto-based teaching setup:

- `labs/`: student-facing notes with runnable R code.
- `lectures/`: RevealJS slides for classroom projection.
- `chapters/`: legacy R Markdown chapters from the previous course version.
- `models/`: scripts that generate fitted model artifacts.
- `artifacts/models/`: generated model artifacts used by labs and lectures.

## Published Material

The no-compile version is published as a static site:

<https://cheuerde.github.io/Practical_AS_Kiel/>

Labs are rendered as HTML pages, and each lab links to the matching RevealJS slide deck. Colleagues can use the site directly in a browser without installing R, Quarto, or the course package dependencies.

## Clone The Repository

```bash
git clone https://github.com/cheuerde/Practical_AS_Kiel.git
cd Practical_AS_Kiel
```

## Student Setup

Install R and RStudio first, then check the local R package setup:

```bash
Rscript setup/check.R
Rscript setup/install.R
```

For Bayesian models with `brms` and Stan:

```bash
Rscript setup/install.R --stan --install-cmdstan
Rscript setup/check.R --stan
```

On Windows, this requires a working Rtools installation. On macOS, it requires the Xcode command line tools. The check script is meant to make those failures explicit before class.

## Render The New Site

Install Quarto, then run:

```bash
Rscript setup/install.R
quarto render
```

The rendered site is written to `_site/`.

## Present A Lecture

For the first lecture:

```bash
scripts/preview-slides.sh
```

Then open `http://localhost:4200/lectures/r-intro.html`.

See `docs/presentation-workflow.md` for the intended projector + RStudio workflow.

All new labs and slide decks include a live theme switcher. Use the top theme dropdown or press `T` while presenting.

## Generate Model Artifacts

Quick non-Stan artifacts:

```bash
Rscript scripts/build-model-artifacts.R
```

Full Stan/brms artifacts:

```bash
Rscript scripts/build-model-artifacts.R --stan
```

GitHub Actions also contains a manual **Build Model Artifacts** workflow. Use that for slower Stan/brms artifacts so the normal site build remains fast and stable.
