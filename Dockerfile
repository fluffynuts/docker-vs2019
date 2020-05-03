# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --includeRecommended --includeOptional `
    --installPath C:\code\docker\vs2019 `
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
    --add Microsoft.VisualStudio.Workload.NetCoreBuildTools `
    --add Microsoft.VisualStudio.Workload.WebBuildTools `
    --add Microsoft.Net.Component.3.5.DeveloperTools `
 || IF "%ERRORLEVEL%"=="3010" EXIT 0


SHELL [ "powershell" ]
RUN Set-ExecutionPolicy Bypass
RUN iwr -useb get.scoop.sh | iex
RUN scoop install nvm
RUN nvm install 12.16.3
RUN nvm use 12.16.3
RUN mkdir C:\dev
RUN dotnet new console -o C:\dev
RUN scoop install git

COPY nuget.config nuget.config
RUN set-service wuauserv -startuptype manual
RUN start-service wuauserv
RUN install-windowsfeature net-framework-core

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
#ENV PATH="%USERPROFILE%\\scoop\\shims;%PATH%"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV NUGET_PACKAGES=C:\packages
WORKDIR C:\dev
ENTRYPOINT ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
