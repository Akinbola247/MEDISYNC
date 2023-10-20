import styles from '../styles/Home.module.css';

const DoctorProfilePage = () => {


  return (
    <div className={styles.container}>
        <div>
            <h1>Doctor Profile</h1>
            <div>
                <p>Name:</p>
                <p>Address:</p>
                <p>Email:</p>
            </div>
        </div>
    </div>
  );
};

export default DoctorProfilePage;
