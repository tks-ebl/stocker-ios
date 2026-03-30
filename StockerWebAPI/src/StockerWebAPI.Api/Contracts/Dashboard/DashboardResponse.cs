namespace StockerWebAPI.Api.Contracts.Dashboard;

public sealed class DashboardResponse
{
    public Guid WarehouseId { get; init; }

    public int ShippingPlanCount { get; init; }

    public int ShippingResultCountToday { get; init; }

    public int InventoryItemCount { get; init; }
}

