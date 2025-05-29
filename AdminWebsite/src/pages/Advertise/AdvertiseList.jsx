import React, { useEffect, useContext, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import {
    Table,
    Button,
    Input,
    Popconfirm,
    Descriptions,
    Space,
    Tooltip,
    Switch,
    Upload,
} from 'antd';
import {
    BookFilled,
    EditFilled,
    DeleteOutlined,
    UploadOutlined,
} from '@ant-design/icons';
import { AdvertiseContext } from '../../context/AdvertiseContextProvider';
import axios from 'axios';

const AdvertiseList = () => {
    const {
        advertiseList,
        fetchAdvertiseList,
        deleteAdvertise,
        activeAdvertise,
        addAdvertise,
    } = useContext(AdvertiseContext);

    const [searchTerm, setSearchTerm] = useState('');
    const [viewingAdvertise, setViewingAdvertise] = useState(null);
    const [newBanner, setNewBanner] = useState({
        imageAds: '',
        classify: '',
        recap: '',
    });
    const [uploading, setUploading] = useState(false);

    const navigate = useNavigate();

    useEffect(() => {
        fetchAdvertiseList();
    }, [fetchAdvertiseList]);

    const handleDelete = async (advertiseId) => {
        try {
            await deleteAdvertise(advertiseId);
            toast.success('Đã xóa quảng cáo');
        } catch {
            toast.error('Lỗi khi xóa quảng cáo');
        }
    };

    const handleToggleStatus = async (advertiseId, currentStatus) => {
        try {
            await activeAdvertise(advertiseId);
            toast.success('Đã cập nhật trạng thái');
        } catch {
            toast.error('Lỗi khi cập nhật trạng thái quảng cáo');
        }
    };

    const handleAddSubmit = async () => {
        const { imageAds, classify, recap } = newBanner;
        if (!imageAds || !classify || !recap) {
            toast.warning('Vui lòng điền đầy đủ thông tin');
            return;
        }

        try {
            await addAdvertise(newBanner);
            toast.success('Thêm banner thành công!');
            setNewBanner({ imageAds: '', classify: '', recap: '' });
            fetchAdvertiseList();
        } catch {
            toast.error('Lỗi khi thêm banner!');
        }
    };

    const handleImageUpload = async (file) => {
        const formData = new FormData();
        formData.append('image', file);

        try {
            setUploading(true);
            const res = await axios.post('http://localhost:9004/upload', formData);
            const filename = res.data.filename;
            setNewBanner({ ...newBanner, imageAds: filename });
            toast.success('Tải ảnh lên thành công');
        } catch {
            toast.error('Tải ảnh lên thất bại');
        } finally {
            setUploading(false);
        }
    };

    const filteredAdvertises = advertiseList.filter((ad) =>
        ad.recap?.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const columns = [
        {
            title: 'Tiêu đề',
            dataIndex: 'recap',
            key: 'recap',
        },
        {
            title: 'Phân loại',
            dataIndex: 'classify',
            key: 'classify',
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
        },
        {
            title: 'Ngày tạo',
            dataIndex: 'createdAt',
            key: 'createdAt',
            render: (createdAt) => new Date(createdAt).toLocaleString(),
        },
        {
            title: 'Ngày cập nhật',
            dataIndex: 'updatedAt',
            key: 'updatedAt',
            render: (updatedAt) => new Date(updatedAt).toLocaleString(),
        },
        {
            title: 'Hành động',
            key: 'action',
            align: 'center',
            render: (_, record) => (
                <Space>
                    <Tooltip title="Xem chi tiết">
                        <Button
                            icon={<BookFilled style={{ color: 'orange' }} />}
                            onClick={() => setViewingAdvertise(record)}
                        />
                    </Tooltip>
                    <Tooltip title="Chỉnh sửa">
                        <Button
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
                            <Button icon={<DeleteOutlined />} danger />
                        </Tooltip>
                    </Popconfirm>
                </Space>
            ),
        },
    ];

    return (
        <div style={{ padding: 20 }}>
            <h2>Thêm banner mới</h2>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 10, marginBottom: 20, justifyContent:'end'}}>
                <Input
                placeholder="Tìm kiếm quảng cáo"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                style={{ width: 300}}
                />
                <Input
                    placeholder="Tiêu đề (recap)"
                    value={newBanner.recap}
                    onChange={(e) => setNewBanner({ ...newBanner, recap: e.target.value })}
                    style={{ width: 200 }}
                />
                <Input
                    placeholder="Phân loại (classify)"
                    value={newBanner.classify}
                    onChange={(e) => setNewBanner({ ...newBanner, classify: e.target.value })}
                    style={{ width: 200 }}
                />
                <Upload
                    showUploadList={false}
                    beforeUpload={(file) => {
                        handleImageUpload(file);
                        return false;
                    }}
                >
                    <Button icon={<UploadOutlined />} loading={uploading}>
                        Chọn ảnh
                    </Button>
                </Upload>
                <Button type="primary" onClick={handleAddSubmit}>
                    Thêm
                </Button>
            </div>

            {newBanner.imageAds && (
                <div style={{ marginBottom: 20 }}>
                    <strong>Xem trước ảnh:</strong><br />
                    <img
                        src={`http://localhost:9004/images/${newBanner.imageAds}`}
                        alt="Preview"
                        style={{ width: 200, height: 100, objectFit: 'cover', borderRadius: 4 }}
                    />
                </div>
            )}

            

            <Table
                columns={columns}
                dataSource={filteredAdvertises.map((ad) => ({ ...ad, key: ad._id }))}
                pagination={{ pageSize: 7 }}
            />

            {viewingAdvertise && (
                <div style={{ marginTop: 40 }}>
                    <h3>Thông tin quảng cáo</h3>
                    <Descriptions bordered column={1}>
                        <Descriptions.Item label="Tiêu đề">{viewingAdvertise.recap}</Descriptions.Item>
                        <Descriptions.Item label="Phân loại">{viewingAdvertise.classify}</Descriptions.Item>
                        <Descriptions.Item label="Hình ảnh">
                            <img
                                src={`http://localhost:9004/images/${viewingAdvertise.imageAds}`}
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
                </div>
            )}
        </div>
    );
};

export default AdvertiseList;
