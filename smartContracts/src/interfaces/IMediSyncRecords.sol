// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IMediSyncRecords {
    function bioEntry(
        bytes memory _calldata,
        address _patientAddress,
        bytes32 _accessKey
    ) external;

    function healthRecordBySessionId(
        uint _sessionId,
        bytes memory _calldata,
        address _patientAddress
    ) external;

    //To do: function argument 'key' to be implemented
    function retrieveHealthRecordBySessionId(
        uint _sessionId,
        address _patientAddress,
        string memory _accessKey
    ) external returns (bytes memory, bytes memory, bytes[] memory); //returns bio and session bytes

    function confirmBioRecord(
        address _patientAddress
    ) external view returns (bool);

    function medicalHistoryEntry(
        uint _sessionId,
        bytes memory _calldata,
        address _patientAddress
    ) external;

    function retrieveMedicalHistory(
        address _patientAddress,
        string memory _accessKey
    ) external view returns (bytes memory, bytes[] memory);

    function registerHospital(
        address _hospitalAddress,
        bytes32 _hospitalAccessKey
    ) external;
}
