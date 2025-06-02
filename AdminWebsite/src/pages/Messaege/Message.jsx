import React, { useState, useEffect, useContext } from 'react';
import '../styles/styles.css';
import { MessageContext } from '../../context/MessageContextProvider';

const CustomerSupportChat = () => {
  const { userList, messages, fetchMessages, sendMessage } = useContext(MessageContext);
  const [selectedUser, setSelectedUser] = useState(null);
  const [inputText, setInputText] = useState('');

  // Cập nhật messages khi chọn user mới
  useEffect(() => {
    if (selectedUser) {
      fetchMessages(selectedUser.userId);
    }
  }, [selectedUser, fetchMessages]);

  // Gửi tin nhắn
  const handleSend = async () => {
    if (!inputText.trim()) return;

    try {
      const messageData = { text: inputText };
      await sendMessage(selectedUser.userId, messageData);
      setInputText('');
    } catch (error) {
      console.error('Lỗi khi gửi tin nhắn:', error);
    }
  };

  return (
    <div className="chat-wrapper">
      <div className="chat-sidebar">
        <h3>Khách hàng</h3>
        <ul>
          {userList.length > 0 ? (
            userList.map((user) => (
              <li
                key={user.userId}
                className={user.userId === selectedUser?.userId ? 'active' : ''}
                onClick={() => setSelectedUser(user)}
              >
                {user.fullName || 'Khách hàng không tên'}
              </li>
            ))
          ) : (
            <li>Không có khách hàng</li>
          )}
        </ul>
      </div>
      <div className="chat-main">
        <div className="chat-header">
          Đang trò chuyện với: <strong>{selectedUser?.fullName || 'Chưa chọn khách hàng'}</strong>
        </div>
        <div className="chat-content">
          {selectedUser ? (
            messages.length > 0 ? (
              messages.map((msg) => (
                <div
                  key={msg._id}
                  className={`message ${msg.senderId === '682f22449b14ebd1d789b682' ? 'sent' : 'received'
                    }`}
                >
                  <div className="msg">{msg.content}</div>
                  <div className="time">
                    {new Date(msg.createdAt).toLocaleTimeString('vi-VN')}
                  </div>
                </div>
              ))
            ) : (
              <div>Chưa có tin nhắn</div>
            )
          ) : (
            <div>Vui lòng chọn một khách hàng để trò chuyện</div>
          )}
        </div>
        {selectedUser && (
          <div className="chat-input">
            <input
              type="text"
              placeholder="Nhập tin nhắn..."
              value={inputText}
              onChange={(e) => setInputText(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSend()}
            />
            <button onClick={handleSend}>Gửi</button>
          </div>
        )}
      </div>
    </div>
  );
};

export default CustomerSupportChat;