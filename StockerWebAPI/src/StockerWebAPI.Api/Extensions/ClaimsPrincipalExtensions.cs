using System.Security.Claims;

namespace StockerWebAPI.Api.Extensions;

public static class ClaimsPrincipalExtensions
{
    public static Guid GetRequiredUserId(this ClaimsPrincipal principal)
    {
        var raw = principal.FindFirstValue(ClaimTypes.NameIdentifier)
            ?? principal.FindFirstValue("sub")
            ?? throw new InvalidOperationException("User id claim not found.");

        return Guid.Parse(raw);
    }

    public static string GetRequiredUserCode(this ClaimsPrincipal principal)
    {
        return principal.Identity?.Name
            ?? principal.FindFirstValue("unique_name")
            ?? throw new InvalidOperationException("User code claim not found.");
    }

    public static Guid GetRequiredWarehouseId(this ClaimsPrincipal principal)
    {
        var raw = principal.FindFirstValue("warehouse_id")
            ?? throw new InvalidOperationException("Warehouse claim not found.");

        return Guid.Parse(raw);
    }
}

