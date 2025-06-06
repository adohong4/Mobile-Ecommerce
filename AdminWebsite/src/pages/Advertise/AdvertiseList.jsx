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
    Checkbox,
} from 'antd';
import {
    BookFilled,
    EditFilled,
    DeleteOutlined,
} from '@ant-design/icons';
import { AdvertiseContext } from '../../context/AdvertiseContextProvider';

const AdvertiseList = () => {
    const {
        advertiseList,
        fetchAdvertiseList,
        deleteAdvertise,
        activeAdvertise,
        createAdvertise, // Sử dụng đúng tên hàm từ context
    } = useContext(AdvertiseContext);

    const [searchTerm, setSearchTerm] = useState('');
    const [viewingAdvertise, setViewingAdvertise] = useState(null);
    const [newBanner, setNewBanner] = useState({
        imageAds: null, // Lưu file gốc
        classify: '',
        recap: '',
        preview: '', // Lưu URL xem trước
    });

    const navigate = useNavigate();

    useEffect(() => {
        fetchAdvertiseList();
    }, [fetchAdvertiseList]);

    const handleImageChange = (e) => {
        const file = e.target.files[0];
        if (file) {
            if (!file.type.startsWith('image/')) {
                toast.error('Vui lòng chọn một tệp ảnh hợp lệ');
                return;
            }
            setNewBanner({
                ...newBanner,
                imageAds: file,
                preview: URL.createObjectURL(file),
            });
        }
    };

    const handleAddSubmit = async () => {
        const { imageAds, classify, recap } = newBanner;
        if (!imageAds || !classify || !recap) {
            toast.warning('Vui lòng điền đầy đủ thông tin');
            return;
        }

        const formData = new FormData();
        formData.append('imageAds', imageAds);
        formData.append('classify', classify);
        formData.append('recap', recap);

        try {
            const res = await createAdvertise(formData); // Gọi createAdvertise thay vì addAdvertise
            toast.success('Thêm banner thành công!');
            setNewBanner({ imageAds: null, classify: '', recap: '', preview: '' });
            fetchAdvertiseList();
        } catch (error) {
            toast.error('Lỗi khi thêm banner: ' + error.message);
        }
    };

    const handleDelete = async (advertiseId) => {
        try {
            await deleteAdvertise(advertiseId);
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
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 10, marginBottom: 20, justifyContent: 'end' }}>
                <Input
                    placeholder="Tìm kiếm quảng cáo"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    style={{ width: 300 }}
                />
                <Input
                    placeholder="Tiêu đề (recap)"
                    value={newBanner.recap}
                    onChange={(e) => setNewBanner({ ...newBanner, recap: e.target.value })}
                    style={{ width: 200 }}
                />
                <Checkbox.Group
                    options={[
                        { label: 'Banner', value: 'Banner' },
                        { label: 'Quảng Cáo', value: 'ADVERTISE' }
                    ]}
                    style={{ alignItems: 'center' }}
                    value={[newBanner.classify]}
                    onChange={(checkedValues) => {
                        if (checkedValues.length > 0) {
                            setNewBanner({ ...newBanner, classify: checkedValues[0] });
                        } else {
                            setNewBanner({ ...newBanner, classify: '' });
                        }
                    }}
                />
                <input
                    type="file"
                    accept="image/*"
                    onChange={handleImageChange}
                    style={{ width: 200, paddingTop: 4 }}
                />
                <Button type="primary" onClick={handleAddSubmit}>
                    Thêm
                </Button>
            </div>

            {newBanner.preview && (
                <div style={{ marginBottom: 20 }}>
                    <strong>Xem trước ảnh:</strong><br />
                    <img
                        src={newBanner.preview}
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