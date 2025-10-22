# Changelog

All notable changes to this project are documented here.

## [4.0.0]
### changed
- Whole UI design.
- Rewrote the FileBloc.
- Added vaults concept named 'chests'.
- Added new screens - Welcome, chestRoom and ChestView (previously homeScreen).
- Added a data model for chests and stored it with Hive.

### fixed
- some issues related to permission in android.

## [3.3.1]
### changed
- Replaced the folder icons into arrows in home screen.
- Prettified the paragraph and heading tags.

### Added
- Theme for tables in MD preview.

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
