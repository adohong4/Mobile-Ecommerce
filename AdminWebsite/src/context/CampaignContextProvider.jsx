import { createContext, useEffect, useState, useCallback, useMemo } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';

export const CampaignContext = createContext(null);

const CampaignContextProvider = ({ children }) => {
    axios.defaults.withCredentials = true;
    const [campaignList, setCampaignList] = useState([]);
    const [campaignId, setCampaignId] = useState(null);
    const url = 'http://localhost:9004/v1/api/product/campaign';

    const fetchCampaignList = useCallback(async () => {
        try {
            const response = await axios.get(`${url}/get`);
            if (response.data.metadata) {
                setCampaignList(response.data.metadata);
            } else {
                toast.error('Lỗi khi lấy danh sách chiến dịch');
            }
        } catch (error) {
            toast.error(`Lỗi khi lấy danh sách chiến dịch: ${error.message}`);
        }
    }, []);

    const fetchCampaignById = useCallback(async (campaignId) => {
        try {
            const response = await axios.get(`${url}/get/${campaignId}`);
            setCampaignId(response.data.metadata);
            return response.data.metadata;
        } catch (error) {
            toast.error(`Lỗi khi lấy thông tin chiến dịch: ${error.message}`);
            throw error;
        }
    }, []);

    const updateCampaignById = useCallback(async (campaignId, data) => {
        try {
            const response = await axios.put(`${url}/update/${campaignId}`, data);
            if (response.data.status) {
                setCampaignId(response.data.metadata?.campaign);
                toast.success('Cập nhật chiến dịch thành công');
                return { success: true, message: response.data.message };
            } else {
                return { success: false, message: response.data.message || 'Lỗi không xác định' };
            }
        } catch (error) {
            toast.error(`Lỗi khi cập nhật chiến dịch: ${error.response?.data?.message || error.message}`);
            throw error;
        }
    }, []);

    const deleteCampaign = useCallback(async (campaignId) => {
        try {
            const response = await axios.delete(`${url}/delete/${campaignId}`);
            if (response.data.status) {
                toast.success(response.data.message || 'Xóa chiến dịch thành công');
                await fetchCampaignList();
            } else {
                toast.error(response.data.message || 'Lỗi khi xóa chiến dịch');
            }
        } catch (error) {
            toast.error(`Lỗi khi xóa chiến dịch: ${error.response?.data?.message || error.message}`);
        }
    }, [fetchCampaignList]);

    const createCampaign = useCallback(
        async (data) => {
            console.log("data: ", data)
            try {
                const response = await axios.post(`${url}/create`, data);
                if (response.data.status) {
                    await fetchCampaignList(); // Làm mới danh sách chiến dịch
                    return { success: true, message: response.data.message || 'Tạo chiến dịch thành công' };
                } else {
                    return { success: false, message: response.data.message || 'Lỗi không xác định' };
                }
            } catch (error) {
                const errorMessage = error.response?.data?.message || error.message || 'Lỗi không xác định';
                throw new Error(errorMessage);
            }
        },
        [fetchCampaignList]
    );

    const addToCampaign = useCallback(async (data) => {
        try {
            const response = await axios.post(`${url}/addToCampaign`, data);
            if (response.data.status) {
                toast.success(response.data.message || 'Thêm vào chiến dịch thành công');
                return response.data.metadata;
            } else {
                toast.error(response.data.message || 'Lỗi khi thêm vào chiến dịch');
            }
        } catch (error) {
            toast.error(`Lỗi khi thêm vào chiến dịch: ${error.response?.data?.message || error.message}`);
        }
    }, []);

    const removeFromCampaign = useCallback(async (data) => {
        try {
            const response = await axios.post(`${url}/removeFromCampaign`, data);
            if (response.data.status) {
                toast.success(response.data.message || 'Xóa khỏi chiến dịch thành công');
                return response.data.metadata;
            } else {
                toast.error(response.data.message || 'Lỗi khi xóa khỏi chiến dịch');
            }
        } catch (error) {
            toast.error(`Lỗi khi xóa khỏi chiến dịch: ${error.response?.data?.message || error.message}`);
        }
    }, []);

    const searchCampaignByCode = useCallback(async (code) => {
        try {
            const response = await axios.get(`${url}/search/${code}`);
            return response.data.metadata;
        } catch (error) {
            toast.error(`Lỗi khi tìm kiếm chiến dịch: ${error.response?.data?.message || error.message}`);
        }
    }, []);

    useEffect(() => {
        fetchCampaignList();
    }, [fetchCampaignList]);

    const contextValue = useMemo(
        () => ({
            campaignList,
            campaignId,
            fetchCampaignList,
            fetchCampaignById,
            updateCampaignById,
            deleteCampaign,
            createCampaign,
            addToCampaign,
            removeFromCampaign,
            searchCampaignByCode,
        }),
        [
            campaignList,
            campaignId,
            fetchCampaignList,
            fetchCampaignById,
            updateCampaignById,
            deleteCampaign,
            createCampaign,
            addToCampaign,
            removeFromCampaign,
            searchCampaignByCode,
        ]
    );

    return <CampaignContext.Provider value={contextValue}>{children}</CampaignContext.Provider>;
};

export default CampaignContextProvider;