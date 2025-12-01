param([switch]$ExcludeWidgets = $true, [double]$Threshold = 60.0)
Write-Host "`n Flutter Coverage Calculator" -ForegroundColor Cyan
$lcovPath = "coverage\lcov.info"
if (-not (Test-Path $lcovPath)) { Write-Host " No coverage file" -ForegroundColor Red; exit 1 }
$content = Get-Content $lcovPath
$files = @{}
$currentFile = ""
foreach ($line in $content) {
    if ($line -match "^SF:(.*)") { $currentFile = $matches[1]; if (-not $files.ContainsKey($currentFile)) { $files[$currentFile] = @{total=0; covered=0; isWidget=$false} }; if ($currentFile -match "_widget\.dart$") { $files[$currentFile].isWidget = $true } }
    elseif ($line -match "^DA:\d+,(\d+)") { $files[$currentFile].total++; if ([int]$matches[1] -gt 0) { $files[$currentFile].covered++ } }
}
$totalLines = 0; $coveredLines = 0; $widgetLines = 0; $widgetCovered = 0
foreach ($file in $files.Values) { $totalLines += $file.total; $coveredLines += $file.covered; if ($file.isWidget) { $widgetLines += $file.total; $widgetCovered += $file.covered } }
$overallPercent = if ($totalLines -gt 0) { [math]::Round(($coveredLines / $totalLines) * 100, 2) } else { 0 }
$nonWidgetLines = $totalLines - $widgetLines; $nonWidgetCovered = $coveredLines - $widgetCovered
$nonWidgetPercent = if ($nonWidgetLines -gt 0) { [math]::Round(($nonWidgetCovered / $nonWidgetLines) * 100, 2) } else { 0 }
Write-Host "`n OVERALL: $totalLines lines, $coveredLines covered, $overallPercent%"
if ($ExcludeWidgets) { Write-Host " TESTABLE (no widgets): $nonWidgetLines lines, $nonWidgetCovered covered, $nonWidgetPercent%" -ForegroundColor $(if ($nonWidgetPercent -ge $Threshold) { "Green" } else { "Yellow" }); $target = $nonWidgetPercent } else { $target = $overallPercent }
if ($target -ge $Threshold) { Write-Host "`n SUCCESS: $target% >= $Threshold%`n" -ForegroundColor Green; exit 0 }
$needed = [math]::Ceiling((($nonWidgetLines * ($Threshold / 100)) - $nonWidgetCovered))
Write-Host "`n  $target% < $Threshold% (need $needed more lines)`n" -ForegroundColor Yellow; exit 1
