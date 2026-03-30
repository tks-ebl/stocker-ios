using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using StockerWebAPI.Api.Contracts.Shipping;
using StockerWebAPI.Api.Data;
using StockerWebAPI.Api.Domain.Entities;
using StockerWebAPI.Api.Errors;
using StockerWebAPI.Api.Extensions;

namespace StockerWebAPI.Api.Controllers;

[ApiController]
[Authorize]
[Route("warehouses/{warehouseId:guid}/shipping-results")]
public sealed class ShippingResultsController(AppDbContext dbContext) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType<IReadOnlyCollection<ShippingResultResponse>>(StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyCollection<ShippingResultResponse>>> GetShippingResults(
        Guid warehouseId,
        [FromQuery] DateTimeOffset? dateFrom,
        [FromQuery] DateTimeOffset? dateTo,
        [FromQuery] string? userCode)
    {
        if (User.GetRequiredWarehouseId() != warehouseId)
        {
            return Forbid();
        }

        var query = dbContext.ShippingResults
            .AsNoTracking()
            .Where(x => x.WarehouseId == warehouseId);

        if (dateFrom.HasValue)
        {
            query = query.Where(x => x.ExecutedAt >= dateFrom.Value);
        }

        if (dateTo.HasValue)
        {
            query = query.Where(x => x.ExecutedAt <= dateTo.Value);
        }

        if (!string.IsNullOrWhiteSpace(userCode))
        {
            query = query.Where(x => x.ExecutedByUserCode.Contains(userCode));
        }

        var results = await query
            .OrderByDescending(x => x.ExecutedAt)
            .Select(x => new ShippingResultResponse
            {
                ShippingResultId = x.Id,
                ShippingPlanId = x.ShippingPlanId,
                ItemCode = x.ItemCode,
                ItemName = x.ItemName,
                LocationCode = x.LocationCode,
                DestinationCode = x.DestinationCode,
                Quantity = x.Quantity,
                ExecutedByUserCode = x.ExecutedByUserCode,
                ExecutedAt = x.ExecutedAt
            })
            .ToListAsync();

        return Ok(results);
    }

    [HttpPost]
    [ProducesResponseType<CreateShippingResultsResponse>(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<CreateShippingResultsResponse>> CreateShippingResults(
        Guid warehouseId,
        [FromBody] CreateShippingResultsRequest request)
    {
        if (User.GetRequiredWarehouseId() != warehouseId)
        {
            return Forbid();
        }

        if (request.Results.Count == 0)
        {
            throw new DomainValidationException("At least one shipping result is required.");
        }

        var userId = User.GetRequiredUserId();
        var userCode = User.GetRequiredUserCode();
        var executedAt = request.ExecutedAt ?? DateTimeOffset.UtcNow;
        var duplicateLines = request.Results
            .GroupBy(x => $"{x.ItemCode}::{x.LocationCode}")
            .Where(group => group.Count() > 1)
            .Select(group => group.Key)
            .ToArray();

        if (duplicateLines.Length > 0)
        {
            throw new DomainValidationException($"Duplicate shipping lines are not allowed: {string.Join(", ", duplicateLines)}.");
        }

        ShippingPlan? shippingPlan = null;
        Dictionary<string, ShippingPlanItem>? shippingPlanItemsMap = null;

        if (request.ShippingPlanId.HasValue)
        {
            shippingPlan = await dbContext.ShippingPlans
                .Include(x => x.Items)
                .SingleOrDefaultAsync(x => x.Id == request.ShippingPlanId.Value && x.WarehouseId == warehouseId);

            if (shippingPlan is null)
            {
                throw new DomainValidationException("Shipping plan was not found for the warehouse.");
            }

            if (!string.Equals(shippingPlan.DestinationCode, request.DestinationCode, StringComparison.Ordinal))
            {
                throw new DomainValidationException("Destination code does not match the selected shipping plan.");
            }

            shippingPlanItemsMap = shippingPlan.Items.ToDictionary(x => $"{x.ItemCode}::{x.LocationCode}", x => x);
        }

        var inventoryMap = await dbContext.InventoryItems
            .Where(x => x.WarehouseId == warehouseId)
            .ToDictionaryAsync(x => $"{x.ItemCode}::{x.LocationCode}", x => x);

        await using var transaction = await dbContext.Database.BeginTransactionAsync();

        foreach (var line in request.Results)
        {
            var key = $"{line.ItemCode}::{line.LocationCode}";
            if (!inventoryMap.TryGetValue(key, out var inventoryItem))
            {
                throw new DomainValidationException($"Inventory item not found for {line.ItemCode} at {line.LocationCode}.");
            }

            if (inventoryItem.Quantity < line.Quantity)
            {
                throw new DomainValidationException($"Insufficient inventory for {line.ItemCode} at {line.LocationCode}.");
            }

            if (shippingPlanItemsMap is not null)
            {
                if (!shippingPlanItemsMap.TryGetValue(key, out var shippingPlanItem))
                {
                    throw new DomainValidationException($"Shipping plan item not found for {line.ItemCode} at {line.LocationCode}.");
                }

                if (shippingPlanItem.ActualQuantity + line.Quantity > shippingPlanItem.PlannedQuantity)
                {
                    throw new DomainValidationException($"Actual quantity would exceed planned quantity for {line.ItemCode} at {line.LocationCode}.");
                }

                shippingPlanItem.ActualQuantity += line.Quantity;
            }

            inventoryItem.Quantity -= line.Quantity;

            await dbContext.InventoryHistories.AddAsync(new InventoryHistory
            {
                Id = Guid.NewGuid(),
                WarehouseId = warehouseId,
                ItemId = inventoryItem.Id,
                ExecutedByUserId = userId,
                MovementDateTime = executedAt,
                QuantityDelta = -line.Quantity,
                Reason = "出荷実績登録"
            });

            await dbContext.ShippingResults.AddAsync(new ShippingResult
            {
                Id = Guid.NewGuid(),
                WarehouseId = warehouseId,
                ShippingPlanId = request.ShippingPlanId,
                ExecutedByUserId = userId,
                ExecutedByUserCode = userCode,
                ItemCode = line.ItemCode,
                ItemName = line.ItemName,
                LocationCode = line.LocationCode,
                DestinationCode = request.DestinationCode,
                Quantity = line.Quantity,
                ExecutedAt = executedAt
            });
        }

        await dbContext.SaveChangesAsync();
        await transaction.CommitAsync();

        return CreatedAtAction(nameof(GetShippingResults), new { warehouseId }, new CreateShippingResultsResponse
        {
            WarehouseId = warehouseId,
            CreatedCount = request.Results.Count,
            ExecutedAt = executedAt
        });
    }
}
