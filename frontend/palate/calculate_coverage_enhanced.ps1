#!/usr/bin/env pwsh
# Enhanced Flutter Coverage Calculator with Filtering
# Usage: .\calculate_coverage_enhanced.ps1 [-Filter] [-Threshold 60.0] [-Verbose]

param(
    [switch]$Filter = $true,
    [double]$Threshold = 60.0,
    [switch]$Verbose = $false
)

Write-Host "`nFlutter Coverage Calculator" -ForegroundColor Cyan
Write-Host "==========================`n" -ForegroundColor Cyan

# Check if lcov.info exists
$lcovPath = "coverage\lcov.info"
if (-not (Test-Path $lcovPath)) {
    Write-Host "[ERROR] No coverage file found at $lcovPath" -ForegroundColor Red
    Write-Host "   Run 'flutter test --coverage' first`n" -ForegroundColor Yellow
    exit 1
}

# Patterns to exclude (FlutterFlow-generated widgets, auth, API, Firebase integration)
$excludePatterns = @(
    "*_widget.dart",
    "*_model.dart",
    "*main.dart",
    "*flutter_flow_theme.dart",
    "*flutter_flow_icon_button.dart",
    "*flutter_flow_widgets.dart",
    "*flutter_flow_animations.dart",
    "*flutter_flow_drop_down.dart",
    "*flutter_flow_calendar.dart",
    "*internationalization.dart",
    "*\auth\*",
    "*firebase_auth*",
    "*firebase_config*",
    "*backend.dart",
    "*api_requests\*",
    "*api_calls.dart",
    "*custom_loader.dart"
)

# Function to check if file should be excluded
function Should-Exclude {
    param($filePath)
    
    foreach ($pattern in $excludePatterns) {
        if ($filePath -like $pattern) {
            return $true
        }
    }
    return $false
}

# Parse lcov.info
$content = Get-Content $lcovPath
$files = @{}
$currentFile = ""

foreach ($line in $content) {
    if ($line -match "^SF:(.*)") {
        $currentFile = $matches[1]
        if (-not $files.ContainsKey($currentFile)) {
            $fileName = Split-Path $currentFile -Leaf
            $isExcluded = Should-Exclude $fileName
            
            $files[$currentFile] = @{
                total = 0
                covered = 0
                isWidget = $fileName -match "_widget\.dart$"
                isExcluded = $isExcluded
                name = $fileName
            }
        }
    }
    elseif ($line -match "^DA:\d+,(\d+)") {
        if ($currentFile -and $files.ContainsKey($currentFile)) {
            $files[$currentFile].total++
            if ([int]$matches[1] -gt 0) {
                $files[$currentFile].covered++
            }
        }
    }
}

# Calculate statistics
$totalLines = 0
$coveredLines = 0
$excludedLines = 0
$excludedCovered = 0
$testableLines = 0
$testableCovered = 0

foreach ($file in $files.Values) {
    $totalLines += $file.total
    $coveredLines += $file.covered
    
    if ($file.isExcluded) {
        $excludedLines += $file.total
        $excludedCovered += $file.covered
    }
    else {
        $testableLines += $file.total
        $testableCovered += $file.covered
    }
}

# Calculate percentages
$overallPercent = if ($totalLines -gt 0) { 
    [math]::Round(($coveredLines / $totalLines) * 100, 2) 
} else { 0 }

$testablePercent = if ($testableLines -gt 0) { 
    [math]::Round(($testableCovered / $testableLines) * 100, 2) 
} else { 0 }

# Display results
Write-Host "[OVERALL COVERAGE - All Files]" -ForegroundColor White
Write-Host "   Total Lines:   $totalLines" -ForegroundColor Gray
Write-Host "   Covered Lines: $coveredLines" -ForegroundColor Gray
Write-Host "   Coverage:      $overallPercent%" -ForegroundColor Gray
Write-Host ""

if ($Filter) {
    Write-Host "[TESTABLE CODE COVERAGE - Excluding Generated Widgets]" -ForegroundColor White
    Write-Host "   Total Lines:   $testableLines" -ForegroundColor Gray
    Write-Host "   Covered Lines: $testableCovered" -ForegroundColor Gray
    
    $color = if ($testablePercent -ge $Threshold) { "Green" } else { "Yellow" }
    Write-Host "   Coverage:      $testablePercent%" -ForegroundColor $color
    Write-Host ""
    
    Write-Host "[EXCLUDED - Widget Files]" -ForegroundColor White
    Write-Host "   Total Lines:   $excludedLines" -ForegroundColor Gray
    Write-Host "   Excluded:      $excludedCovered covered" -ForegroundColor Gray
    Write-Host ""
}

# Determine pass/fail
$targetCoverage = if ($Filter) { $testablePercent } else { $overallPercent }
$targetLines = if ($Filter) { $testableLines } else { $totalLines }
$targetCovered = if ($Filter) { $testableCovered } else { $coveredLines }

Write-Host "[THRESHOLD CHECK]" -ForegroundColor White
Write-Host "   Target:   $Threshold%" -ForegroundColor Gray
Write-Host "   Current:  $targetCoverage%" -ForegroundColor Gray

if ($targetCoverage -ge $Threshold) {
    Write-Host "   Status:   [PASS]`n" -ForegroundColor Green
    
    if ($Verbose) {
        Write-Host "Coverage requirement met! $targetCoverage% >= $Threshold%`n" -ForegroundColor Green
    }
    exit 0
}
else {
    $needed = [math]::Ceiling((($targetLines * ($Threshold / 100)) - $targetCovered))
    Write-Host "   Status:   [FAIL]`n" -ForegroundColor Red
    
    Write-Host "[WARNING] Coverage below threshold: $targetCoverage% < $Threshold%" -ForegroundColor Yellow
    Write-Host "   Need $needed more lines covered to reach $Threshold%`n" -ForegroundColor Yellow
    
    if ($Verbose) {
        Write-Host "Top uncovered files:" -ForegroundColor Yellow
        $uncoveredFiles = $files.GetEnumerator() | 
            Where-Object { -not $_.Value.isExcluded -and $_.Value.total -gt 0 } |
            Sort-Object { ($_.Value.covered / $_.Value.total) } |
            Select-Object -First 5
        
        foreach ($file in $uncoveredFiles) {
            $pct = if ($file.Value.total -gt 0) { 
                [math]::Round(($file.Value.covered / $file.Value.total) * 100, 1) 
            } else { 0 }
            Write-Host "   - $($file.Value.name): $pct% ($($file.Value.covered)/$($file.Value.total))" -ForegroundColor Gray
        }
        Write-Host ""
    }
    
    exit 1
}
