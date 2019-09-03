FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["ReportingService.Website/ReportingService.Website.csproj", "ReportingService.Website/"]
RUN dotnet restore "ReportingService.Website/ReportingService.Website.csproj"
COPY . .
WORKDIR "/src/ReportingService.Website"
RUN dotnet build "ReportingService.Website.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "ReportingService.Website.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ReportingService.Website.dll"]
