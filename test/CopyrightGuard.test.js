const CopyrightGuard = artifacts.require('CopyrightGuard');

contract('CopyrightGuard', (accounts) => {
    it('should register a work correctly', async () => {
        const copyrightGuardInstance = await CopyrightGuard.deployed();

        // Registrar una obra
        const tx = await copyrightGuardInstance.registerWork(1, 0, 'Mi obra');
        console.log('Transaction Receipt:', tx.receipt);

        // Obtener la información de la obra registrada
        const workInfo = await copyrightGuardInstance.verifyAuthenticity(1);

        // Verificar que la información es correcta
        assert.equal(workInfo.creator, accounts[0], 'El creador no es correcto');
        assert.equal(workInfo.workType, 0, 'El tipo de obra no es correcto');
        assert.equal(workInfo.description, 'Mi obra', 'La descripción no es correcta');
    });

});
