import React, { useState, useContext } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import './Styles/Styles.css';
import { assets } from '../assets/assets';
import { motion } from 'framer-motion';
import Cookies from 'js-cookie';
import { toast } from 'react-toastify';
const Sidebar = () => {
    const [menuOpen, setMenuOpen] = useState(false);
    const navigate = useNavigate();

    const toggleMenu = () => {
        setMenuOpen(!menuOpen);
    };

    const handleLogout = () => {
        Cookies.remove('token');
        setToken('');
        toast.success('Đăng xuất thành công');
        navigate('/admin-login');
    };

    return (
        <div className="section-header-admin">
            <motion.div
                initial={{ opacity: 0, y: -20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.8 }}
                className="header-admin"
            >
                <motion.div
                    className="header-admin-left"
                    initial={{ x: -100, opacity: 0 }}
                    animate={{ x: 0, opacity: 1 }}
                    transition={{ duration: 1, ease: 'easeOut' }}
                >
                    <motion.p
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        transition={{ duration: 2, repeat: Infinity, repeatType: 'mirror' }}
                    >
                        Xin chào {'Nhân viên'}!
                    </motion.p>
                </motion.div>
                <motion.div
                    className="header-admin-right"
                    initial={{ opacity: 0, scale: 0.8 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ duration: 0.8 }}
                >
                    <div className="profile-container">
                        <img
                            className="logo profile-pic"
                            src={assets.avt}
                            alt="avatar"
                            onClick={toggleMenu}
                        />
                        {menuOpen && (
                            <div className="profile-menu">
                                <NavLink to="/profile-admin">Thông tin</NavLink>
                                <NavLink to="/admin-login" onClick={handleLogout}>
                                    Đăng Xuất
                                </NavLink>
                            </div>
                        )}
                    </div>
                </motion.div>
            </motion.div>
        </div>
    );
};

export default Sidebar;