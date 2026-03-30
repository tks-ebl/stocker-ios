namespace StockerWebAPI.Api.Domain.Entities;

public sealed class ShippingResult
{
    public Guid Id { get; set; }

    public Guid WarehouseId { get; set; }

    public Guid? ShippingPlanId { get; set; }

    public Guid ExecutedByUserId { get; set; }

    public string ExecutedByUserCode { get; set; } = string.Empty;

    public string ItemCode { get; set; } = string.Empty;

    public string ItemName { get; set; } = string.Empty;

    public string LocationCode { get; set; } = string.Empty;

    public string DestinationCode { get; set; } = string.Empty;

    public int Quantity { get; set; }

    public DateTimeOffset ExecutedAt { get; set; }

    public Warehouse Warehouse { get; set; } = null!;

    public ShippingPlan? ShippingPlan { get; set; }

    public AppUser ExecutedByUser { get; set; } = null!;
}

