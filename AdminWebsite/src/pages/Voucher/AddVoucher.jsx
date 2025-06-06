import React, { useState, useContext } from 'react';
import { useForm } from 'react-hook-form';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import { format } from 'date-fns';
import '../styles/styles.css';
import { VoucherContext } from '../../context/VoucherContextProvider';

const AddVoucherForm = () => {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();

  const [startDate, setStartDate] = useState(null);
  const [endDate, setEndDate] = useState(null);
  const { createVoucher } = useContext(VoucherContext);
  const navigate = useNavigate();

  const onSubmit = async (data) => {
    if (!startDate || !endDate) {
      toast.error('Vui lòng chọn ngày bắt đầu và kết thúc.');
      return;
    }

    const voucher = {
      ...data,
      discountValue: parseInt(data.discountValue),
      minOrderValue: parseInt(data.minOrderValue),
      maxDiscountAmount: parseInt(data.maxDiscountAmount),
      usageLimit: parseInt(data.usageLimit),
      startDate: format(startDate, 'yyyy-MM-dd'),
      endDate: format(endDate, 'yyyy-MM-dd'),
    };

    const result = await createVoucher(voucher);
    console.log('Voucher created:', voucher);
    if (result.success) {
      toast.success('Voucher đã được tạo!');
      navigate('/voucher');
    } else {
      toast.error('Lỗi khi tạo voucher. Vui lòng thử lại.');
      console.error('Error creating voucher:', result.error);
    }
  };

  return (
    <div className="form-container">
      <h2 className="form-title">Thêm Voucher Mới</h2>
      <form onSubmit={handleSubmit(onSubmit)} className="form-two-column">
        <div className="form-column">
          <div className="form-group">
            <label>Mã voucher</label>
            <input
              {...register('code', { required: 'Mã voucher không được để trống' })}
              className="form-input"
              placeholder="AUTUMN2025"
            />
            {errors.code && <p className="error-text">{errors.code.message}</p>}
          </div>

          <div className="form-group">
            <label>Loại giảm giá</label>
            <select
              {...register('discountType', { required: 'Vui lòng chọn loại giảm giá' })}
              className="form-input"
            >
              <option value="FIXED_AMOUNT">Giảm giá cố định</option>
              <option value="PERCENTAGE">Phần trăm</option>
            </select>
            {errors.discountType && <p className="error-text">{errors.discountType.message}</p>}
          </div>

          <div className="form-group">
            <label>Giá trị giảm</label>
            <input
              type="number"
              {...register('discountValue', {
                required: 'Giá trị giảm không được để trống',
                min: { value: 1, message: 'Giá trị giảm phải lớn hơn 0' },
              })}
              className="form-input"
              placeholder="200000"
            />
            {errors.discountValue && <p className="error-text">{errors.discountValue.message}</p>}
          </div>

          <div className="form-group">
            <label>Giá trị đơn hàng tối thiểu</label>
            <input
              type="number"
              {...register('minOrderValue', {
                required: 'Giá trị đơn hàng tối thiểu không được để trống',
                min: { value: 1, message: 'Giá trị đơn hàng tối thiểu phải lớn hơn 0' },
              })}
              className="form-input"
              placeholder="1999000"
            />
            {errors.minOrderValue && <p className="error-text">{errors.minOrderValue.message}</p>}
          </div>
        </div>

        <div className="form-column">
          <div className="form-group">
            <label>Số lượt sử dụng tối đa</label>
            <input
              type="number"
              {...register('usageLimit', {
                required: 'Số lượt sử dụng không được để trống',
                min: { value: 1, message: 'Số lượt sử dụng phải lớn hơn 0' },
              })}
              className="form-input"
              placeholder="20"
            />
            {errors.usageLimit && <p className="error-text">{errors.usageLimit.message}</p>}
          </div>

          <div className="form-group">
            <label>Giảm tối đa</label>
            <input
              type="number"
              {...register('maxDiscountAmount', {
                required: 'Giá trị giảm tối đa không được để trống',
                min: { value: 1, message: 'Giá trị giảm tối đa phải lớn hơn 0' },
              })}
              className="form-input"
              placeholder="2000000"
            />
            {errors.maxDiscountAmount && (
              <p className="error-text">{errors.maxDiscountAmount.message}</p>
            )}
          </div>

          <div className="form-group">
            <label>Ngày bắt đầu</label>
            <DatePicker
              selected={startDate}
              onChange={(date) => setStartDate(date)}
              dateFormat="yyyy-MM-dd"
              className="form-input"
              placeholderText="Chọn ngày bắt đầu"
            />
          </div>

          <div className="form-group">
            <label>Ngày kết thúc</label>
            <DatePicker
              selected={endDate}
              onChange={(date) => setEndDate(date)}
              dateFormat="yyyy-MM-dd"
              className="form-input"
              placeholderText="Chọn ngày kết thúc"
            />
          </div>
        </div>

        <div className="form-group full-width">
          <button type="submit" className="submit-btn">
            Tạo Voucher
          </button>
        </div>
      </form>
    </div>
  );
};

export default AddVoucherForm;