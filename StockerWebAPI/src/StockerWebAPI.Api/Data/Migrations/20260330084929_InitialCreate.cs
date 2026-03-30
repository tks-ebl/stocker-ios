using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace StockerWebAPI.Api.Data.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "warehouses",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    WarehouseCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    WarehouseName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_warehouses", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "inventory_items",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    WarehouseId = table.Column<Guid>(type: "uuid", nullable: false),
                    ItemCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    ItemName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    LocationCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Quantity = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_inventory_items", x => x.Id);
                    table.ForeignKey(
                        name: "FK_inventory_items_warehouses_WarehouseId",
                        column: x => x.WarehouseId,
                        principalTable: "warehouses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "shipping_plans",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    WarehouseId = table.Column<Guid>(type: "uuid", nullable: false),
                    ShippingDate = table.Column<DateOnly>(type: "date", nullable: false),
                    DestinationCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    DestinationName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_shipping_plans", x => x.Id);
                    table.ForeignKey(
                        name: "FK_shipping_plans_warehouses_WarehouseId",
                        column: x => x.WarehouseId,
                        principalTable: "warehouses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "users",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    UserName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    PasswordHash = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    WarehouseId = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_users_warehouses_WarehouseId",
                        column: x => x.WarehouseId,
                        principalTable: "warehouses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "shipping_plan_items",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ShippingPlanId = table.Column<Guid>(type: "uuid", nullable: false),
                    ItemCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    ItemName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    LocationCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    PlannedQuantity = table.Column<int>(type: "integer", nullable: false),
                    ActualQuantity = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_shipping_plan_items", x => x.Id);
                    table.ForeignKey(
                        name: "FK_shipping_plan_items_shipping_plans_ShippingPlanId",
                        column: x => x.ShippingPlanId,
                        principalTable: "shipping_plans",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "inventory_histories",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    WarehouseId = table.Column<Guid>(type: "uuid", nullable: false),
                    ItemId = table.Column<Guid>(type: "uuid", nullable: false),
                    ExecutedByUserId = table.Column<Guid>(type: "uuid", nullable: false),
                    MovementDateTime = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    QuantityDelta = table.Column<int>(type: "integer", nullable: false),
                    Reason = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_inventory_histories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_inventory_histories_inventory_items_ItemId",
                        column: x => x.ItemId,
                        principalTable: "inventory_items",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_inventory_histories_users_ExecutedByUserId",
                        column: x => x.ExecutedByUserId,
                        principalTable: "users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_inventory_histories_warehouses_WarehouseId",
                        column: x => x.WarehouseId,
                        principalTable: "warehouses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "shipping_results",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    WarehouseId = table.Column<Guid>(type: "uuid", nullable: false),
                    ShippingPlanId = table.Column<Guid>(type: "uuid", nullable: true),
                    ExecutedByUserId = table.Column<Guid>(type: "uuid", nullable: false),
                    ExecutedByUserCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    ItemCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    ItemName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    LocationCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    DestinationCode = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    Quantity = table.Column<int>(type: "integer", nullable: false),
                    ExecutedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_shipping_results", x => x.Id);
                    table.ForeignKey(
                        name: "FK_shipping_results_shipping_plans_ShippingPlanId",
                        column: x => x.ShippingPlanId,
                        principalTable: "shipping_plans",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_shipping_results_users_ExecutedByUserId",
                        column: x => x.ExecutedByUserId,
                        principalTable: "users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_shipping_results_warehouses_WarehouseId",
                        column: x => x.WarehouseId,
                        principalTable: "warehouses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_inventory_histories_ExecutedByUserId",
                table: "inventory_histories",
                column: "ExecutedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_inventory_histories_ItemId",
                table: "inventory_histories",
                column: "ItemId");

            migrationBuilder.CreateIndex(
                name: "IX_inventory_histories_WarehouseId_ItemId_MovementDateTime",
                table: "inventory_histories",
                columns: new[] { "WarehouseId", "ItemId", "MovementDateTime" });

            migrationBuilder.CreateIndex(
                name: "IX_inventory_items_WarehouseId_ItemCode_LocationCode",
                table: "inventory_items",
                columns: new[] { "WarehouseId", "ItemCode", "LocationCode" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_shipping_plan_items_ShippingPlanId_ItemCode_LocationCode",
                table: "shipping_plan_items",
                columns: new[] { "ShippingPlanId", "ItemCode", "LocationCode" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_shipping_plans_WarehouseId_ShippingDate_DestinationCode",
                table: "shipping_plans",
                columns: new[] { "WarehouseId", "ShippingDate", "DestinationCode" });

            migrationBuilder.CreateIndex(
                name: "IX_shipping_results_ExecutedByUserId",
                table: "shipping_results",
                column: "ExecutedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_shipping_results_ShippingPlanId",
                table: "shipping_results",
                column: "ShippingPlanId");

            migrationBuilder.CreateIndex(
                name: "IX_shipping_results_WarehouseId_ExecutedAt",
                table: "shipping_results",
                columns: new[] { "WarehouseId", "ExecutedAt" });

            migrationBuilder.CreateIndex(
                name: "IX_users_UserCode",
                table: "users",
                column: "UserCode",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_users_WarehouseId",
                table: "users",
                column: "WarehouseId");

            migrationBuilder.CreateIndex(
                name: "IX_warehouses_WarehouseCode",
                table: "warehouses",
                column: "WarehouseCode",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "inventory_histories");

            migrationBuilder.DropTable(
                name: "shipping_plan_items");

            migrationBuilder.DropTable(
                name: "shipping_results");

            migrationBuilder.DropTable(
                name: "inventory_items");

            migrationBuilder.DropTable(
                name: "shipping_plans");

            migrationBuilder.DropTable(
                name: "users");

            migrationBuilder.DropTable(
                name: "warehouses");
        }
    }
}
