// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import "../MediSyncFactory.sol";

interface IMediSyncFactory {

    function ApplyToCreateHospital(string memory name, string memory Country, bytes32 registratioNumber) external;

    function ApproveCreateHospital(uint256 id) external ;

    function registerDoctors(Doctor memory doctorDetails) external;

    function placeDonationAdvert(DonorRequest memory newDonorRequest ) external;

    function viewHospitals() external view returns(address[] memory);

    function viewDoctors() external view returns (address[] memory );

    function getDoctorsHospital(address _Doctor) external view returns(address doctorsHospital) ;

    function viewDonationAddverts() external view returns(DonorRequest[] memory );

    function viewDoctorsHospital( address _doctor) external view returns(address);

}