FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["ReportingService.Api/ReportingService.Api.csproj", "ReportingService.Api/"]
RUN dotnet restore "ReportingService.Api/ReportingService.Api.csproj"
COPY . .
WORKDIR "/src/ReportingService.Api"
RUN dotnet build "ReportingService.Api.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "ReportingService.Api.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ReportingService.Api.dll"]
