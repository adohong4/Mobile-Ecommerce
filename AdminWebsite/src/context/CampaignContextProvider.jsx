import { createContext, useEffect, useState, useCallback, useMemo } from "react";
import axios from "axios";
import { toast } from "react-toastify";

export const CampaignContext = createContext(null);

const CampaignContextProvider = ({ children }) => {
    axios.defaults.withCredentials = true;
    const [campaignList, setCampaignList] = useState([]);
    const [campaignId, setCampaignId] = useState(null);
    const url = "http://localhost:9004/v1/api/product/campaign";

    const fetchCampaignList = useCallback(async () => {
        try {
            const response = await axios.get(`${url}/get`);
            if (response.data.metadata) {
                setCampaignList(response.data.metadata);
            } else {
                toast.error("Lỗi khi lấy danh sách chiến dịch");
            }
        } catch (error) {
            toast.error("Lỗi khi lấy danh sách chiến dịch: " + error.message);
        }
    }, []);

    const fetchCampaignById = useCallback(async (campaignId) => {
        try {
            const response = await axios.get(`${url}/get/${campaignId}`);
            console.log('data:', response.data.metadata);
            setCampaignId(response.data.metadata);
            return response.data.metadata;
        } catch (error) {
            toast.error("Lỗi khi lấy thông tin chiến dịch: " + error.message);
            throw error;
        }
    }, []);

    const updateCampaignById = useCallback(async (campaignId, data) => {
        try {
            const response = await axios.put(`${url}/update/${campaignId}`, data);
            setCampaignId(response.data.metadata?.campaign);
            toast.success("Cập nhật chiến dịch thành công");
        } catch (error) {
            toast.error("Lỗi khi cập nhật chiến dịch: " + error.message);
        }
    }, []);

    const deleteCampaign = useCallback(async (campaignId) => {
        try {
            const response = await axios.delete(`${url}/delete/${campaignId}`);
            if (response.data.status) {
                toast.success(response.data.message?.campaign || "Xóa chiến dịch thành công");
                await fetchCampaignList();
            } else {
                toast.error("Lỗi khi xóa chiến dịch");
            }
        } catch (error) {
            toast.error("Lỗi khi xóa chiến dịch: " + error.message);
        }
    }, [fetchCampaignList]);

    // Additional functions for other backend endpoints
    const createCampaign = useCallback(async (data) => {
        try {
            const response = await axios.post(`${url}/create`, data);
            toast.success("Tạo chiến dịch thành công");
            await fetchCampaignList();
            return response.data.metadata;
        } catch (error) {
            toast.error("Lỗi khi tạo chiến dịch: " + error.message);
        }
    }, [fetchCampaignList]);

    const addToCampaign = useCallback(async (data) => {
        try {
            const response = await axios.post(`${url}/addToCampaign`, data);
            toast.success("Thêm vào chiến dịch thành công");
            return response.data.metadata;
        } catch (error) {
            toast.error("Lỗi khi thêm vào chiến dịch: " + error.message);
        }
    }, []);

    const removeFromCampaign = useCallback(async (data) => {
        try {
            const response = await axios.post(`${url}/removeFromCampaign`, data);
            toast.success("Xóa khỏi chiến dịch thành công");
            return response.data.metadata;
        } catch (error) {
            toast.error("Lỗi khi xóa khỏi chiến dịch: " + error.message);
        }
    }, []);

    const searchCampaignByCode = useCallback(async (code) => {
        try {
            const response = await axios.get(`${url}/search/${code}`);
            return response.data.metadata;
        } catch (error) {
            toast.error("Lỗi khi tìm kiếm chiến dịch: " + error.message);
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

    return (
        <CampaignContext.Provider value={contextValue}>
            {children}
        </CampaignContext.Provider>
    );
};

export default CampaignContextProvider;