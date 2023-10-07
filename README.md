# in_flutter_time

Convert a date into a flutter stable version. This can be a fun thing to do when you are giving a talk and want to spice up your bio with some nerdy #flutter stuff.

## Usage

## Update the tag list:

run `dart run lib/update_assets.dart` to update the assets file.

## Build an deploy

`flutter build web`
`cp build/web/ ./docs/`

## TODO:

- [ ] create github action to update the assets file
- [x] create github action to publish the page on commit
- [ ] create github action to build and publish page on commit
- [x] connect with domain and publish to gh-pages