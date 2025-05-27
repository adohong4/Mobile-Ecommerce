import React, { useEffect } from 'react';
import { Route, Routes, useNavigate } from 'react-router-dom';
import Sidebar from '../../components/Sidebar';
import ListProduct from '../Product/Product';
import AddProduct from '../Product/AddProducts';
import ProductDetail from '../Product/ProductDetail';
import Headeradmin from '../../components/Headeradmin';
import Orders from '../Order/Cart';
import OrderTrash from '../Order/OrderTrash';
import DashBoard from '../Admin/DashBoard';
import ProductTrash from '../Product/Trash';
import LoginAdmin from '../../pages/Admin/LoginAdmin';
import ProfileAdmin from '../../pages/Admin/ProfileAdmin';
import ListCampain from '../../pages/Campaign/ListCampaign';
import AddCampaign from '../../pages/Campaign/AddCampaign';
import CampaignInfo from '../../pages/Campaign/CampaignInfo';
import TrashCampain from '../../pages/Campaign/TrashCampaign';
import Statistic from '../../pages/Statistic/Statistic';
import { ToastContainer } from 'react-toastify';
import Cookies from 'js-cookie';
import VoucherList from '../Voucher/VoucherList';
import CategoryList from '../Category/CategoryList';
import AdvertiseList from '../Advertise/AdvertiseList';

const Admin = () => {
    // const token = Cookies.get("token");
    // const navigate = useNavigate();

    // useEffect(() => {
    //     if (!token) {
    //         navigate('/admin-login');
    //     }
    // }, [token, navigate]);

    return (
        <>
            <ToastContainer />
            <div className="admin-container">
                <Routes>
                    <Route path="/admin-login" element={<LoginAdmin />} />
                    <Route path="/*" element={
                        <div className="admin-layout">
                            <div className='sidebar-left'>
                                <Sidebar />
                            </div>
                            <div className='header-topadmin'>
                                <Headeradmin />
                            </div>
                            <div className="admin-content sidebar-right">
                                <Routes>
                                    <Route path="dashboard" element={<DashBoard />} />
                                    <Route path="add" element={<AddProduct />} />
                                    <Route path="product" element={<ListProduct />} />
                                    <Route path="product/trash" element={<ProductTrash />} />
                                    <Route path="product/:id" element={<ProductDetail />} />

                                    <Route path="orders" element={<Orders />} />
                                    <Route path="orders/trash" element={<OrderTrash />} />

                                    <Route path="profile-admin" element={<ProfileAdmin />} />
                                    <Route path="list-campaign" element={<ListCampain />} />
                                    <Route path="add-campaign" element={<AddCampaign />} />
                                    <Route path="list-campaign/:id" element={<CampaignInfo />} />
                                    <Route path="trash-campaign" element={<TrashCampain />} />

                                    <Route path="voucher" element={<VoucherList />} />

                                    <Route path="category" element={<CategoryList />} />

                                    <Route path="advertise" element={<AdvertiseList />} />

                                    <Route path="statistic" element={<Statistic />} />
                                </Routes>
                            </div>
                        </div>
                    } />
                </Routes>
            </div>
        </>
    );
};

export default Admin;
