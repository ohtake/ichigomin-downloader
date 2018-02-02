# BOM is added to help PowerShell recognize file encoding

$catalog = Get-Content -Encoding UTF8 -Raw (Join-Path data data.json) | ConvertFrom-Json

foreach ($comic in $catalog) {
  if ($comic.title -match "^(.+)　第(\d+)話$") {
    $comic.title = "$($Matches[1])　第$($Matches[2].PadLeft(3, "0"))話"
  }

  $dir = Join-Path data $comic.key
  $output = Join-Path data "$($comic.title).zip"
  $haveArchive = Test-Path $output
  $haveDir = Test-Path $dir
  if ($haveArchive) {
    Write-Verbose "Already archived $output"
    if ($haveDir) {
      Write-Output "You can remove $dir"
    }
    continue
  }
  if ($haveDir) {
    Write-Output "Skip downloading $($comic.key)"
  } else {
    mkdir $dir | Out-Null
    for ($p = 1; $p -le $comic."page-num"; $p++) {
      try {
        Invoke-WebRequest http://comip.jp/15/comics/$($comic.key)/$p.jpg -OutFile (Join-Path $dir "$($comic.key)_$($p.ToString().PadLeft(3, "0")).jpg")
      } catch {
        Write-Error $error
        continue
      }
    }
  }
  if ($(Get-ChildItem $dir).Count -ne $comic."page-num") {
    Write-Warning "Page-num differs from the number of files in $($comic.key)"
    continue
  }
  Compress-Archive $dir $output
}
