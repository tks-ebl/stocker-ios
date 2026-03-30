FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["src/StockerWebAPI.Api/StockerWebAPI.Api.csproj", "src/StockerWebAPI.Api/"]
RUN dotnet restore "src/StockerWebAPI.Api/StockerWebAPI.Api.csproj"

COPY . .
RUN dotnet publish "src/StockerWebAPI.Api/StockerWebAPI.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "StockerWebAPI.Api.dll"]

