/// Normalises an instant the way the database stores it: UTC, whole
/// milliseconds.
///
/// Used on every instant that enters the data layer, so that what a
/// repository returns right after a write equals what it reads back later
/// (`DateTime ==` also compares `isUtc` and microseconds).
DateTime normalizeInstant(DateTime instant) =>
    DateTime.fromMillisecondsSinceEpoch(
      instant.millisecondsSinceEpoch,
      isUtc: true,
    );
