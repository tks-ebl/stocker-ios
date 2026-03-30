namespace StockerWebAPI.Api.Domain.Entities;

public sealed class InventoryHistory
{
    public Guid Id { get; set; }

    public Guid WarehouseId { get; set; }

    public Guid ItemId { get; set; }

    public Guid ExecutedByUserId { get; set; }

    public DateTimeOffset MovementDateTime { get; set; }

    public int QuantityDelta { get; set; }

    public string Reason { get; set; } = string.Empty;

    public Warehouse Warehouse { get; set; } = null!;

    public InventoryItem Item { get; set; } = null!;

    public AppUser ExecutedByUser { get; set; } = null!;
}

