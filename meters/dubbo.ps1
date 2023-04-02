$rootFolder = "C:\CHDEV"

# Set environment variables
$env:MAVEN_HOME = Join-Path $rootFolder "apache-maven-3.9.1"
$env:Path += ";$($env:MAVEN_HOME)\bin"

$env:JAVA_HOME = Join-Path $rootFolder "jdk-19.0.2"
$env:Path += ";$($env:JAVA_HOME)\bin"

$projectFolder = Join-Path $rootFolder "dubbo-dubbo-3.1.8"

Push-Location $projectFolder

mvn -T 4 clean install -DskipTests

Pop-Location
