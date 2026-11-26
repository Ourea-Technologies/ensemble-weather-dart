// Copyright (c) 2026 Ourea Technologies. SPDX-License-Identifier: BSD-2-Clause

/// The base of every enumeration in the SDK.
///
/// An open enumeration accepts values it does not know: a value the API adds
/// after this SDK was released becomes one with [isUnknown] set that keeps
/// the raw string in [value], instead of failing (BEHAVIOR.md 1.5).
abstract base class OpenEnum {
  /// A value this SDK version knows.
  const OpenEnum.known(this.value) : isUnknown = false;

  /// A value this SDK version does not know, kept as the raw string.
  const OpenEnum.unknown(this.value) : isUnknown = true;

  /// The wire value, exactly as the API spells it.
  final String value;

  /// Whether the server sent a value this SDK version does not know.
  final bool isUnknown;

  @override
  bool operator ==(Object other) =>
      other is OpenEnum &&
      other.runtimeType == runtimeType &&
      other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// The wire value.
  @override
  String toString() => value;

  /// The JSON form: the wire value.
  String toJson() => value;
}
