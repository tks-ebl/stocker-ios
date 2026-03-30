namespace StockerWebAPI.Api.Domain.Entities;

public sealed class Warehouse
{
    public Guid Id { get; set; }

    public string WarehouseCode { get; set; } = string.Empty;

    public string WarehouseName { get; set; } = string.Empty;

    public ICollection<AppUser> Users { get; set; } = new List<AppUser>();

    public ICollection<InventoryItem> InventoryItems { get; set; } = new List<InventoryItem>();

    public ICollection<ShippingPlan> ShippingPlans { get; set; } = new List<ShippingPlan>();

    public ICollection<ShippingResult> ShippingResults { get; set; } = new List<ShippingResult>();
}

