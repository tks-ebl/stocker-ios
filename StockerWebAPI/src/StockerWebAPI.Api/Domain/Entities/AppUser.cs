namespace StockerWebAPI.Api.Domain.Entities;

public sealed class AppUser
{
    public Guid Id { get; set; }

    public string UserCode { get; set; } = string.Empty;

    public string UserName { get; set; } = string.Empty;

    public string PasswordHash { get; set; } = string.Empty;

    public Guid WarehouseId { get; set; }

    public Warehouse Warehouse { get; set; } = null!;

    public ICollection<InventoryHistory> InventoryHistories { get; set; } = new List<InventoryHistory>();

    public ICollection<ShippingResult> ShippingResults { get; set; } = new List<ShippingResult>();
}

