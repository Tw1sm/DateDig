function Invoke-DateDig {
<#

.SYNOPSIS

Developed for assisting in incident response investigations. When a suspicious or 
timestomped file is identified, this script can be used to find other files on
the drive with timestamps near the file in question.

.DESCRIPTION

Searches the drive the current directory for files created, written, 
or accessed within a range (+/-) from a provided timestamp

.PARAMETER DateTime

Parameter denoting the date of the timestamp in the format "MM/DD/YYYY HH:MM:SS". The datetime must be in quotes

.PARAMETER Period

AM or PM

.PARAMETER Range

Time in minutes to filter Get-ChildItem by on either side of the DateTime provided

.PARAMETER FilterBy

Create, Access, or Write. Filters the range of time on files using either the CreatedTime, the LastAccessTime, or LastWriteTime

.PARAMETER OutputFile

Text file that results will be written to

.EXAMPLE

Invoke-DateDig -Date 2/4/2019 -Time 4:49:00 -Period PM -Range 5 -FilterBy Create -OutputFile C:\Users\tw1sm\Desktop\example.txt

.EXAMPLE

Invoke-DateDig -Date 2/4/2019 -Time 4:49:00 -Period AM -Range 5 -FilterBy Access -OutputFile C:\Users\tw1sm\Desktop\example.txt
#>

    Param(
        [parameter(Mandatory=$true)]
        [String]
        $DateTime,

        [parameter(Mandatory=$true)]
        [ValidateSet("AM", "PM")]
        [String]
        $Period,

        [parameter(Mandatory=$true)]
        [Int]
        $Range,

        [parameter(Mandatory=$true)]
        [ValidateSet("Create", "Access", "Write")]
        [String]
        $FilterBy,

        [parameter(Mandatory=$true)]
        [String]
        $OutputFile
    )

    BEGIN {

        $Drive = "$((get-location).Drive.Name)`:\"

        if ($FilterBy -eq "Create") {
            $Action = "LastAccessTime"
        } ElseIf ($FilterBy -eq "Write" ) {
            $Action = "LastWriteTime"
        } ElseIf ($FilterBy -eq "Access") {
            $Action = "LastAccessTime"
        }

        Write-Host "`n[*] Target Drive: $Drive"
        Write-Host "[*] DateTime: $DateTime $Period"
        Write-Host "[*] Upper/Lower Range (Mins): $Range"
        Write-Host "[*] Filtering On: $Action"
        Write-Host "`n[*] Reading disk..."

    }

    PROCESS {
        $CultureDateTimeFormat = (Get-Culture).DateTimeFormat
        $DateFormat = $CultureDateTimeFormat.ShortDatePattern
        $TimeFormat = $CultureDateTimeFormat.LongTimePattern
        $DateTimeFormat = "$DateFormat $TimeFormat"

        $TimeStamp = [DateTime]::ParseExact("$DateTime $Period", $DateTimeFormat, [System.Globalization.DateTimeFormatInfo]::InvariantInfo,[System.Globalization.DateTimeStyles]::None)
        
        $Upper = $TimeStamp.AddMinutes($Range)
        $Lower = $TimeStamp.AddMinutes(-$Range)
        
        if ($FilterBy -eq "Create") {

            Get-ChildItem -File -Recurse -Path $Drive -ErrorAction Ignore | `
                Where-Object {$_.CreationTime -ge $Lower -and $_.CreationTime -le $Upper} | `
                Format-Table Name, Directory, Length, CreationTime, LastWriteTime, LastAccessTime > $OutputFile

        } ElseIf ($FilterBy -eq "Write" ) {

            Get-ChildItem -File -Recurse -Path $Path -ErrorAction Ignore | `
                Where-Object {$_.LastWriteTime -ge $Lower -and $_.LastWriteTime -le $Upper} | `
                Format-Table Name, Directory, Length, CreationTime, LastWriteTime, LastAccessTime > $OutputFile

        } ElseIf ($FilterBy -eq "Access") {

            Get-ChildItem -File -Recurse -Path $Path -ErrorAction Ignore | `
                Where-Object {$_.LastAccessTime -ge $Lower -and $_.LastAccessTime -le $Upper} | `
                Format-Table Name, Directory, Length, CreationTime, LastWriteTime, LastAccessTime > $OutputFile
        }
        
    }

    END {
        Write-Host "`n[*] Done"
    }
}