# Changelog

All notable changes to this project are documented here.

## [3.3.0]
### Added
- CHANGELOG.md to keep track of changes.

### Changed
- ThemeBloc now caches SharedPreferences instead of flutterSecureStorage.
- Replaced static placeholder text with randomized messages.
- GH release body to use the CHANGELOG.md.

### Fixed
- Enum theme load fix: switch to `.name` instead of `.toString()` for `byName()` compatibility.

### Removed
- Hero page and assets related to it. Now it directly shows the Home page.
- Hero page screenshot from README.md
