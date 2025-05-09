'use strict';

const advertiseModel = require('../models/advertise.model');
const { BadRequestError } = require('../core/error.response');
const cloudinary = require('../config/cloudinary.config');

class AdvertiseService {
    static async createAdvertise(req, res) {
        try {
            const { classify, recap } = req.body;

            if (!classify) {
                throw new BadRequestError('Cần phân loại quảng cáo');
            }

            let image_filename = "";
            if (req.files) {
                image_filename = req.files.map(file => file.filename);
            } else {
                throw new Error("No file uploaded");
            }

            const newAdvertise = await advertiseModel.create({
                classify,
                recap,
                imageAds: image_filename,
            });

            return newAdvertise;
        } catch (error) {
            throw error;
        }
    }

    static async getAdvertise() {
        try {
            const ads = await advertiseModel.find()
                .sort({ createdAt: -1 })
                .exec();
            return ads;
        } catch (error) {
            throw error;
        }
    }

    static async deleteAdvertise(req) {
        try {
            const { id } = req.params;
            const advertise = await advertiseModel.findById(id);

            if (Array.isArray(advertise.imageAds) && advertise.imageAds.length > 0) {
                const deleteImagePromises = advertise.imageAds.map(async (image) => {
                    if (typeof image !== 'string') {
                        console.warn(`Invalid image path: ${image}`);
                        return;
                    }

                    const imagePath = path.join(__dirname, '../../upload', image);
                    try {
                        await fs.access(imagePath); // Kiểm tra tệp tồn tại
                        await fs.unlink(imagePath); // Xóa tệp
                        console.log(`Đã xóa hình ảnh: ${imagePath}`);
                    } catch (err) {
                        if (err.code === 'ENOENT') {
                            console.warn(`Hình ảnh không tồn tại: ${imagePath}`);
                        } else {
                            console.error(`Lỗi khi xóa hình ảnh: ${imagePath}`, err);
                        }
                    }
                });

                await Promise.all(deleteImagePromises);
            } else {
                console.log('Không có hình ảnh để xóa');
            }
            await advertiseModel.findByIdAndDelete(id);
            return;
        } catch (error) {
            throw error;
        }
    }

    //priority
    static async activeAdvertise(req, res) {
        try {
            const { id } = req.params;
            const advertise = await advertiseModel.findById(id);
            const newActiveStatus = !advertise.status;

            advertise.status = newActiveStatus;
            await advertise.save();

            return advertise;
        } catch (error) {
            throw error;
        }
    }

}

module.exports = AdvertiseService