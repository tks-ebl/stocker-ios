namespace StockerWebAPI.Api.Contracts.Auth;

public sealed class LoginResponse
{
    public string AccessToken { get; init; } = string.Empty;

    public DateTimeOffset ExpiresAt { get; init; }

    public UserSummary User { get; init; } = new();

    public WarehouseSummary Warehouse { get; init; } = new();
}

public sealed class UserSummary
{
    public Guid UserId { get; init; }

    public string UserCode { get; init; } = string.Empty;

    public string UserName { get; init; } = string.Empty;
}

public sealed class WarehouseSummary
{
    public Guid WarehouseId { get; init; }

    public string WarehouseCode { get; init; } = string.Empty;

    public string WarehouseName { get; init; } = string.Empty;
}

