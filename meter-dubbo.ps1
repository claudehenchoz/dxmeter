$rootFolder = "C:\CHDEV"

# Define target folders and corresponding URLs
$foldersToUrls = @{
    "apache-maven-3.9.1" = "https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.zip"
    "jdk-19.0.2" = "https://download.java.net/java/GA/jdk19.0.2/fdb695a9d9064ad6b064dc6df578380c/7/GPL/openjdk-19.0.2_windows-x64_bin.zip"
    "dubbo-dubbo-3.1.8" = "https://github.com/apache/dubbo/archive/refs/tags/dubbo-3.1.8.zip"
}

# Download and extract prereqs
foreach ($folder in $foldersToUrls.Keys) {
    $url = $foldersToUrls[$folder]
    $targetFolder = Join-Path $rootFolder $folder

    if (-not (Test-Path $targetFolder)) {
        New-Item -ItemType Directory -Path $targetFolder | Out-Null
        $zipFilePath = Join-Path $rootFolder "download.zip"
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $url -OutFile $zipFilePath
        Expand-Archive -Path $zipFilePath -DestinationPath $rootFolder -Force
        $ProgressPreference = 'Continue'
        Remove-Item $zipFilePath
    }
}

# Set environment variables
$env:MAVEN_HOME = Join-Path $rootFolder "apache-maven-3.9.1"
$env:Path += ";$($env:MAVEN_HOME)\bin"

$env:JAVA_HOME = Join-Path $rootFolder "jdk-19.0.2"
$env:Path += ";$($env:JAVA_HOME)\bin"

# Build and install using Maven
$projectFolder = Join-Path $rootFolder "dubbo-dubbo-3.1.8"
Push-Location $projectFolder
mvn clean install -DskipTests
Pop-Location
