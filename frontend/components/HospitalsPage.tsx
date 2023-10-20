import Link from 'next/link';
import styles from '../styles/Home.module.css';
import HospitalPage from './Hospital';

const HospitalsePage = () => {


  return (
    <div className={styles.container}>
        <h1>Hospitals</h1>
        <Link href={"/hospitals/1"}>
            <HospitalPage />
        </Link>
    </div>
  );
};

export default HospitalsePage;
