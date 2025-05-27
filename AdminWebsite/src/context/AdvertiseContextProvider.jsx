import { createContext, useEffect, useState, useCallback, useMemo } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';

export const AdvertiseContext = createContext(null);

const AdvertiseContextProvider = ({ children }) => {
    axios.defaults.withCredentials = true;
    const [advertiseList, setAdvertiseList] = useState([]);
    const [advertiseId, setAdvertiseId] = useState(null);
    const url = 'http://localhost:9004/v1/api/product/advertise';

    const fetchAdvertiseList = useCallback(async () => {
        try {
            const response = await axios.get(`${url}/get`);
            if (response.data.metadata) {
                setAdvertiseList(response.data.metadata);
            } else {
                toast.error('Lỗi khi lấy danh sách quảng cáo');
            }
        } catch (error) {
            toast.error('Lỗi khi lấy danh sách quảng cáo: ' + error.message);
        }
    }, []);

    const createAdvertise = useCallback(async (data) => {
        try {
            const response = await axios.post(`${url}/create`, data, {
                headers: { 'Content-Type': 'multipart/form-data' },
            });
            toast.success('Tạo quảng cáo thành công');
            await fetchAdvertiseList();
            return response.data.metadata;
        } catch (error) {
            toast.error('Lỗi khi tạo quảng cáo: ' + error.message);
            throw error;
        }
    }, [fetchAdvertiseList]);

    const deleteAdvertise = useCallback(async (advertiseId) => {
        try {
            const response = await axios.delete(`${url}/delete/${advertiseId}`);
            if (response.data.status) {
                toast.success(response.data.message || 'Xóa quảng cáo thành công');
                await fetchAdvertiseList();
            } else {
                toast.error('Lỗi khi xóa quảng cáo');
            }
        } catch (error) {
            toast.error('Lỗi khi xóa quảng cáo: ' + error.message);
        }
    }, [fetchAdvertiseList]);

    const activeAdvertise = useCallback(async (advertiseId) => {
        try {
            const response = await axios.put(`${url}/active/${advertiseId}`);
            if (response.data.status) {
                toast.success(response.data.message || 'Cập nhật trạng thái quảng cáo thành công');
                await fetchAdvertiseList();
            } else {
                toast.error('Lỗi khi cập nhật trạng thái quảng cáo');
            }
        } catch (error) {
            toast.error('Lỗi khi cập nhật trạng thái quảng cáo: ' + error.message);
        }
    }, [fetchAdvertiseList]);

    useEffect(() => {
        fetchAdvertiseList();
    }, [fetchAdvertiseList]);

    const contextValue = useMemo(
        () => ({
            advertiseList,
            advertiseId,
            fetchAdvertiseList,
            createAdvertise,
            deleteAdvertise,
            activeAdvertise,
            setAdvertiseId,
        }),
        [
            advertiseList,
            advertiseId,
            fetchAdvertiseList,
            createAdvertise,
            deleteAdvertise,
            activeAdvertise,
        ]
    );

    return (
        <AdvertiseContext.Provider value={contextValue}>
            {children}
        </AdvertiseContext.Provider>
    );
};

export default AdvertiseContextProvider;