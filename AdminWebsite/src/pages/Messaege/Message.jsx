import React, { useState, useEffect } from 'react';
import '../styles/styles.css';

const mockUsers = [
  { id: '681722f37ce33fa5cbac9530', name: 'Khách A' },
  { id: '681722f37ce33fa5cbac9531', name: 'Khách B' },
  { id: '681722f37ce33fa5cbac9532', name: 'Khách C' },
  { id: '681722f37ce33fa5cbac9533', name: 'Khách D' },
  { id: '681722f37ce33fa5cbac9534', name: 'Khách E' },
  { id: '681722f37ce33fa5cbac9535', name: 'Khách F' },
  { id: '681722f37ce33fa5cbac9536', name: 'Khách G' },
  { id: '681722f37ce33fa5cbac9537', name: 'Khách H' },
  { id: '681722f37ce33fa5cbac9538', name: 'Khách I' },
  { id: '681722f37ce33fa5cbac9539', name: 'Khách J' },
  { id: '681722f37ce33fa5cbac953a', name: 'Khách K' },
  { id: '681722f37ce33fa5cbac953b', name: 'Khách L' },
  { id: '681722f37ce33fa5cbac953c', name: 'Khách M' },
  { id: '681722f37ce33fa5cbac953d', name: 'Khách N' },
  { id: '681722f37ce33fa5cbac953e', name: 'Khách O' },
  { id: '681722f37ce33fa5cbac953f', name: 'Khách P' },
  { id: '681722f37ce33fa5cbac9540', name: 'Khách Q' },
  { id: '681722f37ce33fa5cbac9541', name: 'Khách R' },
  { id: '681722f37ce33fa5cbac9542', name: 'Khách S' },
  { id: '681722f37ce33fa5cbac9543', name: 'Khách T' },
];


const mockMessages = {
  '681722f37ce33fa5cbac9530': [
    {
      _id: '6839e921ed90b01c1c344608',
      senderId: '6815e779a3baffb300fdfc18',
      receiverId: '681722f37ce33fa5cbac9530',
      content: 'Chào bạn!',
      createdAt: '2025-05-30T17:21:37.763Z',
    },
    {
      _id: '6839e921ed90b01c1c344609',
      senderId: '681722f37ce33fa5cbac9530',
      receiverId: '6815e779a3baffb300fdfc18',
      content: 'Dạ em chào shop!',
      createdAt: '2025-05-30T17:23:00.763Z',
    },
  ],
};

const currentUserId = '6815e779a3baffb300fdfc18'; // shop ID

const CustomerSupportChat = () => {
  const [selectedUser, setSelectedUser] = useState(mockUsers[0]);
  const [messages, setMessages] = useState([]);
  const [inputText, setInputText] = useState('');

  useEffect(() => {
    if (selectedUser) {
      setMessages(mockMessages[selectedUser.id] || []);
    }
  }, [selectedUser]);

  const handleSend = () => {
    if (!inputText.trim()) return;

    const newMessage = {
      _id: Date.now().toString(),
      senderId: currentUserId,
      receiverId: selectedUser.id,
      content: inputText,
      createdAt: new Date().toISOString(),
    };

    const updatedMessages = [...messages, newMessage];
    setMessages(updatedMessages);
    setInputText('');

    // TODO: Gọi API để gửi tin thực tế
  };

  return (
    <div className="chat-wrapper">
      <div className="chat-sidebar">
        <h3>Khách hàng</h3>
        <ul>
          {mockUsers.map((user) => (
            <li
              key={user.id}
              className={user.id === selectedUser.id ? 'active' : ''}
              onClick={() => setSelectedUser(user)}
            >
              {user.name}
            </li>
          ))}
        </ul>
      </div>
      <div className="chat-main">
        <div className="chat-header">
          Đang trò chuyện với: <strong>{selectedUser.name}</strong>
        </div>
        <div className="chat-content">
          {messages.map((msg) => (
            <div
              key={msg._id}
              className={`message ${
                msg.senderId === currentUserId ? 'sent' : 'received'
              }`}
            >
              <div className="msg">{msg.content}</div>
              <div className="time">
                {new Date(msg.createdAt).toLocaleTimeString()}
              </div>
            </div>
          ))}
        </div>
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
      </div>
    </div>
  );
};

export default CustomerSupportChat;
