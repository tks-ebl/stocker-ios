using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using StockerWebAPI.Api.Contracts.Shipping;
using StockerWebAPI.Api.Data;
using StockerWebAPI.Api.Extensions;

namespace StockerWebAPI.Api.Controllers;

[ApiController]
[Authorize]
[Route("warehouses/{warehouseId:guid}/shipping-plans")]
public sealed class ShippingPlansController(AppDbContext dbContext) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType<IReadOnlyCollection<ShippingPlanResponse>>(StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<ShippingPlanResponse>>> GetShippingPlans(
        Guid warehouseId,
        [FromQuery] DateOnly? shippingDate,
        [FromQuery] string? destinationCode)
    {
        if (User.GetRequiredWarehouseId() != warehouseId)
        {
            return Forbid();
        }

        var query = dbContext.ShippingPlans
            .AsNoTracking()
            .Include(x => x.Items)
            .Where(x => x.WarehouseId == warehouseId);

        if (shippingDate.HasValue)
        {
            query = query.Where(x => x.ShippingDate == shippingDate.Value);
        }

        if (!string.IsNullOrWhiteSpace(destinationCode))
        {
            query = query.Where(x => x.DestinationCode.Contains(destinationCode));
        }

        var plans = await query
            .OrderBy(x => x.ShippingDate)
            .ThenBy(x => x.DestinationCode)
            .Select(x => new ShippingPlanResponse
            {
                ShippingPlanId = x.Id,
                ShippingDate = x.ShippingDate,
                DestinationCode = x.DestinationCode,
                DestinationName = x.DestinationName,
                Items = x.Items
                    .OrderBy(item => item.LocationCode)
                    .ThenBy(item => item.ItemCode)
                    .Select(item => new ShippingPlanItemResponse
                    {
                        ShippingPlanItemId = item.Id,
                        ItemCode = item.ItemCode,
                        ItemName = item.ItemName,
                        LocationCode = item.LocationCode,
                        PlannedQuantity = item.PlannedQuantity,
                        ActualQuantity = item.ActualQuantity
                    })
                    .ToList()
            })
            .ToListAsync();

        return Ok(plans);
    }
}

