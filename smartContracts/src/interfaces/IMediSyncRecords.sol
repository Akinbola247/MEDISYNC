// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
interface IMediSyncRecords {
    function bioEntry(bytes memory _calldata, address _patient) external;
    function retrieveRecordStatus(address _patientAddress)view external returns(bool);
    function uploadSession(address _patient, uint sessionID, bytes _calldata) external;

}