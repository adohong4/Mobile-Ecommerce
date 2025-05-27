import { createContext, useEffect, useState, useCallback, useMemo } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';

export const OrderContext = createContext(null);

const OrderContextProvider = ({ children }) => {
    axios.defaults.withCredentials = true;
    const [orderList, setOrderList] = useState([]);
    const [orderId, setOrderId] = useState(null);
    const [trashOrders, setTrashOrders] = useState([]);
    const url = 'http://localhost:9003/v1/api/profile/order';

    const fetchOrderList = useCallback(async () => {
        try {
            const response = await axios.get(`${url}/get`);
            if (response.data.metadata) {
                setOrderList(response.data.metadata || []);
                return response.data.metadata || [];
            } else {
                toast.error('Lỗi khi lấy danh sách đơn hàng');
                return [];
            }
        } catch (error) {
            toast.error('Lỗi khi lấy danh sách đơn hàng: ' + error.message);
            throw error;
        }
    }, []);

    const fetchOrderById = useCallback(async (orderId) => {
        try {
            const response = await axios.get(`${url}/get/${orderId}`);
            setOrderId(response.data.metadata);
            return response.data.metadata;
        } catch (error) {
            toast.error('Lỗi khi lấy thông tin đơn hàng: ' + error.message);
            throw error;
        }
    }, []);

    const fetchTrashOrders = useCallback(async (page = 1, limit = 10) => {
        try {
            const response = await axios.get(`${url}/trash/paginate?page=${page}&limit=${limit}`);
            if (response.data.metadata) {
                setTrashOrders(response.data.metadata);
                return {
                    orders: response.data.metadata.order,
                    totalOrder: response.data.metadata.totalOrder,
                    totalPages: response.data.metadata.totalPages,
                };
            } else {
                toast.error('Lỗi khi lấy danh sách đơn hàng đã xóa');
            }
        } catch (error) {
            toast.error('Lỗi khi lấy danh sách đơn hàng đã xóa: ' + error.message);
            throw error;
        }
    }, []);

    const searchOrderById = useCallback(async (orderId) => {
        try {
            const response = await axios.get(`${url}/search/${orderId}`);
            return response.data.metadata;
        } catch (error) {
            toast.error('Lỗi khi tìm kiếm đơn hàng: ' + error.message);
            throw error;
        }
    }, []);

    const updateStatusOrder = useCallback(async (orderId, status) => {
        try {
            const response = await axios.put(`${url}/update`, { orderId, status });
            if (response.data.status) {
                toast.success('Cập nhật trạng thái đơn hàng thành công');
                return response.data.metadata;
            } else {
                toast.error('Lỗi khi cập nhật trạng thái đơn hàng');
            }
        } catch (error) {
            toast.error('Lỗi khi cập nhật trạng thái đơn hàng: ' + error.message);
            throw error;
        }
    }, []);

    const deleteOrder = useCallback(async (orderId) => {
        try {
            const response = await axios.delete(`${url}/delete/${orderId}`);
            if (response.data.status) {
                toast.success('Xóa đơn hàng thành công');
                await fetchOrderList();
            } else {
                toast.error('Lỗi khi xóa đơn hàng');
            }
        } catch (error) {
            toast.error('Lỗi khi xóa đơn hàng: ' + error.message);
        }
    }, [fetchOrderList]);

    const toggleOrderStatus = useCallback(async (orderId) => {
        try {
            const response = await axios.delete(`${url}/status/${orderId}`);
            if (response.data.status) {
                toast.success(response.data.message || 'Thay đổi trạng thái đơn hàng thành công');
                await fetchOrderList();
            } else {
                toast.error('Lỗi khi thay đổi trạng thái đơn hàng');
            }
        } catch (error) {
            toast.error('Lỗi khi thay đổi trạng thái đơn hàng: ' + error.message);
        }
    }, [fetchOrderList]);

    useEffect(() => {
        fetchOrderList();
    }, [fetchOrderList]);

    const contextValue = useMemo(
        () => ({
            orderList,
            orderId,
            trashOrders,
            fetchOrderList,
            fetchOrderById,
            fetchTrashOrders,
            searchOrderById,
            updateStatusOrder,
            deleteOrder,
            toggleOrderStatus,
        }),
        [
            orderList,
            orderId,
            trashOrders,
            fetchOrderList,
            fetchOrderById,
            fetchTrashOrders,
            searchOrderById,
            updateStatusOrder,
            deleteOrder,
            toggleOrderStatus,
        ]
    );

    return (
        <OrderContext.Provider value={contextValue}>
            {children}
        </OrderContext.Provider>
    );
};

export default OrderContextProvider;