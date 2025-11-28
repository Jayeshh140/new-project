# Use official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:2.0 AS build

WORKDIR /src
# copy csproj and restore first (better caching)
COPY *.sln ./
COPY hello-world-api/hello-world-api.csproj hello-world-api/
RUN dotnet restore

# copy everything else and build
COPY . ./
WORKDIR /src/hello-world-api
RUN dotnet publish -c Release -o /app/publish

# build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish ./

# (optional) expose port; change if your API runs on a different port
EXPOSE 5000

ENTRYPOINT ["dotnet", "hello-world-api.dll"]
