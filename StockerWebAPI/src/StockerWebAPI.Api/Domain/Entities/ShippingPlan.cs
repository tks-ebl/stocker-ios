namespace StockerWebAPI.Api.Domain.Entities;

public sealed class ShippingPlan
{
    public Guid Id { get; set; }

    public Guid WarehouseId { get; set; }

    public DateOnly ShippingDate { get; set; }

    public string DestinationCode { get; set; } = string.Empty;

    public string DestinationName { get; set; } = string.Empty;

    public Warehouse Warehouse { get; set; } = null!;

    public ICollection<ShippingPlanItem> Items { get; set; } = new List<ShippingPlanItem>();
}

