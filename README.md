# KiwiSaver Government Contribution microsimulation model

An interactive model for estimating the fiscal cost and distributional effects of changes to the KiwiSaver Government Contribution (GVC).

Built and maintained by Te Ara Ahunga Ora Retirement Commission.

The latest version of the model is available at https://retirement-commission.github.io/kiwisaver-government-contribution-model/

**Model version:** v14. The version history in the methodology note is the authoritative record of what changed and when.

---

## Status

Prototype. Results may change as the model is developed. See Disclaimers and reuse below.

---

## What this model does

The model estimates what the GVC would cost, and who would receive it, under alternative policy settings. It works from a grid of 1,456 cells covering 182 income bands by 8 KiwiSaver age bands, each carrying a member count, an income midpoint, and the distribution of members across contribution-rate tiers.

For every cell, the model applies the GVC formula (member contribution, multiplied by the match rate, capped at the maximum) and aggregates upward. It reproduces the 2024 observed outturn of $1,022,341,210 exactly from IRD administrative data, and produces a verified 2026 baseline of $491,359,100 under current policy settings.

It was developed to support analysis of Recommendation 3 of the 2025 Review of Retirement Income Policies, which proposed redistributing the GVC toward lower-income savers within the existing spending envelope. It is general enough to model any parameter change to the scheme, not only redistribution options.

## What you can change

| Lever | Default | Range |
|---|---|---|
| Match rate | $0.25 per $1 contributed | $0.25 to $2.00 |
| Maximum annual contribution | $260.72 | Any value |
| Member minimum contribution rate | 3.5% | 2% to 10% |
| Income eligibility cap | $180,000 | $10,000 to $180,000, or none |
| Age eligibility | The six bands from 16-17 to 55-64 | Any combination of the eight bands |
| Income targeting | Off | Enhanced match and maximum below a chosen income |
| Age targeting | Off | Enhanced match and maximum for chosen age bands |
| Non-contributor uptake | 0% | Share of non-contributors who begin contributing, applied uniformly or at separate rates above and below an income threshold |
| Income growth | 0% | Applied before eligibility and entitlement are assessed |

Where both income and age targeting are active, age targeting takes precedence.

## What you get back

Five tabs:

- **Summary** compares the 2024 observed outturn, the 2026 default baseline, and your scenario side by side. Scenario metrics include total cost, change against the default, average GVC per contributing member, change in coverage, the income needed to reach the maximum, and the share of the enhanced group actually reaching it.
- **By income band** and **By age band** break cost and membership down across 19 reporting income bands (uniform $10,000 steps to $180,000, plus a single over-$180,000 group) or the eight age bands.
- **Distributional impacts** shows which groups gain and which lose against the 2026 default, in dollars, percentage, and coverage.
- **Model validation** documents the assumptions, the data sources, and the checks the model runs against known figures on startup.

## Two results worth understanding before you use it

**The maximum binds for most people.** At default settings a member contributing 3.5% reaches the $260.72 maximum at an income of about $29,797. Above that, extra income adds nothing. This is why raising the match rate saturates quickly while raising the maximum drives real fiscal cost, and why a large share of an economy-wide match increase flows to people earning under $30,000.

**A generous headline maximum is not the same as a generous outcome.** At default settings 83.1% of contributing members reach the full maximum. Raising the maximum to $725 without changing anything else more than doubles the cost and pushes the income needed to reach it to $82,857, at which point only 41.0% get the full amount. The model reports this reachability figure directly, because options with the most generous headline numbers often deliver least to the people they are aimed at.

---

## Running it

### In the browser

Use the hosted version linked above. Nothing to install.

### Locally

Requires R with the `shiny` and `dplyr` packages.

```r
install.packages(c("shiny", "dplyr"))
shiny::runApp()
```

Or run it straight from this repository without cloning:

```r
shiny::runGitHub("kiwisaver-government-contribution-model", "Retirement-Commission")
```

You do **not** need the source spreadsheet or the build script to run the model. The app reads the three prepared CSV files in this directory, which are committed here.

### Rebuilding the dataset

Only needed if the source data changes. Move `IRD_Taxable_income_distribution_of_individuals_2025.xlsx` from `build/source-data/` into the same directory as the build script, then:

```r
source("Build_dataset_for_GVC_model.R")
```

This regenerates `dataset_2026.csv`, `dataset_by_income.csv`, and `dataset_by_age.csv`, and prints validation output including the 2024 and 2026 baseline totals. Both should reproduce the figures above exactly. If they do not, do not use the output.

The taxable income distribution is the only spreadsheet the build script reads. Figures from the other two sources are transcribed into the script as fixed values, so those files are not needed to rebuild.

---

## Repository contents

```
app.R                            Launcher. Hosting platforms look for this name.
TAAORC_GVC_Model.R               The model and interface.
dataset_2026.csv                 The 1,456-cell simulation grid.
dataset_by_income.csv            2024 observed outturn by income band.
dataset_by_age.csv               2024 observed outturn by age band.
favicon.ico                      Browser tab icon (from retirement.govt.nz).
README.md                        This file.
.github/workflows/
  deploy-app.yaml                Builds and publishes the live tool on every commit to main.
scripts/
  export-shinylive.R             Converts the app with Shinylive and sets the tab title and icon.
build/
  Build_dataset_for_GVC_model.R  Builds the three CSVs from source data.
  source-data/
    IRD_Taxable_income_distribution_of_individuals_2025.xlsx
docs/
  methodology-note.pdf           Full methodology, assumptions, and validation.
```

## Data sources

