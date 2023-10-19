import styles from '../styles/Home.module.css';

const RegisterDoctorPage = () => {

    const register = () => {
        //
    }


  return (
    <div className={styles.container}>
        <div>
            <h1>Register Doctor</h1>
            <div>
                <div>
                    <input type="text" name="name" placeholder="Doctor's Name" id="" className='' />
                    <input type="text" name="specialization" placeholder='Specialization' id="" />
                    <input type="text" name="address" placeholder='Address' id="" />
                    <input type="text" name="hospital" placeholder='Hospital' id="" />
                    <input type="text" name="language" placeholder='Language' id="" />
                    <input type="text" name="price-per-hr" placeholder='Price per hour' id="" />
                    <input type="button" value="Register" onClick={() => register()} />
                </div>
            </div>
        </div>
    </div>
  );
};

export default RegisterDoctorPage;
