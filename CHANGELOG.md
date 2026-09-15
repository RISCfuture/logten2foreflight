# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-09-15

### Added

- Convert a LogTen Pro for macOS logbook into a CSV file that can be imported
  into ForeFlight Logbook.
- Read the most recently modified LogTen Pro logbook by default, or a specific
  one given by `--logten-file` and `--logten-managed-object-model`.
- Export flights, aircraft, aircraft types, and crew and passenger roles.
- Classify each flight as FAA or EASA from the departure airport's ICAO
  identifier, emitting only that regime's columns; `--default-regulations`
  chooses the regime for airports outside `K` and `E`.
- Read LogTen custom fields for the values ForeFlight wants but LogTen has no
  native field for, including night full-stop landings, checkrides,
  FAR 61.58 recurrent flights, refresher training, simulator type and
  category, aircraft type codes, diesel engines, and towered airports.
- `--verbose` to include extra information in the output.

[Unreleased]: https://github.com/RISCfuture/logten2foreflight/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/RISCfuture/logten2foreflight/releases/tag/v1.0.0
