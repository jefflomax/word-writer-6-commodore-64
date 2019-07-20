# WW.PRG begins with 2 byte prefix load address 01 08 = $0801
# Overlay files have 2 byte prefix little endian load address

# Read the "labels" symbol file, and
# Find OVERLAY_MARK_[BEGIN|END]
$addressRegex = [regex] '\$(\w+)' # Pattern needs to be single quotes
$hexStart = [string]""
$hexEnd = [string]""

$origin = "801" # Hex origin of program
$byteMarkLength = 2

Get-Content labels | Where-Object { $_ -match "OVERLAY_MARK_" } | Foreach-Object {

	$m = $addressRegex.Match($_)

	$hexValue = $m.Groups[1].value
	if( $_.IndexOf("BEGIN") -ge 0 ){
		$hexStart = $hexValue
	}
	if( $_.IndexOf("END") -ge 0 ) {
		$hexEnd = $hexValue
	}
}
Write-Host "Overlay from $hexStart to $hexEnd"

$overlayStart = [Convert]::ToInt64($hexStart,16)
$overlayEnd = [Convert]::ToInt64($hexEnd,16)

$origin = [Convert]::ToInt64($origin,16)

$overlayStartLoByte = $overlayStart % 256
$overlayStartHiByte = (($overlayStart - $overlayStartLoByte) / 256) 

$so = $overlayStart - $origin + $byteMarkLength
$se = $overlayEnd - $origin + $byteMarkLength

Write-Host ($overlayStart - $origin)
Write-Host ($overlayEnd - $origin)

$hexLo = [Convert]::ToString($overlayStartLoByte,16)
$hexHi = [Convert]::ToString($overlayStartHiByte,16)

Write-Host "Start $overlayStart End $overlayEnd Origin $origin Lo $overlayStartLoByte ($hexLo) Hi $overlayStartHiByte ($hexHi)"


$ww6Binary = Get-Content -Path "ww6outln.prg" -Encoding byte -Raw

Write-Host $ww6binary.Length

# Set the prior 2 bytes to the load address
$loadAddressOffset = $so - 2
$ww6Binary[$loadAddressOffset] = $overlayStartLoByte
$ww6Binary[$loadAddressOffset+1] = $overlayStartHiByte
Set-Content -Path "ov1.prg" -Encoding byte -NoNewline -Value $ww6Binary[$loadAddressOffset..$se]

$ww6DataBinary = Get-Content -Path "ww6data.prg" -Encoding byte -Raw

$ww6DataBinary[$loadAddressOffset] = $overlayStartLoByte
$ww6DataBinary[$loadAddressOffset+1] = $overlayStartHiByte
Set-Content -Path "ov2.prg" -Encoding byte -NoNewline -Value $ww6DataBinary[$loadAddressOffset..$se]
