namespace StockerWebAPI.Api.Errors;

public sealed class DomainValidationException(string message) : Exception(message);

