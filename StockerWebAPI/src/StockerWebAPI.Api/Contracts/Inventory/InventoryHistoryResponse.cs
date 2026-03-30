namespace StockerWebAPI.Api.Contracts.Inventory;

public sealed class InventoryHistoryResponse
{
    public Guid HistoryId { get; init; }

    public Guid ItemId { get; init; }

    public DateTimeOffset MovementDateTime { get; init; }

    public int QuantityDelta { get; init; }

    public string Reason { get; init; } = string.Empty;

    public string ExecutedByUserCode { get; init; } = string.Empty;
}

