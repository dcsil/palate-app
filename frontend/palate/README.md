# Palate Frontend

A Flutter application for restaurant discovery and recommendations.

## Testing & Coverage

This project includes comprehensive testing with automated coverage reporting.

- **Test Suite:** 1,056 tests covering business logic, data structures, utilities, and state management
- **Coverage:** 76.95% of testable code (excludes UI models, auth integration, API calls, Firebase config)
- **Overall Coverage:** 15.88% (includes all generated widgets and integration code)
- **CI/CD:** Automated testing on every push via GitHub Actions

### Coverage Breakdown
- ✅ **Core Business Logic:** Custom functions, restaurant data models, archetypes
- ✅ **Utilities:** Schema helpers, serialization, type conversions, formatting
- ✅ **Backend Logic:** Firestore records, struct serialization
- ⚠️ **Excluded from coverage:** UI models (*_model.dart), auth integration, API calls, Firebase config (requires integration testing)

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

### CI/CD - Getting the Coverage Link for Submission

**For project submission, follow these steps to get the CI run link:**

1. **Navigate to GitHub Actions:**
   - Go to: https://github.com/dcsil/vera-app/actions
   - Or click the "Actions" tab in the repository

2. **Find the Latest Successful Run:**
   - Look for the "Flutter Tests and Coverage" workflow
   - Click on a green ✅ run (latest on `frontend-testing` branch)

3. **View Coverage Results:**
   - In the workflow run, scroll to the "Run Flutter Tests" job
   - Expand "Calculate coverage" step to see coverage percentage
   - Coverage summary also appears at the bottom of the run

4. **Copy the Link:**
   - Copy the URL from your browser (format: `https://github.com/dcsil/vera-app/actions/runs/XXXXXXXX`)
   - Use this link in your project submission

**Expected Coverage:** 76.95% of testable code (excluding UI models, auth, API integration)

### Documentation

- [`TESTING_FOR_CSC491.md`](TESTING_FOR_CSC491.md) - Testing strategy for course assignment
- [`TESTING_STRATEGY.md`](TESTING_STRATEGY.md) - Detailed testing approach
- [`COVERAGE_SUMMARY.md`](COVERAGE_SUMMARY.md) - Coverage metrics and progress

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.
