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

            let imageUrl = '';
            if (req.file) {
                try {
                    const uploadResponse = await new Promise((resolve, reject) => {
                        cloudinary.uploader.upload_stream({
                            resource_type: 'image',
                        }, (error, result) => {
                            if (error) {
                                return reject(new BadRequestError('Lỗi khi upload ảnh lên Cloudinary'));
                            }
                            resolve(result);
                        }).end(req.file.buffer);
                    });

                    imageUrl = uploadResponse.secure_url;
                } catch (error) {
                    throw new BadRequestError('Lỗi khi upload ảnh: ' + error.message);
                }
            }

            const newAdvertise = await advertiseModel.create({
                classify,
                recap,
                imageAds: imageUrl,
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
            const advertis = await advertiseModel.findById(id);

            if (advertis.imageAds) {
                try {
                    const urlParts = advertis.imageAds.split('/');
                    const fileName = urlParts[urlParts.length - 1];
                    const publicId = fileName.split('.')[0];

                    const destroyResult = await cloudinary.uploader.destroy(publicId);
                } catch (cloudinaryError) {
                    console.error('Lỗi khi xóa ảnh trên Cloudinary:', cloudinaryError);
                }
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