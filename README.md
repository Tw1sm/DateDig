Invoke-DateDig
==============
## Overview ##
Developed for assisting in incident response investigations. When a suspicious or timestomped file is identified, this script can be used to find other files on the drive with timestamps near the file in question.

## Usage ##
```powershell
NAME
    Invoke-DateDig

SYNTAX
    Invoke-DateDig [-DateTime] <String> [-Period] <String> [-Range] <Int32> [-FilterBy] <String> [-OutputFile] <String> [<CommonParameters>]

PARAMETERS
    -DateTime <String>
        Parameter denoting the date of the timestamp in the format "MM/DD/YYYY HH:MM:SS". The datetime must be in quotes

    -Period <String>
        AM or PM

    -Range <Int32>
        Time in minutes to filter Get-ChildItem by on either side of the DateTime provided

    -FilterBy <String>
        Create, Access, or Write. Filters the range of time on files using either the CreatedTime, the LastAccessTime, or LastWriteTime

    -OutputFile <String>
        Text file that results will be written to

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

    -------------------------- EXAMPLE 1 --------------------------

    PS C:\>Invoke-DateDig -Date "2/4/2019 4:49:00" -Period PM -Range 5 -FilterBy Create -OutputFile C:\Users\tw1sm\Desktop\example.txt

    -------------------------- EXAMPLE 2 --------------------------

    PS C:\>Invoke-DateDig -Date "2/4/2019 4:49:00" -Period AM -Range 5 -FilterBy Access -OutputFile C:\Users\tw1sm\Desktop\example.txt

```