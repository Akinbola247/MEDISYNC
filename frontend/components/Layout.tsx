import styles from '../styles/Home.module.css';
import Navbar from './Navbar';
import Footer from './Footer';

const Layout = ({children}: any) => {
  return (
    <div className={styles.container}>
        <Navbar />
        {children}
        <Footer />
    </div>
  );
};

export default Layout;
