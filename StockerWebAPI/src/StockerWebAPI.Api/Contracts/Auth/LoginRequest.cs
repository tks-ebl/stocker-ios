using System.ComponentModel.DataAnnotations;

namespace StockerWebAPI.Api.Contracts.Auth;

public sealed class LoginRequest
{
    [Required]
    [MaxLength(50)]
    public string UserCode { get; set; } = string.Empty;

    [Required]
    [MinLength(8)]
    public string Password { get; set; } = string.Empty;
}

