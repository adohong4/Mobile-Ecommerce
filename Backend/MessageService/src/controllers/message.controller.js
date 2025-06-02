'use strict';


const MessageService = require('../services/message.service');
const { OK, CREATED } = require('../core/success.response');

class MessageController {

    sendMessage = async (req, res, next) => {
        try {
            const result = await MessageService.sendMessage(req, res);
            new CREATED({
                message: 'Send message',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    getMessages = async (req, res, next) => {
        try {
            const result = await MessageService.getMessages(req, res);
            new OK({
                message: 'Get messages',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    sendAdminMessage = async (req, res, next) => {
        try {
            const result = await MessageService.sendAdminMessage(req, res);
            new OK({
                message: 'Admin send messages',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }

    getAdminMessages = async (req, res, next) => {
        try {
            const result = await MessageService.getAdminMessages(req, res);
            new OK({
                message: 'Admin Get messages',
                metadata: result
            }).send(res);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new MessageController();