import React, { useEffect, useContext, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import { Table, Button, Input, Popconfirm, Modal, Descriptions, Space, Tooltip, Switch } from 'antd';
import { BookFilled, EditFilled, DeleteOutlined, PlusOutlined } from '@ant-design/icons';
import { AdvertiseContext } from '../../context/AdvertiseContextProvider';
import '../styles/styles.css';

const AdvertiseList = () => {
    const { advertiseList, fetchAdvertiseList, deleteAdvertise, activeAdvertise } = useContext(AdvertiseContext);
    const [searchTerm, setSearchTerm] = useState('');
    const [viewingAdvertise, setViewingAdvertise] = useState(null);
    const [isViewModalOpen, setIsViewModalOpen] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        fetchAdvertiseList();
    }, [fetchAdvertiseList]);

    const handleDelete = async (advertiseId) => {
        try {
            await deleteAdvertise(advertiseId);
        } catch (error) {
            toast.error('Lỗi khi xóa quảng cáo');
        }
    };

    const handleToggleStatus = async (advertiseId, currentStatus) => {
        try {
            await activeAdvertise(advertiseId);
        } catch (error) {
            toast.error('Lỗi khi cập nhật trạng thái quảng cáo');
        }
    };

    const handleAddAdvertise = () => {
        navigate('/add-advertise');
    };

    const showViewModal = (advertise) => {
        setViewingAdvertise(advertise);
        setIsViewModalOpen(true);
    };

    const filteredAdvertises = advertiseList.filter((advertise) =>
        advertise.recap?.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const columns = [
        {
            title: 'Tiêu đề',
            dataIndex: 'recap',
            key: 'recap',
            sorter: (a, b) => a.recap.localeCompare(b.recap),
        },
        {
            title: 'Hình ảnh',
            dataIndex: 'imageAds',
            key: 'imageAds',
            render: (imageAds) => (
                <img
                    src={`http://localhost:9004/images/${imageAds}`}
                    alt="Advertise"
                    style={{ width: 100, height: 50, objectFit: 'cover' }}
                />
            ),
        },
        {
            title: 'Trạng thái',
            dataIndex: 'status',
            key: 'status',
            render: (status, record) => (
                <Switch
                    checked={status}
                    onChange={() => handleToggleStatus(record._id, status)}
                    checkedChildren="Hoạt động"
                    unCheckedChildren="Ngừng"
                />
            ),
            sorter: (a, b) => Number(a.status) - Number(b.status),
        },
        {
            title: 'Ngày tạo',
            dataIndex: 'createdAt',
            key: 'createdAt',
            render: (createdAt) => new Date(createdAt).toLocaleString(),
            sorter: (a, b) => new Date(a.createdAt) - new Date(b.createdAt),
        },
        {
            title: 'Ngày cập nhật',
            dataIndex: 'updatedAt',
            key: 'updatedAt',
            render: (updatedAt) => new Date(updatedAt).toLocaleString(),
            sorter: (a, b) => new Date(a.updatedAt) - new Date(b.updatedAt),
        },
        {
            title: 'Hành động',
            key: 'action',
            align: 'center',
            render: (_, record) => (
                <Space size="middle">
                    <Tooltip title="Xem chi tiết">
                        <Button
                            shape="circle"
                            icon={<BookFilled style={{ color: 'orange' }} />}
                            onClick={() => showViewModal(record)}
                        />
                    </Tooltip>
                    <Tooltip title="Cập nhật thông tin">
                        <Button
                            shape="circle"
                            icon={<EditFilled />}
                            onClick={() => navigate(`/edit-advertise/${record._id}`)}
                        />
                    </Tooltip>
                    <Popconfirm
                        title="Xóa quảng cáo này?"
                        onConfirm={() => handleDelete(record._id)}
                        okText="Xóa"
                        cancelText="Hủy"
                    >
                        <Tooltip title="Xóa">
                            <Button shape="circle" icon={<DeleteOutlined />} danger />
                        </Tooltip>
                    </Popconfirm>
                </Space>
            ),
        },
    ];

    return (
        <div style={{ padding: 20 }}>
            <div style={{ display: 'flex', marginBottom: 16 }}>
                <Input
                    placeholder="Tìm kiếm quảng cáo"
                    style={{ width: 200, marginRight: 8, backgroundColor: '#fff' }}
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                />
                <Button type="primary" icon={<PlusOutlined />} onClick={handleAddAdvertise}>
                    Thêm quảng cáo mới
                </Button>
            </div>
            <Table
                columns={columns}
                dataSource={filteredAdvertises.map((advertise) => ({ ...advertise, key: advertise._id }))}
                rowKey="key"
                pagination={{ pageSize: 7 }}
            />
            <Modal
                open={isViewModalOpen}
                onCancel={() => setIsViewModalOpen(false)}
                footer={null}
                title="Thông tin quảng cáo"
            >
                {viewingAdvertise && (
                    <Descriptions column={1} bordered>
                        <Descriptions.Item label="Tiêu đề">{viewingAdvertise.recap}</Descriptions.Item>
                        <Descriptions.Item label="Hình ảnh">
                            <img
                                src={viewingAdvertise.imageAds}
                                alt="Advertise"
                                style={{ width: 200, height: 100, objectFit: 'cover' }}
                            />
                        </Descriptions.Item>
                        <Descriptions.Item label="Trạng thái">
                            {viewingAdvertise.status ? 'Hoạt động' : 'Ngừng'}
                        </Descriptions.Item>
                        <Descriptions.Item label="Ngày tạo">
                            {new Date(viewingAdvertise.createdAt).toLocaleString()}
                        </Descriptions.Item>
                        <Descriptions.Item label="Ngày cập nhật">
                            {new Date(viewingAdvertise.updatedAt).toLocaleString()}
                        </Descriptions.Item>
                    </Descriptions>
                )}
            </Modal>
        </div>
    );
};

export default AdvertiseList;