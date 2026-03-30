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

app.MapGet("/api/session", async (IHttpClientFactory factory) =>
{
    var client = factory.CreateClient();
    var response = await client.GetStringAsync(
        "https://api.openf1.org/v1/sessions?session_type=Race&year=2025");
    return Results.Content(response, "application/json");
});

app.MapGet("/api/positions/{sessionKey}", async (int sessionKey, IHttpClientFactory factory) =>
{
    var client = factory.CreateClient();
    var response = await client.GetStringAsync(
        $"https://api.openf1.org/v1/position?session_key={sessionKey}");
    return Results.Content(response, "application/json");
});

app.Run();
