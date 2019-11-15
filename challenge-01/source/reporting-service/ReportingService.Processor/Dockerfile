FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["ReportingService.Processor/ReportingService.Processor.csproj", "ReportingService.Processor/"]
RUN dotnet restore "ReportingService.Processor/ReportingService.Processor.csproj"
COPY . .
WORKDIR "/src/ReportingService.Processor"
RUN dotnet build "ReportingService.Processor.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "ReportingService.Processor.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .

# <wkhtmltopdf>
ENV PATH=/app;$PATH
RUN apt-get update
RUN apt-get install wget fontconfig libfreetype6 libx11-6 libxcb1 libxext6 libxrender1 xfonts-75dpi xfonts-base libjpeg62-turbo multiarch-support -y

RUN wget https://github.com/robece/microservices-aks/raw/master/challenge-01/source/docker-dependencies/libssl1.0.0_1.0.1t-1%2Bdeb8u12_amd64.deb
RUN dpkg -i libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb

RUN wget https://github.com/robece/microservices-aks/raw/master/challenge-01/source/docker-dependencies/libpng12-0_1.2.50-2%2Bdeb8u3_amd64.deb
RUN dpkg -i libpng12-0_1.2.50-2+deb8u3_amd64.deb

RUN wget https://github.com/robece/microservices-aks/raw/master/challenge-01/source/docker-dependencies/wkhtmltox_0.12.5-1.jessie_amd64.deb
RUN dpkg -i wkhtmltox_0.12.5-1.jessie_amd64.deb

RUN cp /usr/local/bin/wkhtmlto* /usr/bin/
# </wkhtmltopdf>

ENTRYPOINT ["dotnet", "ReportingService.Processor.dll"]
