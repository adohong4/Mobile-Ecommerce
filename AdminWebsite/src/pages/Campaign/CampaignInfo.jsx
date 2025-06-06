import React, { useEffect, useContext, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import { formatDayTime, formatCurrency } from '../../lib/utils';
import { Form, Input, Button, Select, DatePicker, InputNumber, Tooltip, Row, Col, Space } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import { CampaignContext } from '../../context/CampaignContextProvider';
import { ProductContext } from '../../context/ProductContextProvider';
import moment from 'moment';
const { Option } = Select;

const CampaignInfo = () => {
    const { id } = useParams();
    const { fetchCampaignById, updateCampaignById } = useContext(CampaignContext);
    const { productList } = useContext(ProductContext);
    const [campaign, setCampaign] = useState(null);
    const [form] = Form.useForm();
    const [filteredProducts, setFilteredProducts] = useState([]);
    const [appliesTo, setAppliesTo] = useState('items');
    const [type, setType] = useState('percentage');
    const navigate = useNavigate();

    useEffect(() => {
        setFilteredProducts(productList || []);
    }, [productList]);

    useEffect(() => {
        const fetchCampaign = async () => {
            try {
                const campaignData = await fetchCampaignById(id);
                setCampaign(campaignData);

                if (campaignData) {
                    form.setFieldsValue({
                        name: campaignData.name,
                        description: campaignData.description,
                        type: campaignData.type,
                        value: campaignData.value,
                        code: campaignData.code,
                        startDate: campaignData.startDate ? moment(campaignData.startDate) : null,
                        endDate: campaignData.endDate ? moment(campaignData.endDate) : null,
                        status: campaignData.status,
                        maxValue: campaignData.maxValue,
                        appliesTo: campaignData.appliesTo,
                        productIds: campaignData.productIds || [],
                    });
                    setType(campaignData.type || 'percentage');
                    setAppliesTo(campaignData.appliesTo || 'items');
                } else {
                    toast.error('Không tìm thấy chiến dịch');
                }
            } catch (error) {
                toast.error('Lỗi khi lấy thông tin chiến dịch: ' + error.message);
            }
        };
        fetchCampaign();
    }, [id, fetchCampaignById, form]);

    // Tìm kiếm sản phẩm
    const handleSearch = (value) => {
        const filtered = productList.filter((product) =>
            product.title?.toLowerCase().includes(value.toLowerCase())
        );
        setFilteredProducts(filtered);
    };

    // Cập nhật chiến dịch
    const onFinish = async (values) => {
        try {
            const formattedValues = {
                ...values,
                startDate: values.startDate ? values.startDate.toISOString() : null,
                endDate: values.endDate ? values.endDate.toISOString() : null,
            };
            console.log("formattedValues", formattedValues)
            await updateCampaignById(id, formattedValues);

            toast.success('Cập nhật chiến dịch thành công');
            navigate('/list-campaign');
        } catch (error) {
            toast.error(response.data.metadata);
        }
    };

    return (
        <Form
            form={form}
            layout="vertical"
            onFinish={onFinish}
            initialValues={{ type: 'percentage', value: 0, maxValue: 1000000 }}
            style={{ padding: '20px', margin: 'auto' }}
        >
            <Form.Item style={{ textAlign: 'right' }}>
                <Button type="primary" style={{ marginLeft: '16px' }} onClick={() => navigate('/list-campaign')}>
                    ← Quay lại danh sách
                </Button>
            </Form.Item>
            <Row gutter={16}>
                <Col xs={24} md={12}>
                    <Form.Item
                        label="Tên chiến dịch"
                        name="name"
                        rules={[{ required: true, message: 'Vui lòng nhập tên chiến dịch!' }]}
                    >
                        <Input placeholder="VD: Ngày quốc tế phụ nữ" />
                    </Form.Item>

                    <Form.Item
                        label="Mã khuyến mãi"
                        name="code"
                        rules={[{ required: true, message: 'Vui lòng nhập mã khuyến mãi!' }]}
                    >
                        <Input placeholder="VD: WOMANDAY83" />
                    </Form.Item>

                    <Form.Item label="Giá trị khuyến mãi">
                        <Space.Compact>
                            <Form.Item name="type" noStyle>
                                <Select onChange={(value) => setType(value)} style={{ width: '40%' }}>
                                    <Option value="percentage">%</Option>
                                    <Option value="fixed_amount">Số tiền</Option>
                                </Select>
                            </Form.Item>
                            <Form.Item name="value" noStyle>
                                <InputNumber style={{ width: '60%' }} min={0} formatter={(value) => formatCurrency(value)} />
                            </Form.Item>
                        </Space.Compact>
                    </Form.Item>
                    {type === 'percentage' && (
                        <Form.Item label="Giá trị giảm tối đa" name="maxValue">
                            <InputNumber style={{ width: '100%' }} min={0} formatter={(value) => formatCurrency(value)} />
                        </Form.Item>
                    )}

                    <Form.Item label="Trạng thái chiến dịch" name="status">
                        <Select>
                            <Option value="active">Hoạt động</Option>
                            <Option value="paused">Tạm dừng</Option>
                            <Option value="completed">Kết thúc</Option>
                            <Option value="pending">Chờ xử lý</Option>
                            <Option value="cancelled">Bị hủy</Option>
                            <Option value="failed">Thất bại</Option>
                        </Select>
                    </Form.Item>
                </Col>

                <Col xs={24} md={12}>
                    <Form.Item label="Thời gian">
                        <Row gutter={8}>
                            <Col span={12}>
                                <Form.Item name="startDate" noStyle>
                                    <DatePicker showTime format="YYYY-MM-DD HH:mm:ss" style={{ width: '100%' }} />
                                </Form.Item>
                            </Col>
                            <Col span={12}>
                                <Form.Item name="endDate" noStyle>
                                    <DatePicker showTime format="YYYY-MM-DD HH:mm:ss" style={{ width: '100%' }} />
                                </Form.Item>
                            </Col>
                        </Row>
                    </Form.Item>
                    <Form.Item label="Áp dụng cho" name="appliesTo">
                        <Select onChange={(value) => setAppliesTo(value)}>
                            <Option value="items">Từng sản phẩm</Option>
                            <Option value="all">Toàn bộ sản phẩm</Option>
                        </Select>
                    </Form.Item>
                    {appliesTo === 'items' && (
                        <Form.Item label="Danh sách sản phẩm áp dụng" name="productIds">
                            <Select
                                mode="multiple"
                                showSearch
                                placeholder="Tìm kiếm và chọn sản phẩm"
                                options={filteredProducts.map((product) => ({
                                    value: product._id,
                                    label: (
                                        <Tooltip title={product.title || ''}>
                                            {product.title && product.title.length > 60
                                                ? `${product.title.substring(0, 60)}...`
                                                : product.title || 'Không có tiêu đề'}
                                        </Tooltip>
                                    ),
                                }))}
                                onSearch={handleSearch}
                            />
                        </Form.Item>
                    )}
                </Col>
            </Row>

            <Form.Item label="Mô tả" name="description">
                <Input.TextArea placeholder="VD: Chương trình giảm giá ngày quốc tế phụ nữ." />
            </Form.Item>

            <Form.Item style={{ textAlign: 'center' }}>
                <Button type="primary" htmlType="submit" icon={<PlusOutlined />}>
                    Cập nhật khuyến mãi
                </Button>
            </Form.Item>
        </Form>
    );
};

export default CampaignInfo;