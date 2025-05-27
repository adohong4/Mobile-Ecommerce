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
                toast.error("Lỗi khi lấy danh sách sản phẩm");
            }
        } catch (error) {
            toast.error("Lỗi khi lấy danh sách sản phẩm: " + error.message);
        }
    }, []);

    const fetchVoucherId = useCallback(async (VoucherId) => {
        try {
            const response = await axios.get(`${url}/get/${VoucherId}`);
            setVoucherId(response.data.metadata);
        } catch (error) {
            toast.error("Lỗi khi lấy thông tin sản phẩm: " + error.message);
        }
    }, []);

    const updateVoucherId = useCallback(async (VoucherId, data) => {
        try {
            const response = await axios.post(`${url}/update/${VoucherId}`, data);
            setVoucherId(response.data.metadata.Voucher);
            toast.success("Cập nhật sản phẩm thành công");
        } catch (error) {
            toast.error("Lỗi khi cập nhật sản phẩm: " + error.message);
        }
    }, []);

    const removeVoucher = useCallback(async (VoucherId) => {
        try {
            const response = await axios.delete(`${url}/delete/${VoucherId}`);
            if (response.data.status) {
                toast.success(response.data.message.Voucher);
                await fetchVoucherList(); // Làm mới danh sách sau khi xóa
            } else {
                toast.error("Lỗi khi xóa sản phẩm");
            }
        } catch (error) {
            toast.error("Lỗi khi xóa sản phẩm: " + error.message);
        }
    }, [fetchVoucherList]);

    useEffect(() => {
        fetchVoucherList(); // Lấy danh sách sản phẩm khi component mount
    }, [fetchVoucherList]);

    const contextValue = useMemo(
        () => ({
            VoucherList,
            VoucherId,
            fetchVoucherList,
            fetchVoucherId,
            updateVoucherId,
            removeVoucher,
        }),
        [VoucherList, VoucherId, fetchVoucherList, fetchVoucherId, updateVoucherId, removeVoucher]
    );

    return (
        <VoucherContext.Provider value={contextValue}>
            {children}
        </VoucherContext.Provider>
    );
};

export default VoucherContextProvider;