// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../MediSyncPrescription.sol";


interface IMediSyncPrescription {
    function prescribe(address _patientAddress, string memory _prescription, string memory _recommendation) external returns (Prescription memory userPrescription);
    function verify_prescription(uint256 _prescriptionId, address _patientAddress) external view returns (bool);
    function viewPrescription(uint256 _prescriptionId) external view returns (string memory prescription);
}