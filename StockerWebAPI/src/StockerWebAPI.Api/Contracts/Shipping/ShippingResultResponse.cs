namespace StockerWebAPI.Api.Contracts.Shipping;

public sealed class ShippingResultResponse
{
    public Guid ShippingResultId { get; init; }

    public Guid? ShippingPlanId { get; init; }

    public string ItemCode { get; init; } = string.Empty;

    public string ItemName { get; init; } = string.Empty;

    public string LocationCode { get; init; } = string.Empty;

    public string DestinationCode { get; init; } = string.Empty;

    public int Quantity { get; init; }

    public string ExecutedByUserCode { get; init; } = string.Empty;

    public DateTimeOffset ExecutedAt { get; init; }
}

