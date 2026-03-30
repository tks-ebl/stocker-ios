using Microsoft.EntityFrameworkCore;
using StockerWebAPI.Api.Domain.Entities;

namespace StockerWebAPI.Api.Data;

public sealed class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Warehouse> Warehouses => Set<Warehouse>();

    public DbSet<AppUser> Users => Set<AppUser>();

    public DbSet<InventoryItem> InventoryItems => Set<InventoryItem>();

    public DbSet<InventoryHistory> InventoryHistories => Set<InventoryHistory>();

    public DbSet<ShippingPlan> ShippingPlans => Set<ShippingPlan>();

    public DbSet<ShippingPlanItem> ShippingPlanItems => Set<ShippingPlanItem>();

    public DbSet<ShippingResult> ShippingResults => Set<ShippingResult>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Warehouse>(entity =>
        {
            entity.ToTable("warehouses");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.WarehouseCode).HasMaxLength(50).IsRequired();
            entity.Property(x => x.WarehouseName).HasMaxLength(200).IsRequired();
            entity.HasIndex(x => x.WarehouseCode).IsUnique();
        });

        modelBuilder.Entity<AppUser>(entity =>
        {
            entity.ToTable("users");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.UserCode).HasMaxLength(50).IsRequired();
            entity.Property(x => x.UserName).HasMaxLength(200).IsRequired();
            entity.Property(x => x.PasswordHash).HasMaxLength(500).IsRequired();
            entity.HasIndex(x => x.UserCode).IsUnique();
            entity.HasOne(x => x.Warehouse)
                .WithMany(x => x.Users)
                .HasForeignKey(x => x.WarehouseId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<InventoryItem>(entity =>
        {
            entity.ToTable("inventory_items");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.ItemCode).HasMaxLength(50).IsRequired();
            entity.Property(x => x.ItemName).HasMaxLength(200).IsRequired();
            entity.Property(x => x.LocationCode).HasMaxLength(50).IsRequired();
            entity.HasIndex(x => new { x.WarehouseId, x.ItemCode, x.LocationCode }).IsUnique();
            entity.HasOne(x => x.Warehouse)
                .WithMany(x => x.InventoryItems)
                .HasForeignKey(x => x.WarehouseId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<InventoryHistory>(entity =>
        {
            entity.ToTable("inventory_histories");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Reason).HasMaxLength(200).IsRequired();
            entity.HasIndex(x => new { x.WarehouseId, x.ItemId, x.MovementDateTime });
            entity.HasOne(x => x.Warehouse)
                .WithMany()
                .HasForeignKey(x => x.WarehouseId)
                .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(x => x.Item)
                .WithMany(x => x.Histories)
                .HasForeignKey(x => x.ItemId)
                .OnDelete(DeleteBehavior.Cascade);
            entity.HasOne(x => x.ExecutedByUser)
                .WithMany(x => x.InventoryHistories)
                .HasForeignKey(x => x.ExecutedByUserId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<ShippingPlan>(entity =>
        {
            entity.ToTable("shipping_plans");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.DestinationCode).HasMaxLength(50).IsRequired();
            entity.Property(x => x.DestinationName).HasMaxLength(200).IsRequired();
            entity.HasIndex(x => new { x.WarehouseId, x.ShippingDate, x.DestinationCode });
            entity.HasOne(x => x.Warehouse)
                .WithMany(x => x.ShippingPlans)
                .HasForeignKey(x => x.WarehouseId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<ShippingPlanItem>(entity =>
        {
            entity.ToTable("shipping_plan_items");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.ItemCode).HasMaxLength(50).IsRequired();
            entity.Property(x => x.ItemName).HasMaxLength(200).IsRequired();
            entity.Property(x => x.LocationCode).HasMaxLength(50).IsRequired();
            entity.HasIndex(x => new { x.ShippingPlanId, x.ItemCode, x.LocationCode }).IsUnique();
            entity.HasOne(x => x.ShippingPlan)
                .WithMany(x => x.Items)
                .HasForeignKey(x => x.ShippingPlanId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<ShippingResult>(entity =>
        {
            entity.ToTable("shipping_results");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.ExecutedByUserCode).HasMaxLength(50).IsRequired();
            entity.Property(x => x.ItemCode).HasMaxLength(50).IsRequired();
            entity.Property(x => x.ItemName).HasMaxLength(200).IsRequired();
            entity.Property(x => x.LocationCode).HasMaxLength(50).IsRequired();
            entity.Property(x => x.DestinationCode).HasMaxLength(50).IsRequired();
            entity.HasIndex(x => new { x.WarehouseId, x.ExecutedAt });
            entity.HasOne(x => x.Warehouse)
                .WithMany(x => x.ShippingResults)
                .HasForeignKey(x => x.WarehouseId)
                .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(x => x.ExecutedByUser)
                .WithMany(x => x.ShippingResults)
                .HasForeignKey(x => x.ExecutedByUserId)
                .OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(x => x.ShippingPlan)
                .WithMany()
                .HasForeignKey(x => x.ShippingPlanId)
                .OnDelete(DeleteBehavior.SetNull);
        });
    }
}
