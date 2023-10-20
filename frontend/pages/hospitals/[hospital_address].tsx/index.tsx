import type { NextPage } from 'next';
import styles from '../../styles/Home.module.css';
import Layout from '../../../components/Layout';
import HospitalPage from '../../../components/Hospital';

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
        <Layout>
            <HospitalPage />
        </Layout>
    </div>
  );
};

export default Home;
