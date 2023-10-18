// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract MediSyncHospital {
    address[] adminstrator;
    address recordsContractAddr;
    doctorsRecord[] private HospitalDoctors;
    patientRecord[] private allPatientRecords; //will not be saved here, going to records contract
    uint sessionIDgenerator;
    uint doctorsIDgenerator;
    uint[] sessionIDsAssignedToDoctor;
    bytes[] keyhash; //precompile hash, prequisite to view certain info. this is tentative, mostly likely going to the records contract 

    struct patientRecord{
        //should match records contract outline
        string name;
    }
    struct doctorsRecord{
        bool available;
        string specialty;
        uint doctorsID;
        //other relevant info
    }
    struct session {
        string complaints;
        uint sessionID;
        bool approvalStatus;
        uint approvedTime;
        //other relevant info
    }
    mapping (address => patientRecord) private PatientRecordDetails;
    mapping (uint => session) private SessionDetails;
    mapping (address => bool) isDoctorRegistered;
    mapping (address => uint) doctorIDmapping;
    mapping (uint => doctorsRecord) DoctorInfo;

    constructor(address[] memory admins){
        for(uint i=0; i<admins.length; i++){
            adminstrator.push(admins[i]);
        }
    }

    //stores patient in hospital contract (temporarily) and records contract
    function storePatientRecord()public{}

    //stores patient records in hospital contract permanently and in records contract
    function approveAndStorePatientRecord()public{}

    //patient books session with doctor
    function bookDoctorSession()public{}
    //doctor accepts session
    function acceptSession()public{}

    //set doctors availability, only doctors
    function setavailability()public {}

    //Only admin can call
    function registerDoctor()public{}

    //Only admin can call
    function unregisterDoctor()public{}

    //add or remove admin
    function addOrRemoveAdmin()public{}

    //compute key hashes to be stored in the smart contract.
    //doctors will be assigned root keys.
    //guide against bruteforcing
    //this is tentative, mostly likely going to the records contract 
    function computePasskKeyHash()public{}
}