| File | Source | Used for | In this repository |
|---|---|---|---|
| `2024_IRD_Administrative_KiwiSaver_Data.xlsx` | Inland Revenue, custom extract prepared for the 2025 Review of Retirement Income Policies | The 2024 observed baseline, reproduced exactly rather than estimated | No. Figures transcribed into the build script as fixed values |
| `IRD_Taxable_income_distribution_of_individuals_2025.xlsx` | Inland Revenue, published statistical release | Income bands, and the shape of the income distribution within each age band | Yes, in `build/source-data/` |
| `IRD_KiwiSaver_Monitoring_Project_Data_at_30_June_2025.xlsx` | Inland Revenue, customised extract provided to Te Ara Ahunga Ora | Member counts by age, contribution rates, and contributor status | No. Figures transcribed into the build script as fixed values |

All three datasets originate with Inland Revenue. The taxable income distribution determines the shape of the income distribution within each age band only. Totals come from KiwiSaver monitoring data, so the model is anchored to observed membership rather than to estimates.

The taxable income distribution is a published statistical release, available from Inland Revenue's website. The 2024 administrative extract and the 2025 monitoring project data are customised extracts provided to Te Ara Ahunga Ora and are not published releases; every figure drawn from them appears in the build script and in the methodology note.

## Limitations

This is a static microsimulation, built for comparing policy settings against each other.

- **No behavioural response**, other than the uptake setting, which is a sensitivity tool with no empirical basis rather than an estimate. Members are assumed not to change their contribution rate in response to a change in the GVC.
- **Single year.** The model reports annual cost and distribution. It says nothing about lifetime effects, accumulated balances, or retirement income adequacy.
- **No interaction with other transfers.** Effects on other income support are not modelled.
- **Income growth is uniform.** The growth slider applies one rate to every member. Differential growth by income or age is not modelled.
- **Targeting acts on one dimension at a time.** Income targeting and age targeting each apply to a single dimension, and the income eligibility cap is global, so the tool cannot currently express an intersection such as boosting ages 55 to 64 only below $80,000.
- **Contribution rates are a point-in-time snapshot.** 530,592 members contributed during the year without a rate recorded on the 30 June snapshot. These are distributed across all five rate tiers rather than assumed to be at the minimum. About 62% are PAYE members the snapshot missed, not self-employed. See the methodology note, section 4.5.

Every assumption is listed in the model's own validation tab and documented in full in the methodology note.

## Related publications

Policy analysis drawing on this model is published on the Te Ara Ahunga Ora website rather than in this repository. All figures in that analysis can be reproduced in the app. Where an analysis was carried out outside the model, the publication says so explicitly.

---

## Citation

Te Ara Ahunga Ora Retirement Commission (2026). _KiwiSaver Government Contribution microsimulation model_, version 14. https://retirement-commission.github.io/kiwisaver-government-contribution-model/

## Disclaimers and reuse

**Not official advice or a policy position.** This model is a research tool developed by Te Ara Ahunga Ora Retirement Commission to support analysis and discussion of KiwiSaver Government Contribution settings. It is not a forecast, and its outputs do not constitute Te Ara Ahunga Ora advice, a policy position, or a recommendation on any policy option.

**No warranty or liability.** The model is provided as-is and for research purposes only. Despite reasonable measures taken to ensure quality and accuracy, Te Ara Ahunga Ora makes no warranty or guarantee, express or implied, and accepts no legal liability or responsibility for the accuracy, correctness or completeness of the model or its outputs, or for any use made of them.

**Not official statistics.** Results are model estimates, not official statistics. They are derived from Inland Revenue data: one published statistical release and two customised extracts provided to Te Ara Ahunga Ora (see Data sources above).

**Reuse.** You may use, modify and adapt this code for your own work, provided Te Ara Ahunga Ora Retirement Commission is acknowledged as the source. While all care has been taken in developing this code, Te Ara Ahunga Ora gives no warranty that it is error-free and will not be liable for any loss or damage suffered as a result of its use, either directly or indirectly.

**Feedback welcome.** We welcome suggestions, feedback and corrections. Please contact office@retirement.govt.nz. If you find a discrepancy between a figure in the app and a figure in the methodology note, please let us know: the two are maintained together and should never disagree.

## Hosting and ownership

- Business owner and technical owner: Te Ara Ahunga Ora Retirement Commission.
- The live tool is hosted on GitHub Pages from this repository. It runs entirely in the user's web browser using Shinylive (R compiled to WebAssembly), so no server is involved. The first load downloads R into the browser and can take up to a minute; later visits are faster.
- Imported into the Retirement Commission GitHub organisation on 10 November 2026 from github.com/RetireBENt/TAAORC-GVC-Model, with full commit history. That original repository and its earlier Posit Connect Cloud deployment are no longer maintained.

## How the live tool is built and updated

Every commit to `main` rebuilds and republishes the live tool automatically, so test changes before committing. To test locally first, run `shiny::runApp()` from the repository root.

1. GitHub Actions runs `.github/workflows/deploy-app.yaml` on every commit to `main`. It can also be run manually: Actions tab, then shinylive-deploy, then Run workflow.
2. The workflow installs R and the `shinylive`, `shiny` and `dplyr` packages, then runs `scripts/export-shinylive.R`.
3. The script copies only the files the app needs (`app.R`, `TAAORC_GVC_Model.R` and the three CSVs) into a temporary folder, converts them with Shinylive, and sets the browser tab title and icon.
4. The result is published to GitHub Pages, usually within 5 to 10 minutes. Progress and any errors appear in the Actions tab. If a build fails, the previous version stays live.

If the app starts using a new data file, add it to `app_files` in `scripts/export-shinylive.R`. If it starts using a new R package, add it to the package list in `.github/workflows/deploy-app.yaml`.
