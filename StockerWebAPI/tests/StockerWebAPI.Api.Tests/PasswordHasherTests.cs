using Microsoft.VisualStudio.TestTools.UnitTesting;
using StockerWebAPI.Api.Security;

namespace StockerWebAPI.Api.Tests;

[TestClass]
public sealed class PasswordHasherTests
{
    private readonly PasswordHasher _sut = new();

    [TestMethod]
    public void HashAndVerify_ReturnsTrue_ForSamePassword()
    {
        var hash = _sut.Hash("Passw0rd!");

        var result = _sut.Verify("Passw0rd!", hash);

        Assert.IsTrue(result);
    }

    [TestMethod]
    public void Verify_ReturnsFalse_ForDifferentPassword()
    {
        var hash = _sut.Hash("Passw0rd!");

        var result = _sut.Verify("WrongPassword", hash);

        Assert.IsFalse(result);
    }
}
