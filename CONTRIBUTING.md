# Contributing to ensemble_weather

Thanks for helping make Ourea better. This is the official Dart SDK for the
[Ourea](https://oureawx.com) API. Its behaviour is fixed by the shared
[SDK spec](spec/BEHAVIOR.md) and [repository standard](spec/SDK-STANDARD.md),
and its public API follows [Effective Dart](https://dart.dev/effective-dart).
The API's own behaviour lives in
[ensemble-weather-spec](https://github.com/Ourea-Technologies/ensemble-weather-spec),
so a request for a new API capability may be moved there.

## Development setup

You need the [Dart SDK](https://dart.dev/get-dart) 3.6 or later (a Flutter
SDK includes one). Then, from a clone:

```sh
dart pub get
```

## Checks

CI runs exactly these; run them before you push:

```sh
dart format --output=none --set-exit-if-changed .   # formatting
dart analyze --fatal-infos                          # lints, strict casts/inference/raw types
dart test                                           # unit tests, the vectors, drift, the examples
dart run tool/check_dependencies.dart               # runtime dependencies are justified
dart pub publish --dry-run                          # the package as pub.dev will see it
dart run tool/sync_spec.dart --check                # spec/ matches spec/VERSION
```

`dart test` runs every vector in `spec/vectors/` against a `package:http`
`MockClient`, the spec-drift test against `spec/openapi/v1/openapi.yaml`, and
every program in `example/` against a local stub server
(`test/support/stub_server.dart`). Tests never call the real API. To run one
example by hand, start the stub and point the SDK at it:

```sh
dart run test/support/stub_server.dart          # prints: export OUREA_BASE_URL=...
OUREA_BASE_URL=http://127.0.0.1:PORT dart run example/quickstart.dart
```

## The spec

`spec/` is a copy of ensemble-weather-spec at the commit or tag in
`spec/VERSION`. Never edit it by hand:

```sh
dart run tool/sync_spec.dart v1.1.0    # pin a new spec version and copy it in
```

If a vector looks wrong, open an issue on the spec repository instead of
bending the SDK to it.

## Good bug reports

The [bug form](https://github.com/Ourea-Technologies/ensemble-weather-dart/issues/new?template=bug_report.yml)
asks for the SDK version, your Dart or Flutter version and platform, a
minimal snippet, and the `requestId` from the exception if there is one.
Never paste your API key. Feature ideas are decided in the open on their
issue; a change to what the API returns is decided in the spec repository.
We aim to give every new issue and pull request a first response within a
few business days.

## Rules of the road

- The server computes, the SDK carries: no summing, averaging or
  interpolating of quantiles, and no probabilities derived client-side.
- Every bug fix comes with a test that fails without it.
- Every public name has a doc comment.
- Commit messages: an imperative summary line (`Add`, `Fix`, ...) of at most
  72 characters, a blank line, then what changed and why. One logical change
  per commit; `main` has a linear history.
- CHANGELOG entries credit outside contributors by GitHub handle.

## Dependencies

As few as possible: each runtime dependency is a supply-chain risk and an
install cost. `tool/check_dependencies.dart` (run in CI) fails if
`pubspec.yaml` declares a runtime dependency that is not listed here with
its justification. Adding one needs the maintainers' approval.

### Runtime dependencies

- `http`: the HTTP client, published by the Dart team. `dart:io`'s
  `HttpClient` does not exist on the web, so a pure-Dart SDK that also runs
  in Flutter web needs `http`, which picks the right client per platform and
  gives tests a `MockClient`.

Development tools (`lints`, `test`, `yaml`, `coverage`) are pinned in
`pubspec.lock` and never ship to users.

## Releasing (maintainers)

1. Update `CHANGELOG.md`, `pubspec.yaml` and `lib/src/version.dart` (a test
   keeps the last two equal).
2. Merge to `main`, then tag `vX.Y.Z` on it and push the tag.
3. `release.yml` runs CI on the tag, publishes to pub.dev through automated
   publishing (GitHub OIDC, environment `pub.dev`), then creates the GitHub
   release.

## Code of conduct

This project follows the [Contributor Covenant](CODE_OF_CONDUCT.md).
