import React, { useEffect, useContext, useState } from 'react';
import axios from 'axios';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faUsers, faBox, faShoppingCart, faEnvelope } from '@fortawesome/free-solid-svg-icons';
import { CampaignContext } from '../../context/CampaignContextProvider';
import { VoucherContext } from "../../context/VoucherContextProvider";
import { ProductContext } from "../../context/ProductContextProvider";
import { OrderContext } from '../../context/OrderContextProvider';
import { fakeFactors } from "../../data/Enviroment";

const StatsCard = ({ maxCount, label }) => {
    const [count, setCount] = useState(0);

    useEffect(() => {
        const interval = setInterval(() => {
            setCount((prev) => {
                if (prev < maxCount) {
                    return prev + 1;
                } else {
                    clearInterval(interval);
                    return maxCount;
                }
            });
        }, 50);

        return () => clearInterval(interval);
    }, [maxCount]);

    return (
        <div className="stats-card">
            <p className="stats-number">{count} <span className="plus">+</span></p>
            <p className="stats-label">{label}</p>
        </div>
    );
};

const Factors = () => {
    const { campaignList } = useContext(CampaignContext);
    const { VoucherList } = useContext(VoucherContext);
    const { orderList } = useContext(OrderContext);
    const { productList } = useContext(ProductContext);
    const [orders, setOrders] = useState(0);
    const [campaign, setCampaign] = useState(0);
    const [product, setProduct] = useState(0);
    const [voucher, setVoucher] = useState(0);

    useEffect(() => {
        setCampaign(campaignList?.length);
        setProduct(productList?.length);
        setOrders(orderList?.length);
        setVoucher(VoucherList?.length);
    }, []);

    return (
        <div className="user-factors-container">
            <div className="info-cards col-12">
                <div className="info-card" style={{ background: "#6F42C1", color: "white" }}>
                    <FontAwesomeIcon icon={faUsers} className="info-icon" />
                    <StatsCard maxCount={campaign} label="Chiến dịch" />
                </div>
                <div className="info-card" style={{ background: "#3399FF", color: "white" }}>
                    <FontAwesomeIcon icon={faBox} className="info-icon" />
                    <StatsCard maxCount={product} label="Sản phẩm" />
                </div>
                <div className="info-card" style={{ background: "#F9B115", color: "white" }}>
                    <FontAwesomeIcon icon={faShoppingCart} className="info-icon" />
                    <StatsCard maxCount={orders} label="Đơn hàng" />
                </div>
                <div className="info-card" style={{ background: "#DC3545", color: "white" }}>
                    <FontAwesomeIcon icon={faEnvelope} className="info-icon" />
                    <StatsCard maxCount={voucher} label="Voucher" />
                </div>
            </div>
        </div>
    );
};

export default Factors;
