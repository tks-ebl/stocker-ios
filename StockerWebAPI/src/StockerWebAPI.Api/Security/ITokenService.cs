using StockerWebAPI.Api.Domain.Entities;

namespace StockerWebAPI.Api.Security;

public interface ITokenService
{
    (string Token, DateTimeOffset ExpiresAt) CreateToken(AppUser user, Warehouse warehouse);
}

