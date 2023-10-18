import styles from '../styles/Home.module.css';

const RegisterHospitalPage = () => {

    const register = () => {
        //
    }


  return (
    <div className={styles.container}>
        <div>
            <h1>Register Hospital</h1>
            <div>
            string name;
        address HospitalAddress;
        string Country;
        bytes32 registratioNumber;
        address[] doctors;
        bool approved;
        uint positionInArray;
                <div>
                    <input type="text" name="name" placeholder='Hospital Name' id="" className='' />
                    <input type="text" name="hospital-address" placeholder='Hospital Address' id="" />
                    <input type="text" name="country" placeholder='Country' id="" />
                    <input type="text" name="registration-number" placeholder='Registration Number' id="" />
                    <input type="button" value="Register" onClick={() => register()} />
                </div>
            </div>
        </div>
    </div>
  );
};

export default RegisterHospitalPage;
