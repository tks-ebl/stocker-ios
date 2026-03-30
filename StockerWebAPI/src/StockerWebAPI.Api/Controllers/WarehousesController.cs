using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using StockerWebAPI.Api.Contracts.Dashboard;
using StockerWebAPI.Api.Data;
using StockerWebAPI.Api.Extensions;

namespace StockerWebAPI.Api.Controllers;

[ApiController]
[Authorize]
[Route("warehouses/{warehouseId:guid}")]
public sealed class WarehousesController(AppDbContext dbContext) : ControllerBase
{
    [HttpGet("dashboard")]
    [ProducesResponseType<DashboardResponse>(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<DashboardResponse>> GetDashboard(Guid warehouseId)
    {
        if (User.GetRequiredWarehouseId() != warehouseId)
        {
            return Forbid();
        }

        var warehouseExists = await dbContext.Warehouses.AnyAsync(x => x.Id == warehouseId);
        if (!warehouseExists)
        {
            return NotFound();
        }

        var today = DateOnly.FromDateTime(DateTime.UtcNow.Date);
        var todayStart = new DateTimeOffset(DateTime.UtcNow.Date, TimeSpan.Zero);
        var todayEnd = todayStart.AddDays(1);

        return Ok(new DashboardResponse
        {
            WarehouseId = warehouseId,
            ShippingPlanCount = await dbContext.ShippingPlans.CountAsync(x => x.WarehouseId == warehouseId && x.ShippingDate == today),
            ShippingResultCountToday = await dbContext.ShippingResults.CountAsync(x => x.WarehouseId == warehouseId && x.ExecutedAt >= todayStart && x.ExecutedAt < todayEnd),
            InventoryItemCount = await dbContext.InventoryItems.CountAsync(x => x.WarehouseId == warehouseId)
        });
    }
}
