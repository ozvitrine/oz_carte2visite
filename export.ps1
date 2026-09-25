$files = Get-ChildItem -Path lib -Recurse -Filter *.dart -File
if (Test-Path pubspec.yaml) { $files += Get-Item pubspec.yaml }$patterns = "AndroidManifest.xml", "*.gradle", "*.gradle.kts", "gradle.properties", "MainActivity.kt"
foreach ($p in$patterns) {
    $found = Get-ChildItem -Path android -Recurse -Filter$p -File -ErrorAction SilentlyContinue
    foreach ($f in$found) {
        if ($f.FullName -notmatch "\\(\.gradle|build)\\") { $files +=$f }
    }
}
$files = $files \vert{} Select-Object -Unique$out = foreach ($f in$files) {
    "================================================`nFILE: $($f.FullName)`n================================================"
    Get-Content $f.FullName
    "`n`n"
}
$out | Out-File -FilePath code_complet2.txt -Encoding utf8
Remove-Item export.ps1
