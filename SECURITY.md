# Security policy

## Reporting a vulnerability

Please report security issues **privately**, through GitHub's
[private vulnerability reporting](https://github.com/Ourea-Technologies/ensemble-weather-dart/security/advisories/new)
for this repository. Do not open a public issue, pull request or discussion
for a suspected vulnerability.

Include what you found, how to reproduce it, and the SDK version
(`packageVersion`, or the version in your `pubspec.lock`). We acknowledge
reports within three working days and keep you informed until a fix is
released. We credit reporters in the advisory unless you prefer otherwise.

## Supported versions

Security fixes go into the latest release. Before 1.0, that is the latest
0.x minor version.

## What the SDK guarantees

- The API key is sent only as `X-API-Key`, only to the configured base URL's
  origin (a redirect to another host, port or scheme drops it), and never
  appears in exception messages or `toString()`. On the web the browser
  follows redirects itself; keep keyed calls on the API's own origin.
- TLS certificate verification is always on; the SDK has no option to turn
  it off.
- Response bodies are bounded at 64 MiB.
- JSON is parsed with `dart:convert` into fixed, declared types; no type is
  chosen from the response, and the SDK uses no reflection.

Vulnerabilities in the API service itself (`api.oureawx.com`) can be
reported the same way; we will route them.
