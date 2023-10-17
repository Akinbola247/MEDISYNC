import type { NextPage } from 'next';
import styles from '../../styles/Home.module.css';
import Layout from '../../components/Layout';
import GroupPage from '../../components/GroupPage';

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
        <Layout>
            <GroupPage />
        </Layout>
    </div>
  );
};

export default Home;
