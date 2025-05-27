import { createContext, useEffect, useState, useCallback, useMemo } from 'react';
import axios from 'axios';
import Cookies from 'js-cookie';
import { toast } from 'react-toastify';

export const AccountContext = createContext(null);

const AccountContextProvider = ({ children }) => {
    axios.defaults.withCredentials = true;
    const [account, setAccount] = useState(null);
    const [token, setToken] = useState('');
    const url = 'http://localhost:4004'; // Cập nhật cổng từ 4001 thành 4004 để khớp với backend

    const fetchAccount = useCallback(async () => {
        try {
            const response = await axios.get(`${url}/staff/getProfile`);
            if (response.data.status) {
                setAccount(response.data.metadata);
                return response.data.metadata;
            } else {
                toast.error('Lỗi khi tải thông tin nhân viên');
            }
        } catch (error) {
            toast.error('Lỗi khi tải thông tin nhân viên: ' + error.message);
        }
    }, []);

    const updateAccount = useCallback(async (data) => {
        try {
            const response = await axios.post(`${url}/staff/updateProfile`, data);
            if (response.data.status) {
                setAccount(response.data.metadata);
                toast.success('Cập nhật thông tin nhân viên thành công');
                return response.data.metadata;
            } else {
                toast.error('Lỗi khi cập nhật nhân viên');
            }
        } catch (error) {
            toast.error('Lỗi khi cập nhật nhân viên: ' + error.message);
            throw error;
        }
    }, []);

    const updateAccountById = useCallback(async (staffId, data) => {
        try {
            const response = await axios.post(`${url}/staff/update/${staffId}`, data);
            if (response.data.status) {
                toast.success('Cập nhật nhân viên thành công');
                await fetchAccount();
            } else {
                toast.error('Lỗi khi cập nhật nhân viên');
            }
        } catch (error) {
            toast.error('Lỗi khi cập nhật nhân viên: ' + error.message);
        }
    }, [fetchAccount]);

    const deleteRestoreStaffById = useCallback(async (staffId) => {
        try {
            const response = await axios.delete(`${url}/staff/toggleStaffStatus/${staffId}`);
            if (response.data.status) {
                toast.success('Thay đổi trạng thái nhân viên thành công');
                await fetchAccount();
            } else {
                toast.error('Lỗi khi thay đổi trạng thái nhân viên');
            }
        } catch (error) {
            toast.error('Lỗi khi thay đổi trạng thái nhân viên: ' + error.message);
        }
    }, [fetchAccount]);

    const deleteStaffById = useCallback(async (staffId) => {
        try {
            const response = await axios.delete(`${url}/staff/delete/${staffId}`);
            if (response.data.status) {
                toast.success('Xóa nhân viên thành công');
                await fetchAccount();
            } else {
                toast.error('Lỗi khi xóa nhân viên');
            }
        } catch (error) {
            toast.error('Lỗi khi xóa nhân viên: ' + error.message);
        }
    }, [fetchAccount]);

    useEffect(() => {
        const loadData = async () => {
            await fetchAccount();
            const cookieToken = Cookies.get('token');
            if (cookieToken) {
                setToken(cookieToken);
            }
        };
        loadData();
    }, [fetchAccount]);

    const contextValue = useMemo(
        () => ({
            account,
            token,
            setToken,
            fetchAccount,
            updateAccount,
            updateAccountById,
            deleteRestoreStaffById,
            deleteStaffById,
        }),
        [account, token, fetchAccount, updateAccount, updateAccountById, deleteRestoreStaffById, deleteStaffById]
    );

    return <AccountContext.Provider value={contextValue}>{children}</AccountContext.Provider>;
};

export default AccountContextProvider;