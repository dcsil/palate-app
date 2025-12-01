import 'dart:io';

void main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run tools/coverage_summary.dart <path-to-lcov.info>');
    exit(1);
  }
  final file = File(args[0]);
  if (!await file.exists()) {
    stderr.writeln('File not found: ${args[0]}');
    exit(1);
  }
  final lines = await file.readAsLines();
  int found = 0; // DA: line hits entries
  int hit = 0;   // lines with hits > 0

  for (final line in lines) {
    if (line.startsWith('DA:')) {
      found++;
      final parts = line.substring(3).split(',');
      if (parts.length == 2) {
        final hits = int.tryParse(parts[1]) ?? 0;
        if (hits > 0) hit++;
      }
    }
  }
  final pct = found == 0 ? 0.0 : (hit / found * 100.0);
  stdout.writeln('Frontend coverage: ${pct.toStringAsFixed(2)}% (${hit}/${found} lines)');
  // Fail non-zero exit if below threshold to allow CI gating, optional:
  if (pct < 60.0) {
    // Still exit 0 to keep dev flow, but you can change to 2 to fail.
    // exit(2);
  }
}
