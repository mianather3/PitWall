using OpenAI.Chat;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpClient();
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
        policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();
app.UseCors();

// Get all 2025 F1 sessions
app.MapGet("/api/session", async (IHttpClientFactory factory) =>
{
    var client = factory.CreateClient();
    var response = await client.GetStringAsync(
        "https://api.openf1.org/v1/sessions?session_type=Race&year=2025");
    return Results.Content(response, "application/json");
});

// Get driver positions for a session
app.MapGet("/api/positions/{sessionKey}", async (int sessionKey, IHttpClientFactory factory) =>
{
    var client = factory.CreateClient();
    var response = await client.GetStringAsync(
        $"https://api.openf1.org/v1/position?session_key={sessionKey}");
    return Results.Content(response, "application/json");
});

// AI pit stop strategy endpoint
app.MapPost("/api/strategy", async (StrategyRequest request) =>
{
    var apiKey = Environment.GetEnvironmentVariable("OPENAI_API_KEY");
    if (string.IsNullOrEmpty(apiKey))
        return Results.Problem("OpenAI API key not configured");

    var chatClient = new ChatClient("gpt-4o-mini", apiKey);

    var prompt = $"""
        You are an expert Formula 1 race strategist. Analyze the following race situation and provide a concise pit stop strategy recommendation.

        Race: {request.CircuitName}, {request.CountryName}
        Driver: {request.DriverName} (Car #{request.DriverNumber})
        Current Lap: {request.CurrentLap} of {request.TotalLaps}
        Current Position: P{request.Position}
        Tire Compound: {request.TireCompound}
        Tire Age: {request.TireAge} laps
        Gap to car ahead: {request.GapAhead} seconds
        Gap to car behind: {request.GapBehind} seconds
        Track Conditions: {request.WeatherCondition}

        Provide:
        1. Pit stop recommendation (pit now / stay out / prepare to pit)
        2. Recommended tire compound for next stint
        3. Brief reasoning (2-3 sentences max)
        4. Risk level (Low / Medium / High)

        Be direct and concise like a real F1 strategist on the pit wall radio.
        """;

    var completion = await chatClient.CompleteChatAsync(prompt);
    var strategy = completion.Value.Content[0].Text;

    return Results.Ok(new { strategy, generatedAt = DateTime.UtcNow });
});

// Get live race data for a session (drivers, positions, laps, intervals)
app.MapGet("/api/live/{sessionKey}", async (int sessionKey, IHttpClientFactory factory) =>
{
    var client = factory.CreateClient();

    async Task<System.Text.Json.JsonElement> FetchSafe(string url)
    {
        try
        {
            await Task.Delay(200); // stagger requests to avoid rate limiting
            var response = await client.GetStringAsync(url);
            return System.Text.Json.JsonDocument.Parse(response).RootElement;
        }
        catch
        {
            return System.Text.Json.JsonDocument.Parse("[]").RootElement;
        }
    }

    var drivers   = await FetchSafe($"https://api.openf1.org/v1/drivers?session_key={sessionKey}");
    var positions = await FetchSafe($"https://api.openf1.org/v1/position?session_key={sessionKey}");
    var laps      = await FetchSafe($"https://api.openf1.org/v1/laps?session_key={sessionKey}");
    var intervals = await FetchSafe($"https://api.openf1.org/v1/intervals?session_key={sessionKey}");
    var stints    = await FetchSafe($"https://api.openf1.org/v1/stints?session_key={sessionKey}");

    return Results.Ok(new
    {
        sessionKey,
        fetchedAt = DateTime.UtcNow,
        drivers,
        positions,
        laps,
        intervals,
        stints
    });
});

// Get latest session key (most recent race)
app.MapGet("/api/latest-session", async (IHttpClientFactory factory) =>
{
    var client = factory.CreateClient();
    var response = await client.GetStringAsync(
        "https://api.openf1.org/v1/sessions?session_type=Race&year=2025");
    var sessions = System.Text.Json.JsonDocument.Parse(response).RootElement;
    var last = sessions[sessions.GetArrayLength() - 1];
    return Results.Ok(new
    {
        sessionKey = last.GetProperty("session_key").GetInt32(),
        circuitShortName = last.GetProperty("circuit_short_name").GetString(),
        countryName = last.GetProperty("country_name").GetString(),
        dateStart = last.GetProperty("date_start").GetString()
    });
});

app.Run();

record StrategyRequest(
    string CircuitName,
    string CountryName,
    string DriverName,
    int DriverNumber,
    int CurrentLap,
    int TotalLaps,
    int Position,
    string TireCompound,
    int TireAge,
    double GapAhead,
    double GapBehind,
    string WeatherCondition
);
