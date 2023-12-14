// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract CopyrightGuard {
    // Declaramos una variable pública owner de tipo dirección para almacenar la dirección del propietario del contrato.
    address public owner;
    
    // Declaramos una enumeración WorkType que tiene dos valores posibles: Literary y Musical.
    enum WorkType { Literary, Musical }
    
    // representa la información de una obra
    struct Work {
        address creator;
        WorkType workType;
        string description;
        uint256 timestamp;
        bool exists;
    }
    //  Creamos un mapeo que asocia identificadores de obra (uint256) con instancias de la estructura Work.
    mapping(uint256 => Work) public works;

    // Declaramos un evento que se emitirá cuando se registre una nueva obra. Este evento captura información relevante sobre la obra registrada.
    event WorkRegistered(
        uint256 indexed id,
        address indexed creator,
        WorkType workType,
        string description,
        uint256 timestamp
    );

    //  modificador que restringe ciertas funciones solo al propietario del contrato.
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    // Inicializa el propietario 
    constructor() {
        owner = msg.sender;
    }
    // Permite a los usuarios registrar una nueva obra, verifica que el identificador no exista ya y emite el evento WorkRegistered al registrar la obra.
    function registerWork(
        uint256 id,
        WorkType workType,
        string memory description
    ) external {
        require(!works[id].exists, "Work ID already exists");
        works[id] = Work(msg.sender, workType, description, block.timestamp, true);
        emit WorkRegistered(id, msg.sender, workType, description, block.timestamp);
    }
    // Verifica la autenticidad de la obra por su id , y muestra si la obra es existente
    function verifyAuthenticity(uint256 id) external view returns (
        address creator,
        WorkType workType,
        string memory description,
        uint256 timestamp
    ) {
        require(works[id].exists, "Work ID does not exist");
        return (works[id].creator, works[id].workType, works[id].description, works[id].timestamp);
    }
    // Permite a nuestros users monitorear el uso de la obra por su id, y muestra el timestamp en el que se registro la obra
    function monitorUsage(uint256 id) external view returns (uint256 timestamp) {
        require(works[id].exists, "Work ID does not exist");
        return works[id].timestamp;
    }
    //  Aquí permitimos hacer la transferencia de propiedad a una nueva dirección 
    function transferOwnership(uint256 id, address newOwner) external onlyOwner {
        require(works[id].exists, "Work ID does not exist");
        works[id].creator = newOwner;
    }
}
