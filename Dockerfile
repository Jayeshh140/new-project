# Build stage
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /src

# Copy project file(s) first for better caching
COPY hello-world-api/hello-world-api.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/hello-world-api.csproj

# Copy the rest of the source
COPY . .

# Build and publish
RUN dotnet publish ./hello-world-api/hello-world-api.csproj -c Release -o /app/publish
