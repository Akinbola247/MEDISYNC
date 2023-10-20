import type { NextPage } from 'next';
import styles from '../../styles/Home.module.css';
import Layout from '../../components/Layout';
import HospitalsePage from '../../components/HospitalsPage';

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
        <Layout>
            <HospitalsePage />
        </Layout>
    </div>
  );
};

export default Home;
