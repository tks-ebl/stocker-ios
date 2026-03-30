using Microsoft.EntityFrameworkCore;
using StockerWebAPI.Api.Domain.Entities;
using StockerWebAPI.Api.Options;
using StockerWebAPI.Api.Security;

namespace StockerWebAPI.Api.Data;

public static class DbInitializer
{
    public static async Task InitializeAsync(AppDbContext dbContext, IPasswordHasher passwordHasher, SeedOptions seedOptions)
    {
        await dbContext.Database.MigrateAsync();

        if (!seedOptions.EnableDemoSeed || await dbContext.Warehouses.AnyAsync())
        {
            return;
        }

        var warehouseId = Guid.Parse("11111111-1111-1111-1111-111111111111");
        var workerId = Guid.Parse("22222222-2222-2222-2222-222222222222");
        var leaderId = Guid.Parse("33333333-3333-3333-3333-333333333333");
        var itemAId = Guid.Parse("44444444-4444-4444-4444-444444444444");
        var itemBId = Guid.Parse("55555555-5555-5555-5555-555555555555");
        var planId = Guid.Parse("66666666-6666-6666-6666-666666666666");

        var warehouse = new Warehouse
        {
            Id = warehouseId,
            WarehouseCode = "TOKYO-01",
            WarehouseName = "東京メイン倉庫"
        };

        var worker = new AppUser
        {
            Id = workerId,
            UserCode = "worker01",
            UserName = "作業者01",
            PasswordHash = passwordHasher.Hash("Passw0rd!"),
            WarehouseId = warehouseId
        };

        var leader = new AppUser
        {
            Id = leaderId,
            UserCode = "leader01",
            UserName = "リーダー01",
            PasswordHash = passwordHasher.Hash("Passw0rd!"),
            WarehouseId = warehouseId
        };

        var inventoryItems = new[]
        {
            new InventoryItem
            {
                Id = itemAId,
                WarehouseId = warehouseId,
                ItemCode = "ITEM-001",
                ItemName = "防災ライト",
                LocationCode = "A-01-01",
                Quantity = 120
            },
            new InventoryItem
            {
                Id = itemBId,
                WarehouseId = warehouseId,
                ItemCode = "ITEM-002",
                ItemName = "保存水 500ml",
                LocationCode = "B-02-03",
                Quantity = 320
            }
        };

        var shippingPlan = new ShippingPlan
        {
            Id = planId,
            WarehouseId = warehouseId,
            ShippingDate = DateOnly.FromDateTime(DateTime.UtcNow.Date),
            DestinationCode = "DEST-001",
            DestinationName = "品川物流センター",
            Items =
            {
                new ShippingPlanItem
                {
                    Id = Guid.Parse("77777777-7777-7777-7777-777777777777"),
                    ItemCode = "ITEM-001",
                    ItemName = "防災ライト",
                    LocationCode = "A-01-01",
                    PlannedQuantity = 10,
                    ActualQuantity = 0
                },
                new ShippingPlanItem
                {
                    Id = Guid.Parse("88888888-8888-8888-8888-888888888888"),
                    ItemCode = "ITEM-002",
                    ItemName = "保存水 500ml",
                    LocationCode = "B-02-03",
                    PlannedQuantity = 24,
                    ActualQuantity = 0
                }
            }
        };

        var histories = new[]
        {
            new InventoryHistory
            {
                Id = Guid.Parse("99999999-9999-9999-9999-999999999999"),
                WarehouseId = warehouseId,
                ItemId = itemAId,
                ExecutedByUserId = leaderId,
                MovementDateTime = DateTimeOffset.UtcNow.AddDays(-3),
                QuantityDelta = 50,
                Reason = "初期入荷"
            },
            new InventoryHistory
            {
                Id = Guid.Parse("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"),
                WarehouseId = warehouseId,
                ItemId = itemAId,
                ExecutedByUserId = workerId,
                MovementDateTime = DateTimeOffset.UtcNow.AddDays(-1),
                QuantityDelta = -10,
                Reason = "出荷作業"
            },
            new InventoryHistory
            {
                Id = Guid.Parse("bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"),
                WarehouseId = warehouseId,
                ItemId = itemBId,
                ExecutedByUserId = leaderId,
                MovementDateTime = DateTimeOffset.UtcNow.AddDays(-2),
                QuantityDelta = 100,
                Reason = "初期入荷"
            }
        };

        var shippingResults = new[]
        {
            new ShippingResult
            {
                Id = Guid.Parse("cccccccc-cccc-cccc-cccc-cccccccccccc"),
                WarehouseId = warehouseId,
                ShippingPlanId = planId,
                ExecutedByUserId = workerId,
                ExecutedByUserCode = worker.UserCode,
                ItemCode = "ITEM-001",
                ItemName = "防災ライト",
                LocationCode = "A-01-01",
                DestinationCode = "DEST-001",
                Quantity = 4,
                ExecutedAt = DateTimeOffset.UtcNow.AddHours(-6)
            }
        };

        await dbContext.Warehouses.AddAsync(warehouse);
        await dbContext.Users.AddRangeAsync(worker, leader);
        await dbContext.InventoryItems.AddRangeAsync(inventoryItems);
        await dbContext.ShippingPlans.AddAsync(shippingPlan);
        await dbContext.InventoryHistories.AddRangeAsync(histories);
        await dbContext.ShippingResults.AddRangeAsync(shippingResults);
        await dbContext.SaveChangesAsync();
    }
}
