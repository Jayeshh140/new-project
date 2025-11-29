FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /src

# Copy project file(s) first for better caching
COPY hello-world-api/hello-world-api.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/hello-world-api.csproj

# Copy the rest of the source
COPY . .

# Build and publish
RUN dotnet publish ./hello-world-api/hello-world-api.csproj -c Release -o /app/pub

# -------- Runtime stage --------
FROM mcr.microsoft.com/dotnet/aspnet:2.1
WORKDIR /app
COPY --from=build /app/pub .

# Expose port 5000
EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000

# Run the app
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
