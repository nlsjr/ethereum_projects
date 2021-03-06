// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RegistroPacientes {
    struct Patient {
        uint id; //identificador do paciente
        string device; // identificador do dispositivo
        string content; //dados coletados
    }
    
    Patient[] public patients;
    
    function registrarPaciente(uint id, string device, string content) public {
        registers.push(Register({
            id: id,
            device: device,
            content: content
        }));
    }
    
    
}