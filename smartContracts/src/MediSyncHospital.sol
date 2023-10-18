// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract MediSyncHospital {
    address[] adminstrator;
    address recordsContractAddr;
    doctorsRecord[] private HospitalDoctors;
    uint sessionIDgenerator;
    uint doctorsIDgenerator;
    
    // patientRecord[] private allPatientRecords; //will not be saved here, going to records contract
    // bytes[] keyhash; //precompile hash, prequisite to view certain info. this is tentative, mostly likely going to the records contract 

    struct patientBio{
        address patientAddr;
        string first_name;
        string last_name;
        uint Age;
        gender Sex;
        gtype Genotype;
        string email;
        uint phoneNumber;
        string country;
    }
    struct sessionDetails {
        uint bookedDoctorID;
        address patientAddr;
        uint time;
        // patient complaint/vitals
        string blood_pressure;
        string heart_rate;
        string Temperature;
        string complaint;
        // Medical history
        string PreExistingCondition;
        string Allergies;
        string FamilyMedHistory;
        // ongoing treatment
        string ongoingMedications;
        // test result
        string CID;
        string doctorsDiagnosis;
        recordStatus status;
    }
    struct doctorsRecord{
        bool available;
        string specialty;
        uint doctorsID;
        //other relevant info
    }
    enum gender {
        Male,
        Female
    }
    enum recordStatus {
        open,
        examined,
        closed
    }
    // genotype
    enum gtype {
        AA,
        AS,
        SS
    }
    struct doctorSessionNote{
        address patientAddress;
        uint sessionID;
    }

    //mappings going to records contract. 
    // mapping (address => patientBio) private PatientBioDetails;
    //maps address to healthrecord ID as at the moment.
    // mapping(address => mapping(uint => sessionDetails)) private patientRecord;   
    //maps address to array of sessionsDetails (a record of all sessions);
    // mapping(address => sessionDetails) allSessionHistory;
    
    
    // mapping (uint => session) private SessionDetails;
    // mapping (uint => doctorsRecord) DoctorInfo;

    //mapping in the smart contract
    mapping (address => uint) doctorIDtoAddress;
    mapping (address => doctorSessionNote[]) requestedSessionInfo;
    mapping (uint => address) doctorAddressToID;
    mapping (address => bool) isDoctorRegistered;



    modifier isDoctor {
        require(isDoctorRegistered[msg.sender], 'not doctor');
        _;
    }
    constructor(address[] memory admins){
        for(uint i=0; i<admins.length; i++){
            adminstrator.push(admins[i]);
        }
        sessionIDgenerator = 1;
    }

    //stores patient bio in records contract
    function storePatientBio(string memory firstName,
        string memory lastName,
        uint _age,
        gender _sex,
        gtype _genotype,
         string email,
        uint phoneNumber,
        string country)public{
        //check if patient has record. else, create record
        require(IMediSyncRecords(recordsContractAddr).retrieveRecordStatus(_patientAddress), 'RECORD_EXISTS');
        patientBio memory bio = patientBio(msg.sender,
        firstName,
        lastName,
        _age ,
        _sex,
        _genotype,
        email,
        phoneNumber,
        country
        )
        bytes memory _calldata = abi.encode(bio);
        //makes call to record contract to save patient bio
        IMediSyncRecords(recordsContractAddr).bioEntry(_calldata, msg.sender);
    }


    //patient books session with doctor
    function bookDoctorSession(uint _doctorID,
        string _bloodPressure,
        string _heartRate,
        string temprature,
        string _complaint,
        string _existingCondition,
        string _allergies,
        string _familyMedHistory,
        string _ongoingMedications,
        string _ipfsCID
     )public{
        require(IMediSyncRecords(recordsContractAddr).retrieveRecordStatus(_patientAddress), 'RECORD_EXISTS');
        //pass session ID in.
        sessionDetails memory session = sessionDetails(
           _doctorID,
           msg.sender,
           0,
           _bloodPressure,
           _heartRate,
           temprature,
           _complaint,
           _existingCondition,
           _allergies,
           _familyMedHistory,
           _ongoingMedications,
           _ipfsCID 
           '',
           recordStatus.open 
        )
        bytes memory _calldata = abi.encode(session);
        address doctors_address = doctorIDtoAddress[_doctorID];
        require(doctors_address != address(0), 'INCORRECT_DOCTOR_ID');
        IMediSyncRecords(recordsContractAddr).uploadSession(msg.sender,sessionIDgenerator,_calldata);
        requestedSessionInfo[doctors_address].push(doctorSessionNote(msg.sender,sessionIDgenerator));
        sessionIDgenerator++;
    }
    //doctor accepts session
    function acceptSession()public{
        require(isDoctorRegistered[msg.sender] == true, 'NOT_REGISTERED');

    }
  
    //set doctors availability, only doctors
    function setavailability()public {}

    //Only admin can call
    function registerDoctor()public{
        for(uint i=0; i<adminstrator; i++;){

        } 
    }

    //Only admin can call
    function unregisterDoctor()public{}

    //add or remove admin
    function addOrRemoveAdmin()public{}

    function computeRecord() internal {

    }
}