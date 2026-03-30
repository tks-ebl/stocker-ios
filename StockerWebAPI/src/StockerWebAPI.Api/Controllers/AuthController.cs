using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using StockerWebAPI.Api.Contracts.Auth;
using StockerWebAPI.Api.Data;
using StockerWebAPI.Api.Security;

namespace StockerWebAPI.Api.Controllers;

[ApiController]
[Route("auth")]
public sealed class AuthController(
    AppDbContext dbContext,
    IPasswordHasher passwordHasher,
    ITokenService tokenService) : ControllerBase
{
    [HttpPost("login")]
    [ProducesResponseType<LoginResponse>(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<LoginResponse>> Login([FromBody] LoginRequest request)
    {
        var user = await dbContext.Users
            .Include(x => x.Warehouse)
            .SingleOrDefaultAsync(x => x.UserCode == request.UserCode);

        if (user is null || !passwordHasher.Verify(request.Password, user.PasswordHash))
        {
            return Unauthorized(new ProblemDetails
            {
                Title = "Authentication failed",
                Detail = "User code or password is invalid."
            });
        }

        var (token, expiresAt) = tokenService.CreateToken(user, user.Warehouse);

        return Ok(new LoginResponse
        {
            AccessToken = token,
            ExpiresAt = expiresAt,
            User = new UserSummary
            {
                UserId = user.Id,
                UserCode = user.UserCode,
                UserName = user.UserName
            },
            Warehouse = new WarehouseSummary
            {
                WarehouseId = user.Warehouse.Id,
                WarehouseCode = user.Warehouse.WarehouseCode,
                WarehouseName = user.Warehouse.WarehouseName
            }
        });
    }
}

