import { createContext, useEffect, useState, useCallback, useMemo } from "react";
import axios from "axios";
import { toast } from "react-toastify";

export const VoucherContext = createContext(null);

const VoucherContextProvider = ({ children }) => {
    axios.defaults.withCredentials = true;
    const [VoucherList, setVoucherList] = useState([]);
    const [VoucherId, setVoucherId] = useState(null);
    const url = "http://localhost:9004/v1/api/product/voucher";

    const fetchVoucherList = useCallback(async () => {
        try {
            const response = await axios.get(`${url}/get`);
            if (response.data.metadata) {
                setVoucherList(response.data.metadata);
            } else {
                toast.error("Lỗi khi lấy danh sách voucher");
            }
        } catch (error) {
            toast.error("Lỗi khi lấy danh sách voucher: " + error.message);
        }
    }, []);

    const fetchVoucherId = useCallback(async (voucherId) => {
        try {
            const response = await axios.get(`${url}/get/${voucherId}`);
            setVoucherId(response.data.metadata);
        } catch (error) {
            toast.error("Lỗi khi lấy thông tin voucher: " + error.message);
        }
    }, []);

    const updateVoucherId = useCallback(async (voucherId, data) => {
        try {
            const response = await axios.post(`${url}/update/${voucherId}`, data);
            setVoucherId(response.data.metadata.voucher);
            toast.success("Cập nhật voucher thành công");
        } catch (error) {
            toast.error("Lỗi khi cập nhật voucher: " + error.message);
        }
    }, []);

    const removeVoucher = useCallback(async (voucherId) => {
        try {
            const response = await axios.delete(`${url}/delete/${voucherId}`);
            if (response.data.status) {
                toast.success(response.data.message);
                await fetchVoucherList();
            } else {
                toast.error("Lỗi khi xóa voucher");
            }
        } catch (error) {
            toast.error("Lỗi khi xóa voucher: " + error.message);
        }
    }, [fetchVoucherList]);

    const createVoucher = useCallback(async (voucherData) => {
        try {
            const response = await axios.post(`${url}/create`, voucherData);
            if (response.data.status) {
                toast.success("Tạo voucher thành công");
                await fetchVoucherList();
                return { success: true, message: response.data.message };
            }
        } catch (error) {
            return { success: false, message: error.message };
        }
    }, [fetchVoucherList]);

    useEffect(() => {
        fetchVoucherList();
    }, [fetchVoucherList]);

    const contextValue = useMemo(
        () => ({
            VoucherList,
            VoucherId,
            fetchVoucherList,
            fetchVoucherId,
            updateVoucherId,
            removeVoucher,
            createVoucher,
        }),
        [VoucherList, VoucherId, fetchVoucherList, fetchVoucherId, updateVoucherId, removeVoucher, createVoucher]
    );

    return (
        <VoucherContext.Provider value={contextValue}>
            {children}
        </VoucherContext.Provider>
    );
};

export default VoucherContextProvider;