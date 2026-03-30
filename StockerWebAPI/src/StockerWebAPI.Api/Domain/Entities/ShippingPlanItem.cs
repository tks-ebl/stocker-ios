namespace StockerWebAPI.Api.Domain.Entities;

public sealed class ShippingPlanItem
{
    public Guid Id { get; set; }

    public Guid ShippingPlanId { get; set; }

    public ShippingPlan ShippingPlan { get; set; } = null!;

    public string ItemCode { get; set; } = string.Empty;

    public string ItemName { get; set; } = string.Empty;

    public string LocationCode { get; set; } = string.Empty;

    public int PlannedQuantity { get; set; }

    public int ActualQuantity { get; set; }
}

