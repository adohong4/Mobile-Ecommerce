import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import { format } from 'date-fns';
import '../styles/styles.css';

const AddVoucherForm = () => {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();

  const [startDate, setStartDate] = useState(null);
  const [endDate, setEndDate] = useState(null);

  const onSubmit = (data) => {
    if (!startDate || !endDate) {
      alert('Vui lòng chọn ngày bắt đầu và kết thúc.');
      return;
    }

    const voucher = {
      ...data,
      discountValue: parseInt(data.discountValue),
      minOrderValue: parseInt(data.minOrderValue),
      usageLimit: parseInt(data.usageLimit),
      startDate: format(startDate, 'yyyy-MM-dd'),
      endDate: format(endDate, 'yyyy-MM-dd'),
    };

    console.log('Voucher đã tạo:', voucher);
    alert('Voucher đã được tạo!');
  };

  return (
    <div className="form-container">
      <h2 className="form-title"> Thêm Voucher Mới</h2>
      <form onSubmit={handleSubmit(onSubmit)} className="form-two-column">
        <div className="form-column">
          <div className="form-group">
            <label>Mã voucher</label>
            <input
              {...register('code', { required: true })}
              className="form-input"
              placeholder="AUTUMN2026"
            />
            {errors.code && <p className="error-text">Không được để trống.</p>}
          </div>

          <div className="form-group">
            <label>Loại giảm giá</label>
            <select {...register('discountType', { required: true })} className="form-input">
              <option value="FIXED_AMOUNT">Giảm giá cố định</option>
              <option value="PERCENTAGE">Phần trăm</option>
            </select>
          </div>

          <div className="form-group">
            <label>Giá trị giảm</label>
            <input
              type="number"
              {...register('discountValue', { required: true })}
              className="form-input"
              placeholder="200000"
            />
          </div>

          <div className="form-group">
            <label>Giá trị đơn hàng tối thiểu</label>
            <input
              type="number"
              {...register('minOrderValue', { required: true })}
              className="form-input"
              placeholder="1999000"
            />
          </div>
        </div>

        <div className="form-column">
          <div className="form-group">
            <label>Số lượt sử dụng tối đa</label>
            <input
              type="number"
              {...register('usageLimit', { required: true })}
              className="form-input"
              placeholder="20"
            />
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

          <div className="form-group full-width">
            <button type="submit" className="submit-btn">
                Tạo Voucher
            </button>
          </div>
        </div>
      </form>
    </div>
  );
};

export default AddVoucherForm;
