# Palate Frontend

A Flutter application for restaurant discovery and recommendations.

## Testing & Coverage

This project includes comprehensive testing with automated coverage reporting.

- **Test Suite:** 229 tests covering business logic, data structures, and state management
- **Coverage:** 30% of testable code (excludes generated FlutterFlow widgets)
- **CI/CD:** Automated testing on every push via GitHub Actions

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Calculate filtered coverage (Windows)
.\calculate_coverage_enhanced.ps1 -Filter -Verbose

# Calculate filtered coverage (macOS/Linux)
chmod +x filter_coverage.sh
./filter_coverage.sh
```

### Documentation

- [`TESTING_FOR_CSC491.md`](TESTING_FOR_CSC491.md) - Testing strategy for course assignment
- [`TESTING_STRATEGY.md`](TESTING_STRATEGY.md) - Detailed testing approach
- [`COVERAGE_SUMMARY.md`](COVERAGE_SUMMARY.md) - Coverage metrics and progress

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.
