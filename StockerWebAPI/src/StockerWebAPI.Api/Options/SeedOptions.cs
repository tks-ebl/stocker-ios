namespace StockerWebAPI.Api.Options;

public sealed class SeedOptions
{
    public const string SectionName = "Seed";

    public bool EnableDemoSeed { get; init; } = true;
}

