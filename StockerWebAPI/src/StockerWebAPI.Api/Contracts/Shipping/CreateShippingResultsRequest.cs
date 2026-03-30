using System.ComponentModel.DataAnnotations;

namespace StockerWebAPI.Api.Contracts.Shipping;

public sealed class CreateShippingResultsRequest
{
    public Guid? ShippingPlanId { get; set; }

    [Required]
    [MaxLength(50)]
    public string DestinationCode { get; set; } = string.Empty;

    public DateTimeOffset? ExecutedAt { get; set; }

    [Required]
    [MinLength(1)]
    public List<CreateShippingResultItemRequest> Results { get; set; } = [];
}

public sealed class CreateShippingResultItemRequest
{
    [Required]
    [MaxLength(50)]
    public string ItemCode { get; set; } = string.Empty;

    [Required]
    [MaxLength(200)]
    public string ItemName { get; set; } = string.Empty;

    [Required]
    [MaxLength(50)]
    public string LocationCode { get; set; } = string.Empty;

    [Range(1, int.MaxValue)]
    public int Quantity { get; set; }
}

public sealed class CreateShippingResultsResponse
{
    public Guid WarehouseId { get; init; }

    public int CreatedCount { get; init; }

    public DateTimeOffset ExecutedAt { get; init; }
}

