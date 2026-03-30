using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using StockerWebAPI.Api.Contracts.Inventory;
using StockerWebAPI.Api.Data;
using StockerWebAPI.Api.Extensions;

namespace StockerWebAPI.Api.Controllers;

[ApiController]
[Authorize]
[Route("warehouses/{warehouseId:guid}/inventory")]
public sealed class InventoryController(AppDbContext dbContext) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType<IReadOnlyCollection<InventoryItemResponse>>(StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<InventoryItemResponse>>> GetInventory(
        Guid warehouseId,
        [FromQuery] string? itemCode,
        [FromQuery] string? itemName,
        [FromQuery] string? locationCode)
    {
        if (User.GetRequiredWarehouseId() != warehouseId)
        {
            return Forbid();
        }

        var query = dbContext.InventoryItems
            .AsNoTracking()
            .Where(x => x.WarehouseId == warehouseId);

        if (!string.IsNullOrWhiteSpace(itemCode))
        {
            query = query.Where(x => x.ItemCode.Contains(itemCode));
        }

        if (!string.IsNullOrWhiteSpace(itemName))
        {
            query = query.Where(x => x.ItemName.Contains(itemName));
        }

        if (!string.IsNullOrWhiteSpace(locationCode))
        {
            query = query.Where(x => x.LocationCode.Contains(locationCode));
        }

        var items = await query
            .OrderBy(x => x.LocationCode)
            .ThenBy(x => x.ItemCode)
            .Select(x => new InventoryItemResponse
            {
                ItemId = x.Id,
                ItemCode = x.ItemCode,
                ItemName = x.ItemName,
                LocationCode = x.LocationCode,
                Quantity = x.Quantity
            })
            .ToListAsync();

        return Ok(items);
    }

    [HttpGet("{itemId:guid}/history")]
    [ProducesResponseType<IReadOnlyCollection<InventoryHistoryResponse>>(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<IReadOnlyCollection<InventoryHistoryResponse>>> GetInventoryHistory(Guid warehouseId, Guid itemId)
    {
        if (User.GetRequiredWarehouseId() != warehouseId)
        {
            return Forbid();
        }

        var exists = await dbContext.InventoryItems.AnyAsync(x => x.Id == itemId && x.WarehouseId == warehouseId);
        if (!exists)
        {
            return NotFound();
        }

        var histories = await dbContext.InventoryHistories
            .AsNoTracking()
            .Where(x => x.WarehouseId == warehouseId && x.ItemId == itemId)
            .OrderByDescending(x => x.MovementDateTime)
            .Select(x => new InventoryHistoryResponse
            {
                HistoryId = x.Id,
                ItemId = x.ItemId,
                MovementDateTime = x.MovementDateTime,
                QuantityDelta = x.QuantityDelta,
                Reason = x.Reason,
                ExecutedByUserCode = x.ExecutedByUser.UserCode
            })
            .ToListAsync();

        return Ok(histories);
    }
}

