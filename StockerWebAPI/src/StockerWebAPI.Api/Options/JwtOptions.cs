namespace StockerWebAPI.Api.Options;

public sealed class JwtOptions
{
    public const string SectionName = "Jwt";

    public string Issuer { get; init; } = "StockerWebAPI";

    public string Audience { get; init; } = "StockerClients";

    public string SigningKey { get; init; } = "ChangeThisToALongRandomSecretForDevelopmentOnly123!";

    public int ExpiryMinutes { get; init; } = 480;
}

