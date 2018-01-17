mkdir data -Force
Invoke-WebRequest http://comip.jp/15/comics/data.json -OutFile (Join-Path data data.json)
