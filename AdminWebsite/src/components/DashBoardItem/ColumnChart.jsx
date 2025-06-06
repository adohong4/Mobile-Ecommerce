
import React, { useEffect, useState, useContext } from 'react';
import { toast } from 'react-toastify';
import { Bar } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend } from 'chart.js';
import { CampaignContext } from '../../context/CampaignContextProvider';
import { VoucherContext } from "../../context/VoucherContextProvider";
import { ProductContext } from "../../context/ProductContextProvider";
import { OrderContext } from '../../context/OrderContextProvider';

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

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

    const chartData = {
        labels: ['Người dùng', 'Sản phẩm', 'Đơn hàng', 'Liên hệ'],
        datasets: [
            {
                label: 'Người dùng',
                data: [
                    voucher,
                    product,
                    orders,
                    campaign,
                ],
                backgroundColor: [
                    'rgba(75, 192, 192, 0.6)', // Color for Total Users
                    'rgba(255, 99, 132, 0.6)', // Color for Total Orders
                    'rgba(255, 206, 86, 0.6)', // Color for Total Foods
                    'rgba(54, 162, 235, 0.6)', // Color for Total Revenue
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)'
                ],
                borderWidth: 1
            },
        ],
    };

    return (
        <div className="column-chart-container">
            <div className='orders-right-2'>
                <Bar data={chartData} options={{
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top'
                        },
                        title: {
                            display: true,
                            text: 'Tổng quan'
                        }
                    }
                }} />
            </div>
        </div>
    );
};

export default Factors;
