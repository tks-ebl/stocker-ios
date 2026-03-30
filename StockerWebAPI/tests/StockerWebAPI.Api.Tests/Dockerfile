FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /src

COPY ["src/StockerWebAPI.Api/StockerWebAPI.Api.csproj", "src/StockerWebAPI.Api/"]
COPY ["tests/StockerWebAPI.Api.Tests/StockerWebAPI.Api.Tests.csproj", "tests/StockerWebAPI.Api.Tests/"]
RUN dotnet restore "tests/StockerWebAPI.Api.Tests/StockerWebAPI.Api.Tests.csproj"

COPY . .

CMD ["dotnet", "test", "tests/StockerWebAPI.Api.Tests/StockerWebAPI.Api.Tests.csproj", "-c", "Release", "--no-restore"]

