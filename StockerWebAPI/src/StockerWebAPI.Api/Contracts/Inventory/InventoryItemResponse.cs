namespace StockerWebAPI.Api.Contracts.Inventory;

public sealed class InventoryItemResponse
{
    public Guid ItemId { get; init; }

    public string ItemCode { get; init; } = string.Empty;

    public string ItemName { get; init; } = string.Empty;

    public string LocationCode { get; init; } = string.Empty;

    public int Quantity { get; init; }
}

