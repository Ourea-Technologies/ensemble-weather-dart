// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

// Compiled by CI with `dart compile js`: proves the library has no dart:io in
// its web import graph, so it works in Flutter web and in the browser.

import 'package:ensemble_weather/ensemble_weather.dart';

void main() {
  final client = OureaClient(environment: const {});
  final term = Chance.atLeast(Variable.snowfall, 6, unit: Unit.inch);
  print('${client.baseUrl} ${term.variable} ${userAgent()}');
  client.close();
}
