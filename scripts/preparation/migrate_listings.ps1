# Database variables
$sqlserver = "JUANDA"
$database = "PortfolioProject"
$table = "raw_lisbon_listings"

# CSV variables
$parserfile = "D:\OneDrive\Obsidian\1 Projects\Busqueda de Trabajo\Portafolio\04_tableu\Lisbon\lisbon_listings.csv"
$parserdelimiter = ","
$firstRowColumnNames = $true
$fieldsEnclosedInQuotes = $true

################### No need to modify anything below ###################
Write-Host "Script started..."
$elapsed = [System.Diagnostics.Stopwatch]::StartNew()
[void][Reflection.Assembly]::LoadWithPartialName("System.Data")
[void][Reflection.Assembly]::LoadWithPartialName("System.Data.SqlClient")
[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")

# 50k worked fastest and kept memory usage to a minimum
$batchsize = 50000

# Build the sqlbulkcopy connection, and set the timeout to infinite
$connectionstring = "Data Source=$sqlserver;Integrated Security=true;Initial Catalog=$database;"
$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connectionstring, [System.Data.SqlClient.SqlBulkCopyOptions]::TableLock)
$bulkcopy.DestinationTableName = $table
$bulkcopy.bulkcopyTimeout = 0
$bulkcopy.batchsize = $batchsize

# Open text parser for the column names
$columnparser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($parserfile)
$columnparser.TextFieldType = "Delimited"
$columnparser.HasFieldsEnclosedInQuotes = $fieldsEnclosedInQuotes
$columnparser.SetDelimiters($parserdelimiter)

Write-Warning "Creating datatable"
$datatable = New-Object System.Data.DataTable
foreach ($column in $columnparser.ReadFields()) {[void]$datatable.Columns.Add()}
$columnparser.Close(); $columnparser.Dispose()

# Open text parser again from start (there's no reset)
$parser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($parserfile)
$parser.TextFieldType = "Delimited"
$parser.HasFieldsEnclosedInQuotes = $fieldsEnclosedInQuotes
$parser.SetDelimiters($parserdelimiter)
if ($firstRowColumnNames -eq $true) {$null = $parser.ReadFields()}

Write-Warning "Parsing CSV"
while (!$parser.EndOfData) {
	try { $null = $datatable.Rows.Add($parser.ReadFields()) }
	catch { Write-Warning "Row $i could not be parsed. Skipped." }

	$i++; if (($i % $batchsize) -eq 0) {
			$bulkcopy.WriteToServer($datatable)
			Write-Host "$i rows have been inserted in $($elapsed.Elapsed.ToString())."
			$datatable.Clear()
		}
}

# Add in all the remaining rows since the last clear
if($datatable.Rows.Count -gt 0) {
	$bulkcopy.WriteToServer($datatable)
	$datatable.Clear()
}

Write-Host "Script complete. $i rows have been inserted into the database."
Write-Host "Total Elapsed Time: $($elapsed.Elapsed.ToString())"

# Clean Up
#$parser.Dispose(); $bulkcopy.Dispose(); $datatable.Dispose();

$totaltime = [math]::Round($elapsed.Elapsed.TotalSeconds,2)
Write-Host "Total Elapsed Time: $totaltime seconds. $i rows added." -ForegroundColor Green
# Sometimes the Garbage Collector takes too long to clear the huge datatable.
[System.GC]::Collect()
