'use strict';

const messageModel = require("../models/message.model");
const { BadRequestError, ConflictRequestError, AuthFailureError, ForbiddenError } = require("../core/error.response");
const { getReceiverSocketId, io } = require("../config/socket");
const cloudinary = require('../config/config.cloudinary');

class MessageService {
    static async sendMessage(req, res) {
        try {
            const { text, image, video, audio, file } = req.body;
            const { id: receiverId } = req.params;
            const senderId = req.user._id;

            let imgUrl = null;
            if (image) {
                const uploadResponse = await cloudinary.uploader.upload(image);
                imgUrl = uploadResponse.secure_url;
            }

            const newMessage = await messageModel.create({
                senderId,
                receiverId,
                content: text,
                image: imgUrl,
            });

            const receiverSocketId = getReceiverSocketId(receiverId);
            if (receiverSocketId) {
                io.to(receiverSocketId).emit("newMessage", newMessage);
            }

            return newMessage;
        } catch (error) {
            throw error;
        }
    }

    static async getMessages(req, res) {
        try {
            const { id: userToChatId } = req.params;
            const myId = req.user._id;

            const messages = await messageModel.find({
                $or: [
                    { senderId: myId, receiverId: userToChatId },
                    { senderId: userToChatId, receiverId: myId },
                ],
            });

            return messages;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = MessageService;
