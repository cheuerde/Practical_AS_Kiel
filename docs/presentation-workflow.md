# Presentation Workflow

This course is meant to run with two synchronized views:

- Browser/projector: the RevealJS lecture deck.
- RStudio/laptop: the matching lab file for live code execution.

For the first unit:

- Slides: `lectures/r-intro.qmd`
- Lab: `labs/r-intro.qmd`

## Start The Slides

```bash
scripts/preview-slides.sh
```

The script renders and serves `lectures/r-intro.qmd` at:

```text
http://localhost:4200/lectures/r-intro.html
```

To preview another deck:

```bash
scripts/preview-slides.sh lectures/optimization.qmd
```

To change the port:

```bash
PORT=4300 scripts/preview-slides.sh
```

## In Class

1. Open the slide URL in the browser connected to the projector.
2. Open the matching lab file in RStudio.
3. Use the slides for the narrative and figures.
4. Run selected chunks from the lab in RStudio when students should reproduce the computation.

Useful RevealJS controls:

- `S`: speaker view.
- `O`: overview.
- `F`: fullscreen.
- `?`: show keyboard shortcuts.

Course controls:

- Theme dropdown: choose a live visual theme.
- `T`: cycle live visual themes from the keyboard.

## Rendering Without A Server

```bash
quarto render lectures/optimization.qmd
open _site/lectures/optimization.html
```
