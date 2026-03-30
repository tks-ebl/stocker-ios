namespace StockerWebAPI.Api.Contracts.Shipping;

public sealed class ShippingPlanResponse
{
    public Guid ShippingPlanId { get; init; }

    public DateOnly ShippingDate { get; init; }

    public string DestinationCode { get; init; } = string.Empty;

    public string DestinationName { get; init; } = string.Empty;

    public IReadOnlyCollection<ShippingPlanItemResponse> Items { get; init; } = [];
}

public sealed class ShippingPlanItemResponse
{
    public Guid ShippingPlanItemId { get; init; }

    public string ItemCode { get; init; } = string.Empty;

    public string ItemName { get; init; } = string.Empty;

    public string LocationCode { get; init; } = string.Empty;

    public int PlannedQuantity { get; init; }

    public int ActualQuantity { get; init; }
}

