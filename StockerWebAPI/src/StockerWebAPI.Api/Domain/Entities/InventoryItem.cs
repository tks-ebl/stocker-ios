namespace StockerWebAPI.Api.Domain.Entities;

public sealed class InventoryItem
{
    public Guid Id { get; set; }

    public Guid WarehouseId { get; set; }

    public Warehouse Warehouse { get; set; } = null!;

    public string ItemCode { get; set; } = string.Empty;

    public string ItemName { get; set; } = string.Empty;

    public string LocationCode { get; set; } = string.Empty;

    public int Quantity { get; set; }

    public ICollection<InventoryHistory> Histories { get; set; } = new List<InventoryHistory>();
}

