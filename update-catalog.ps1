mkdir data -Force | Out-Null
$catalogPath = (Join-Path data data.json)

$hasOldJson = Test-Path $catalogPath
if ($hasOldJson) {
  $oldJson = Get-Content -Encoding UTF8 -Raw $catalogPath | ConvertFrom-Json
}

Invoke-WebRequest http://comip.jp/15/comics/data.json -OutFile $catalogPath

if ($hasOldJson) {
  $newJson = Get-Content -Encoding UTF8 -Raw $catalogPath | ConvertFrom-Json
  Compare-Object $oldJson $newJson -Property key,title,page-num
}
