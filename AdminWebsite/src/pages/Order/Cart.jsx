import React, { useEffect, useContext, useState, useRef } from 'react';
import { toast } from 'react-toastify';
import { OrderContext } from '../../context/OrderContextProvider';
import { Table, Input, Popconfirm, Button, Pagination, Modal, Descriptions, Select, Space } from 'antd';
import { DeleteOutlined, BookFilled } from '@ant-design/icons';
import { formatHourDayTime, formatCurrency } from '../../lib/utils';
import '../styles/styles.css';

const { Option } = Select;

const Cart = () => {
    const { orderList, fetchOrderList, updateStatusOrder, toggleOrderStatus } = useContext(OrderContext);
    const [filteredList, setFilteredList] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [limit, setLimit] = useState(10);
    const [searchTerm, setSearchTerm] = useState('');
    const [viewingOrder, setViewingOrder] = useState(null);
    const [isViewModalOpen, setIsViewModalOpen] = useState(false);
    const [selectedType, setSelectedType] = useState('');
    const [selectedStatus, setSelectedStatus] = useState('');
    const popupRef = useRef(null);

    useEffect(() => {
        const loadOrders = async () => {
            try {
                await fetchOrderList();
            } catch (error) {
                toast.error('Lỗi khi tải danh sách đơn hàng');
            }
        };
        loadOrders();
    }, [fetchOrderList]);

    useEffect(() => {
        const filtered = orderList.filter((order) => {
            const matchesSearchTerm =
                searchTerm === '' ||
                order._id.toLowerCase().includes(searchTerm.toLowerCase()) ||
                order.address?.fullname?.toLowerCase().includes(searchTerm.toLowerCase());
            const matchesType = !selectedType || order.paymentMethod === selectedType;
            const matchesStatus = !selectedStatus || order.status === selectedStatus;
            return matchesSearchTerm && matchesType && matchesStatus;
        });
        setFilteredList(filtered);
    }, [orderList, searchTerm, selectedType, selectedStatus]);

    const handleStatusChange = async (value, orderId) => {
        try {
            await updateStatusOrder(orderId, value);
            await fetchOrderList();
        } catch (error) {
            toast.error('Lỗi khi cập nhật trạng thái đơn hàng');
        }
    };

    const handleToggleStatus = async (orderId) => {
        try {
            await toggleOrderStatus(orderId);
            await fetchOrderList();
        } catch (error) {
            toast.error('Lỗi khi xóa/khôi phục đơn hàng');
        }
    };

    const handlePrint = () => {
        if (popupRef.current) {
            const printContent = popupRef.current.innerHTML;
            const printWindow = window.open('', '_blank');
            printWindow.document.write(`
        <html>
          <head>
            <title>Hóa đơn</title>
            <style>
              @media print {
                body {
                  font-family: Arial, sans-serif;
                  font-size: 14px;
                  padding: 20px;
                }
                #invoice-print-area {
                  max-width: 600px;
                  margin: auto;
                  border: 2px solid black;
                  padding: 20px;
                  background: white;
                  box-shadow: 0px 0px 10px gray;
                }
                h1 {
                  text-align: center;
                  font-size: 20px;
                  margin-bottom: 10px;
                }
                table {
                  width: 100%;
                  border-collapse: collapse;
                  margin-top: 10px;
                }
                th, td {
                  border: 1px solid black;
                  padding: 10px;
                  text-align: left;
                }
                th {
                  background-color: #f2f2f2;
                  font-weight: bold;
                }
                .ant-btn { display: none; }
              }
            </style>
          </head>
          <body>
            <div id="invoice-print-area">${printContent}</div>
            <script>
              window.onload = function() { window.print(); };
            </script>
          </body>
        </html>
      `);
            printWindow.document.close();
        }
    };

    const showViewModal = (order) => {
        setViewingOrder(order);
        setIsViewModalOpen(true);
    };

    // Phân trang trên giao diện
    const startIndex = (currentPage - 1) * limit;
    const paginatedOrders = filteredList.slice(startIndex, startIndex + limit);

    const columns = [
        {
            title: 'Mã hóa đơn',
            dataIndex: '_id',
            key: '_id',
            render: (text) => (text.length > 15 ? `${text.slice(0, 15)}...` : text),
            sorter: (a, b) => a._id.localeCompare(b._id),
        },
        {
            title: 'Thời gian',
            dataIndex: 'createdAt',
            key: 'createdAt',
            render: (createdAt) => formatHourDayTime(createdAt),
            sorter: (a, b) => new Date(a.createdAt) - new Date(b.createdAt),
        },
        {
            title: 'Khách hàng',
            dataIndex: 'address',
            key: 'address',
            render: (address) => address?.fullname || 'Không có tên',
        },
        {
            title: 'Hình thức thanh toán',
            dataIndex: 'paymentMethod',
            key: 'paymentMethod',
            sorter: (a, b) => a.paymentMethod.localeCompare(b.paymentMethod),
        },
        {
            title: 'Giá trị hóa đơn',
            dataIndex: 'amount',
            key: 'amount',
            render: (amount) => formatCurrency(amount),
            sorter: (a, b) => a.amount - b.amount,
        },
        {
            title: 'Địa chỉ',
            dataIndex: 'address',
            key: 'address',
            render: (address) => {
                const { street, precinct, city, province } = address || {};
                const addressParts = [street, precinct, city, province].filter((part) => part);
                const fullAddress = addressParts.length > 0 ? addressParts.join(', ') : 'Không có địa chỉ';
                return fullAddress.length > 30 ? `${fullAddress.slice(0, 20)}...` : fullAddress;
            },
        },
        {
            title: 'Trạng thái',
            dataIndex: 'status',
            key: 'status',
            render: (status, record) => (
                <Select
                    value={status}
                    onChange={(value) => handleStatusChange(value, record._id)}
                    style={{
                        backgroundColor:
                            status === 'pending'
                                ? '#2c3e50'
                                : status === 'confirmed'
                                    ? '#d35400'
                                    : status === 'shipping'
                                        ? '#f39c12'
                                        : status === 'delivered'
                                            ? '#27ae60'
                                            : '#ecf0f1',
                        color: ['pending', 'confirmed', 'shipping', 'delivered'].includes(status)
                            ? 'white'
                            : 'black',
                        width: 'fit-content',
                    }}
                >
                    <Option value="pending">Đợi xác nhận</Option>
                    <Option value="confirmed">Đang chuẩn bị hàng</Option>
                    <Option value="shipping">Đang giao hàng</Option>
                    <Option value="delivered">Giao hàng thành công</Option>
                    <Option value="cancelled">Hủy đơn hàng</Option>
                </Select>
            ),
        },
        {
            title: 'Tùy chỉnh',
            key: 'action',
            render: (_, record) => (
                <Space>
                    <Button icon={<BookFilled />} onClick={() => showViewModal(record)} />
                    <Popconfirm
                        title="Xóa/khôi phục đơn hàng này?"
                        onConfirm={() => handleToggleStatus(record._id)}
                        okText="Thực hiện"
                        cancelText="Hủy"
                    >
                        <Button icon={<DeleteOutlined />} danger />
                    </Popconfirm>
                </Space>
            ),
        },
    ];

    const columnsItem = [
        {
            title: 'Tên hàng',
            dataIndex: 'title',
            key: 'title',
            render: (text) => (text && text.length > 15 ? `${text.slice(0, 15)}...` : text || 'Không có tên'),
        },
        { title: 'Số lượng', dataIndex: 'quantity', key: 'quantity' },
        {
            title: 'Đơn giá',
            dataIndex: 'price',
            key: 'price',
            render: (price) => formatCurrency(price),
        },
        {
            title: 'Thành tiền',
            key: 'total',
            render: (_, record) => formatCurrency((record.price || 0) * (record.quantity || 0)),
        },
    ];

    const columnsCreator = [
        { title: 'Người tạo', dataIndex: 'createdName', key: 'createdName' },
        { title: 'Mô tả', dataIndex: 'description', key: 'description' },
        {
            title: 'Ngày tạo',
            dataIndex: 'createdAt',
            key: 'createdAt',
            render: (text) => (text ? new Date(text).toLocaleString() : 'Không có ngày'),
        },
    ];

    return (
        <div className="order-list-container" style={{ padding: 20 }}>
            <div style={{ display: 'flex', marginBottom: 16 }}>
                <Input
                    placeholder="Tìm kiếm hóa đơn..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    style={{ width: 200, marginRight: 8 }}
                />
                <Select
                    placeholder="Hình thức thanh toán"
                    value={selectedType}
                    style={{ width: 200, marginRight: 8 }}
                    onChange={(value) => setSelectedType(value)}
                    allowClear
                >
                    <Option value="Thanh toán trực tuyến">Thanh toán trực tuyến</Option>
                    <Option value="Thanh toán khi nhận hàng">Thanh toán khi nhận hàng</Option>
                </Select>
                <Select
                    placeholder="Trạng thái"
                    value={selectedStatus}
                    style={{ width: 200 }}
                    onChange={(value) => setSelectedStatus(value)}
                    allowClear
                >
                    <Option value="pending">Đợi xác nhận</Option>
                    <Option value="confirmed">Đang chuẩn bị hàng</Option>
                    <Option value="shipping">Đang giao hàng</Option>
                    <Option value="delivered">Giao hàng thành công</Option>
                </Select>
            </div>
            <Table
                columns={columns}
                dataSource={paginatedOrders.map((order) => ({ ...order, key: order._id }))}
                rowKey="key"
                pagination={false}
            />
            <Pagination
                current={currentPage}
                total={filteredList.length}
                pageSize={limit}
                onChange={(page) => setCurrentPage(page)}
                showSizeChanger
                pageSizeOptions={['5', '10', '20', '30']}
                onShowSizeChange={(current, size) => {
                    setLimit(size);
                    setCurrentPage(1);
                }}
                style={{ marginTop: 16, textAlign: 'right' }}
            />
            <Modal open={isViewModalOpen} onCancel={() => setIsViewModalOpen(false)} footer={null} width={800}>
                {viewingOrder && (
                    <>
                        <div ref={popupRef}>
                            <Descriptions title="Thông tin Đơn hàng" column={1} bordered>
                                <Descriptions.Item label="Mã hóa đơn">{viewingOrder._id}</Descriptions.Item>
                                <Descriptions.Item label="Khách hàng">{viewingOrder.address?.fullname || 'Không có tên'}</Descriptions.Item>
                                <Descriptions.Item label="Đơn giá">{formatCurrency(viewingOrder.amount)} VNĐ</Descriptions.Item>
                                <Descriptions.Item label="Ngày đặt hàng">{formatHourDayTime(viewingOrder.createdAt)}</Descriptions.Item>
                                <Descriptions.Item label="Thanh toán">{viewingOrder.paymentMethod == 'cod' ? 'Tiền mặt' : 'Thanh toán điện tử'}</Descriptions.Item>
                                <Descriptions.Item label="Trạng thái">{viewingOrder.status == 'pending' ? 'Đợi xác nhận' : viewingOrder.status == 'confirmed' ? 'Đang chuẩn bị hàng' : viewingOrder.status == 'shipping' ? 'Đang giao hàng' : viewingOrder.status == 'delivered' ? 'Giao hàng thành công' : 'Đơn hàng bị hủy'}</Descriptions.Item>
                                <Descriptions.Item label="Địa chỉ">
                                    {[viewingOrder.address?.street, viewingOrder.address?.precinct, viewingOrder.address?.city, viewingOrder.address?.province]
                                        .filter((part) => part)
                                        .join(', ') || 'Không có địa chỉ'}
                                </Descriptions.Item>
                            </Descriptions>
                            <Table
                                columns={columnsItem}
                                dataSource={viewingOrder.items?.map((item, index) => ({
                                    ...item,
                                    key: item.id || index,
                                }))}
                                rowKey="key"
                                pagination={false}
                                style={{ marginTop: 16 }}
                            />
                            <Button type="primary" onClick={handlePrint} style={{ marginTop: 16 }}>
                                In Đơn Hàng
                            </Button>
                        </div>
                        {viewingOrder.creator?.length > 0 && (
                            <div style={{ marginTop: 24 }}>
                                <h3>Lịch sử thay đổi</h3>
                                <Table
                                    columns={columnsCreator}
                                    dataSource={viewingOrder.creator.map((item, index) => ({
                                        ...item,
                                        key: `${item.createdBy || 'unknown'}-${index}`,
                                    }))}
                                    pagination={{ pageSize: 4 }}
                                    rowKey="key"
                                />
                            </div>
                        )}
                    </>
                )}
            </Modal>
        </div>
    );
};

export default Cart;