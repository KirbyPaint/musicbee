# Load the necessary assembly for System.Web.HttpUtility
Add-Type -AssemblyName System.Web

# Define the XML template with a placeholder (TEMPLATE) for the artist's name
$template = @'
<?xml version="1.0" encoding="UTF-8"?>
<SmartPlaylist SaveStaticCopy="False" LiveUpdating="True" Layout="4" LayoutGroupBy="0" ShuffleMode="None" ShuffleSameArtistWeight="0.5" GroupBy="track" ConsolidateAlbums="False" MusicLibraryPath="G:\Programs\MusicBee\Library\">
  <Source Type="1">
    <Description />
    <Conditions CombineMethod="All">
      <Condition Field="ArtistPeople" Comparison="Contains" Value="TEMPLATE" />
    </Conditions>
    <Limit FilterDuplicates="False" Enabled="False" Count="25" Type="Items" SelectedBy="Random" />
    <DefinedSort Id="3" />
    <Fields>
      <Group Id="TrackDetail">
        <Field Code="20" Width="16" />
        <Field Code="78" Width="29" />
        <Field Code="65" Width="426" />
        <Field Code="32" Width="275" />
        <Field Code="30" Width="293" />
        <Field Code="59" Width="157" />
        <Field Code="75" Width="75" />
        <Field Code="16" Width="65" />
      </Group>
    </Fields>
  </Source>
</SmartPlaylist>
'@

# Function to create playlist file for each artist
function Create-Playlist {
    param (
        [string]$artist
    )
    
    $filename = "$artist.xautopf"
    $playlistContent = $template -replace "TEMPLATE", [System.Web.HttpUtility]::HtmlEncode($artist)

    # Write the content to a new file
    $playlistContent | Set-Content -Path $filename -Encoding UTF8
    Write-Host "Created playlist file: $filename"
}

# Check if a file with artist names is provided
if ($args.Count -eq 0) {
    Write-Host "Usage: script.ps1 <file_with_artist_names>"
    exit
}

# Read artist names from the provided file and create a playlist for each
Get-Content $args[0] | ForEach-Object {
    $artist = $_.Trim()  # Trim any trailing whitespace or newlines
    Create-Playlist -artist $artist
}