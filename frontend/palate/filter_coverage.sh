#!/bin/bash
# Flutter Coverage Filter Script
# Filters widget files from coverage reports for accurate testable code metrics

set -e

echo "🧪 Filtering Flutter Coverage"
echo "=============================="
echo ""

# Check if lcov is installed
if ! command -v lcov &> /dev/null; then
    echo "❌ lcov not found. Install it first:"
    echo "   Ubuntu/Debian: sudo apt-get install lcov"
    echo "   macOS: brew install lcov"
    exit 1
fi

# Check if coverage file exists
if [ ! -f "coverage/lcov.info" ]; then
    echo "❌ No coverage file found at coverage/lcov.info"
    echo "   Run 'flutter test --coverage' first"
    exit 1
fi

echo "📊 Original coverage:"
lcov --summary coverage/lcov.info 2>&1 | grep "lines"
echo ""

# Filter out FlutterFlow-generated widget files and other patterns
echo "🔍 Filtering excluded patterns..."
lcov --remove coverage/lcov.info \
    '*/pages/*_widget.dart' \
    '*/components/*_widget.dart' \
    '*_widget.dart' \
    '*/flutter_flow_theme.dart' \
    '*/flutter_flow_icon_button.dart' \
    '*/flutter_flow_widgets.dart' \
    '*/flutter_flow_animations.dart' \
    '*/flutter_flow_drop_down.dart' \
    '*/flutter_flow_calendar.dart' \
    '*/internationalization.dart' \
    '*/.dart_tool/**' \
    '*/test/**' \
    -o coverage/filtered_lcov.info > /dev/null 2>&1

echo "✅ Filtered coverage saved to coverage/filtered_lcov.info"
echo ""

echo "📊 Filtered coverage (testable code only):"
lcov --summary coverage/filtered_lcov.info 2>&1 | grep "lines"
echo ""

# Extract coverage percentage
COVERAGE=$(lcov --summary coverage/filtered_lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//')
THRESHOLD=60.0

echo "🎯 Threshold Check"
echo "   Target:  $THRESHOLD%"
echo "   Current: $COVERAGE%"

# Compare using awk for floating point
if awk "BEGIN {exit !($COVERAGE >= $THRESHOLD)}"; then
    echo "   Status:  ✅ PASS"
    echo ""
    echo "🎉 Coverage requirement met! ${COVERAGE}% >= ${THRESHOLD}%"
    exit 0
else
    echo "   Status:  ❌ FAIL"
    echo ""
    echo "⚠️  Coverage below threshold: ${COVERAGE}% < ${THRESHOLD}%"
    exit 1
fi
