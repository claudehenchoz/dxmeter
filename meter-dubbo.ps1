$rootFolder = "C:\CHDEV"

# Download prereqs
$urlsToFolders = @{
    "https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.zip" = "$rootFolder\apache-maven-3.9.1"
    "https://download.java.net/java/GA/jdk19.0.2/fdb695a9d9064ad6b064dc6df578380c/7/GPL/openjdk-19.0.2_windows-x64_bin.zip" = "$rootFolder\openjdk-19.0.2"
    "https://github.com/apache/dubbo/archive/refs/tags/dubbo-3.1.8.zip" = "$rootFolder\dubbo-3.1.8"
}

foreach ($url in $urlsToFolders.Keys) {
    $targetFolder = $urlsToFolders[$url]

    if (-not (Test-Path $targetFolder)) {
        New-Item -ItemType Directory -Path $targetFolder | Out-Null

        $zipFilePath = Join-Path $targetFolder "download.zip"
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $url -OutFile $zipFilePath
        $ProgressPreference = 'Continue'

        Expand-Archive -Path $zipFilePath -DestinationPath $targetFolder -Force
        Remove-Item $zipFilePath
    }
}


# Prepare env
$env:MAVEN_HOME = "$rootFolder\apache-maven-3.9.1\apache-maven-3.9.1"
$env:Path += ";$rootFolder\apache-maven-3.9.1\apache-maven-3.9.1\bin"

$env:JAVA_HOME = "$rootFolder\openjdk-19.0.2\jdk-19.0.2"
$env:Path += ";$rootFolder\openjdk-19.0.2\jdk-19.0.2\bin"

Push-Location "$rootFolder\dubbo-3.1.8\dubbo-dubbo-3.1.8"

mvn clean install -DskipTests


Pop-Location
