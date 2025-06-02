import { createContext, useEffect, useState, useCallback, useMemo } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';

export const MessageContext = createContext(null);

const MessageContextProvider = ({ children }) => {
    axios.defaults.withCredentials = true;
    const [userList, setUserList] = useState([]);
    const [messages, setMessages] = useState([]);
    const baseUrl = 'http://localhost:9002/v1/api';
    const baseUrl1 = 'http://localhost:9003/v1/api';

    // Fetch list of user profiles
    const fetchUserList = useCallback(async () => {
        try {
            const response = await axios.get(`${baseUrl1}/profile/online/user`);
            if (response.data.metadata) {
                setUserList(response.data.metadata);
            } else {
                toast.error('Lỗi khi lấy danh sách người dùng');
            }
        } catch (error) {
            toast.error('Lỗi khi lấy danh sách người dùng: ' + error.message);
        }
    }, []);

    const fetchMessages = useCallback(async (userId) => {
        try {
            const response = await axios.get(`${baseUrl}/message/admin/get/${userId}`);
            if (response.data.metadata) {
                setMessages(response.data.metadata); // Assuming metadata contains the messages
                return response.data.metadata;
            } else {
                toast.error('Lỗi khi lấy tin nhắn');
            }
        } catch (error) {
            toast.error('Lỗi khi lấy tin nhắn: ' + error.message);
            throw error;
        }
    }, []);

    const sendMessage = useCallback(async (userId, messageData) => {
        try {
            const response = await axios.post(`${baseUrl}/message/admin/send/${userId}`, messageData
            );
            toast.success('Gửi tin nhắn thành công');
            await fetchMessages(userId);
            return response.data.metadata;
        } catch (error) {
            toast.error('Lỗi khi gửi tin nhắn: ' + error.message);
            throw error;
        }
    }, [fetchMessages]);

    useEffect(() => {
        fetchUserList();
    }, [fetchUserList]);

    const contextValue = useMemo(
        () => ({
            userList,
            messages,
            fetchUserList,
            fetchMessages,
            sendMessage,
        }),
        [userList, messages, fetchUserList, fetchMessages, sendMessage]
    );

    return (
        <MessageContext.Provider value={contextValue}>
            {children}
        </MessageContext.Provider>
    );
};

export default MessageContextProvider;