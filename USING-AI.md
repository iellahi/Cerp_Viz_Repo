# Using AI Assistants (Claude) with This Repository

This repo was built to be operated *without* writing R code — you edit
`render_config.yml` and re-run the master knit. An AI assistant like Claude
(claude.ai, the Claude desktop app, or Claude Code) makes that even easier:
point it at this folder and describe what you want in plain English.

## Setting up

- **Claude Code / Claude desktop app (Cowork):** open a session in the repo
  folder. If a `CLAUDE.md` file is present (it may be shared separately from
  the public repo), it gives the assistant the project's rules and
  conventions automatically — keep it in the project root.
- **claude.ai (web):** create a Project and upload `README.md`,
  `REPLICATION.md`, `render_config.yml`, and a template's `.Rmd` so the
  assistant has context.

## What to ask for

These are the tasks an assistant does well here, with example prompts:

- **Add a report for a new dataset.** *"I dropped `endline_survey.csv` into
  `1_data/`. Here are its column names: … . Add an entry to
  `render_config.yml` that renders a forest plot (3.03) with treatment_arm
  as the group variable."* The assistant only needs to write YAML — the
  engine validates column names on load and fails loudly with the closest
  match if something is off.
- **Choose the right template.** Render the pre-flight data quality report
  (`0.00`, see README) and paste its recommendation table to the assistant,
  or paste your column names and ask which of the 23 templates fits.
- **Interpret an error.** Paste the full render error. Errors here are
  designed to be self-explanatory (they name the missing column or package),
  and the assistant will translate them into the exact line to fix.
- **Change colors or text.** *"Change the primary graph color to #2a6f97"* —
  the assistant should edit `2_R/theme_colors.yml` only, then tell you to run
  `2_R/2.7_build_css.R` and re-knit (see CHANGING_COLORS.md).
- **Understand the code.** Every chart lives as one `viz_*()` function in
  `2_R/2.6_viz_functions.R`; ask the assistant to walk you through one before
  modifying it.

## Rules to hold the assistant to

These mirror the project's hard rules — state them at the start of a session:

1. **Never upload or paste field data** (anything in `1_data/` other than the
   synthetic `master_*.csv`) into an AI tool. Column *names* are fine;
   participant-level rows are not.
2. **Config first.** For new reports the assistant edits `render_config.yml`,
   not the `.Rmd` templates or the R engine. Template/engine edits are for
   deliberate development, not day-to-day use.
3. **No package installs at render time.** If the assistant suggests
   `install.packages()`, the correct commands are `renv::install()` followed
   by `renv::snapshot()`, run by you.
4. **You run git.** Review diffs yourself before committing; never let an
   automated session push, and never commit anything under `1_data/` beyond
   `master_*.csv` and `geo/`.
5. **Verify by rendering.** After any change, re-run
   `source(here::here("2_R", "2.2_master_knit.R"))` and check the output.
   For engine refactors, the golden-snapshot test in `5_tests/` proves
   nothing visual changed.

## What not to delegate

Don't ask an assistant to restructure the render engine, rewrite the
`.gitignore` privacy rules, or "clean up" `1_data/` — the guardrails in this
repo (validation, snapshot tests, the guarded gallery publisher) exist so
that routine use never needs those files touched.
